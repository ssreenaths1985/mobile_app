import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:karmayogi_mobile/respositories/_respositories/badge_repository.dart';
import 'package:karmayogi_mobile/ui/widgets/_network/no_information_card.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../respositories/_respositories/network_respository.dart';
import '../../../../respositories/_respositories/profile_repository.dart';
import '../../../../util/helper.dart';
import '../../../widgets/_profile/hobbies.dart';
import './../../../widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';
import './../../../../localization/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class NetworkProfileDetail extends StatefulWidget {
  static const route = AppUrl.profilePage;
  final Profile profileDetails;
  final profileId;

  NetworkProfileDetail(this.profileDetails, this.profileId);
  @override
  _NetworkProfileDetailState createState() => _NetworkProfileDetailState();
}

class _NetworkProfileDetailState extends State<NetworkProfileDetail> {
  final SuggestionService suggestionService = SuggestionService();
  final BadgeService badgeService = BadgeService();
  final TelemetryService telemetryService = TelemetryService();

  List<dynamic> _requestedConnections = [];

  final List<ProfileViewer> data = [
    ProfileViewer(year: 1, sales: 2),
    ProfileViewer(year: 2, sales: 9),
    ProfileViewer(year: 3, sales: 7),
    ProfileViewer(year: 4, sales: 1),
    // ProfileViewer(year: 5, sales: 5),
  ];

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String pageIdentifier;
  int _start = 0;
  List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    // print(widget.profileId);
    if (_start == 0) {
      allEventsData = [];
      pageIdentifier = TelemetryPageIdentifier.userProfilePageId
          .replaceAll(':userId', widget.profileId);
      _generateTelemetryData();
    }
    _getRequestedConnections();
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData1 = Telemetry.getImpressionTelemetryEvent(
      deviceIdentifier,
      userId,
      departmentId,
      pageIdentifier,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      pageIdentifier,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _generateInteractTelemetryData(String contentId) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.userCard);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    allEventsData.add(eventData);
  }

  createBadges(badges) {
    var badgeWidgets = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[],
    );
    int length = badges.length > 5 ? 5 : badges.length;
    for (var i = 0; i < length; i++) {
      badgeWidgets.children.add(CircleAvatar(
        radius: 24,
        // backgroundColor: Colors.black,
        child: Center(
          child: SvgPicture.asset(
            'assets/img/Badge_2.svg',
            fit: BoxFit.cover,
          ),
        ),
      ));
    }
    if ((badges.length - 5) > 0) {
      badgeWidgets.children.add(CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.grey08,
        child: Center(
          child: Text(
            '+' + (badges.length - 5).toString(),
            style: GoogleFonts.lato(
              color: AppColors.greys60,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
            ),
          ),
        ),
      ));
    }
    return badgeWidgets;
  }

  Future<void> _createConnectionRequest(id) async {
    var _response;
    try {
      List<Profile> profileDetailsFrom;
      profileDetailsFrom =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById('');
      List<Profile> profileDetailsTo;
      profileDetailsTo =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById(id);
      _response = await NetworkService.postConnectionRequest(
          id, profileDetailsFrom, profileDetailsTo);

      if (_response['result']['status'] == 'CREATED') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.connectionRequestSent),
            backgroundColor: AppColors.positiveLight,
          ),
        );
        await _getRequestedConnections();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.errorMessage),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  _getRequestedConnections() async {
    final response =
        await Provider.of<NetworkRespository>(context, listen: false)
            .getRequestedConnections();
    setState(() {
      _requestedConnections = response;
    });
    // print(_requestedConnections.toString());
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            // Container(
            //   padding: const EdgeInsets.only(left: 20, right: 20),
            //   margin: const EdgeInsets.only(top: 10, bottom: 10),
            //   child: FutureBuilder(
            //     future: Provider.of<BadgeRepository>(context, listen: false)
            //         .getCanEarnBadges(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<Badge>> snapshot) {
            //       if (snapshot.hasData) {
            //         List<Badge> badges = snapshot.data;
            //         return Column(
            //           children: [
            //             Container(
            //               margin: const EdgeInsets.only(top: 10),
            //               alignment: Alignment.topLeft,
            //               child: SectionHeading(EnglishLang.badges),
            //             ),
            //             createBadges(badges)
            //           ],
            //         );
            //       } else {
            //         // return Center(child: CircularProgressIndicator());
            //         return Center();
            //       }
            //     },
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.careerHistory),
            ),
            ((widget.profileDetails.experience != null &&
                        widget.profileDetails.experience.length > 0) &&
                    (widget.profileDetails.experience[0]['designation'] !=
                            null &&
                        widget.profileDetails.experience[0]['designation'] !=
                            ''))
                ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(children: <Widget>[
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  widget.profileDetails.experience.length,
                              itemBuilder: (context, index) {
                                return widget.profileDetails.experience[index]
                                            ['designation'] !=
                                        null
                                    ? ExperienceItem(
                                        widget.profileDetails.experience[index],
                                        index)
                                    : Center();
                              })
                        ]),
                      ),
                    ],
                  )
                : NoInformationCard(),
            Container(
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.academics),
            ),
            Helper.checkEducationIsFilled(widget.profileDetails.education)
                ? Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(children: <Widget>[
                      // Helper.checkEducationIsFilled(widget.profileDetails.education)
                      //     ? Container(
                      //         alignment: Alignment.topLeft,
                      //         child: SectionHeading('Education'),
                      //       )
                      //     : Center(),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.profileDetails.education.length,
                          itemBuilder: (context, index) {
                            return EducationItem(
                                widget.profileDetails.education[index]);
                          })
                    ]),
                  )
                : NoInformationCard(),
            // widget.profileDetails.competencies != null &&
            //         widget.profileDetails.competencies.length > 0
            //     ? Column(
            //         children: [
            //           Container(
            //             alignment: Alignment.topLeft,
            //             child: SectionHeading(EnglishLang.competencies),
            //           ),
            //           Container(
            //               margin: const EdgeInsets.only(top: 10, bottom: 10),
            //               child:
            //                   Competencies(widget.profileDetails.competencies))
            //         ],
            //       )
            //     : Center(),
            widget.profileDetails.rawDetails["interests"] != null &&
                    widget.profileDetails.rawDetails["interests"]["hobbies"]
                            .length >
                        0
                ? Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: SectionHeading(EnglishLang.hobbies),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Hobbies(widget.profileDetails
                              .rawDetails["interests"]["hobbies"]))
                    ],
                  )
                : Center(),
            Container(
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.similarProfiles),
            ),
            Container(
              height: 282,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: FutureBuilder(
                future: suggestionService.getSuggestions(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Suggestion>> snapshot) {
                  if (snapshot.hasData) {
                    List<Suggestion> suggestions = snapshot.data;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        return PeopleItem(
                          suggestion: suggestions[index],
                          parentAction1: _createConnectionRequest,
                          parentAction2: _generateInteractTelemetryData,
                          requestedConnections: _requestedConnections,
                        );
                        // return Center();
                      },
                    );
                  } else {
                    // return Center(child: CircularProgressIndicator());
                    return Center();
                  }
                },
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(top: 10, bottom: 10),
            //   child: FutureBuilder(
            //     future: badgeService.getEarnedBadges(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<Badge>> snapshot) {
            //       if (snapshot.hasData) {
            //         List<Badge> badges = snapshot.data;
            //         return Column(children: <Widget>[
            //           badges.length > 0
            //               ? Container(
            //                   alignment: Alignment.topLeft,
            //                   child: SectionHeading('Certifications'),
            //                 )
            //               : Center(),
            //           ListView.builder(
            //             physics: NeverScrollableScrollPhysics(),
            //             shrinkWrap: true,
            //             itemCount: badges.length,
            //             itemBuilder: (context, index) {
            //               return CertificationItem(badges[index]);
            //             },
            //           )
            //         ]);
            //       } else {
            //         // return Center(child: CircularProgressIndicator());
            //         return Center();
            //       }
            //     },
            //   ),
            // ),
            // widget.profileDetails.competencies != null
            //     ? Container(
            //         alignment: Alignment.topLeft,
            //         child: SectionHeading('Competencies'),
            //       )
            //     : Center(),
            // widget.profileDetails.competencies != null
            //     ? Container(
            //         margin: const EdgeInsets.only(top: 10, bottom: 10),
            //         child: Competencies(widget.profileDetails.competencies))
            //     : Center(),
          ],
        ),
      ),
    );
  }
}
