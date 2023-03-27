// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
// import 'package:karmayogi_mobile/base64_rendering.dart';
import 'package:karmayogi_mobile/ui/widgets/_network/no_information_card.dart';
import 'package:karmayogi_mobile/ui/widgets/_profile/completed_course_item.dart';
import 'package:karmayogi_mobile/ui/widgets/_profile/hobbies.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../util/helper.dart';
import './../../../widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';
import './../../../../localization/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';
// import 'dart:developer' as developer;

class ProfilePage extends StatefulWidget {
  static const route = AppUrl.profilePage;
  final Profile profileDetails;
  final int index;
  final List<Course> completedCourse;

  ProfilePage(this.profileDetails, this.index, {this.completedCourse});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SuggestionService suggestionService = SuggestionService();
  final TelemetryService telemetryService = TelemetryService();
  final BadgeService badgeService = BadgeService();
  final LearnService learnService = LearnService();
  final List<ProfileViewer> data = [
    ProfileViewer(year: 1, sales: 2),
    ProfileViewer(year: 2, sales: 9),
    ProfileViewer(year: 3, sales: 7),
    ProfileViewer(year: 4, sales: 1),
    // ProfileViewer(year: 5, sales: 5),
  ];
  bool _certificationSeeAllStatus = false;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  int _start = 0;
  List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    if (_start == 0) {
      allEventsData = [];
      _generateTelemetryData();
    }
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
      TelemetryPageIdentifier.myProfilePageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.myProfilePageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
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
            ),
          ),
        ),
      ));
    }
    return badgeWidgets;
  }

  // Future<void> _createConnectionRequest(id) async {
  //   var _response;
  //   try {
  //     _response = await NetworkService.postConnectionRequest(id);

  //     if (_response['result']['status'] == 'CREATED') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(EnglishLang.connectionRequestSent),
  //           backgroundColor: AppColors.positiveLight,
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(EnglishLang.errorMessage),
  //           backgroundColor: Theme.of(context).errorColor,
  //         ),
  //       );
  //     }
  //     setState(() {});
  //   } catch (err) {
  //     // print(err);
  //   }
  // }

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
            //   margin: const EdgeInsets.only(top: 10),
            //   alignment: Alignment.topLeft,
            //   child: SectionHeading('Badges'),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(left: 20, right: 20),
            //   margin: const EdgeInsets.only(top: 10, bottom: 10),
            //   child: FutureBuilder(
            //     future: badgeService.getCanEarnBadges(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<Badge>> snapshot) {
            //       if (snapshot.hasData) {
            //         List<Badge> badges = snapshot.data;
            //         return createBadges(badges);
            //       } else {
            //         // return Center(child: CircularProgressIndicator());
            //         return Center();
            //       }
            //     },
            //   ),
            // ),
            Container(
              // margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.careerHistory),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(children: <Widget>[
                (widget.profileDetails.experience != null &&
                        widget.profileDetails.experience.length > 0)
                    ? (widget.profileDetails.experience[0]['designation'] !=
                                '' &&
                            widget.profileDetails.experience[0]
                                    ['designation'] !=
                                null)
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.profileDetails.experience.length,
                            itemBuilder: (context, index) {
                              return ExperienceItem(
                                  widget.profileDetails.experience[index],
                                  index);
                            })
                        : NoInformationCard()
                    : NoInformationCard(),
              ]),
            ),
            widget.profileDetails != null
                ? Container(
                    width: 350,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: ProfileStatus(profileDetails: widget.profileDetails),
                  )
                : Center(),
            Container(
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.academics),
            ),
            Helper.checkEducationIsFilled(widget.profileDetails.education)
                ? Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(children: <Widget>[
                      // Helper.checkEducationIsFilled(
                      //         widget.profileDetails.education)
                      //     ? Container(
                      //         alignment: Alignment.topLeft,
                      //         child: SectionHeading(EnglishLang.education),
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
            // Container(
            //   margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            //   color: Colors.white,
            //   child: Visualization(
            //     heading: 'Your profile was viewed 24 times last week',
            //     subHeading: 'Number of unique visitors to your profile',
            //     legend: 'Profile views',
            //     displayTotalViews: true,
            //     chartType: ChartType.profileViews,
            //     data: data,
            //   ),
            // ),
            (widget.completedCourse != null &&
                    widget.completedCourse.length > 0)
                ? Container(
                    margin: const EdgeInsets.only(bottom: 16, top: 0),
                    padding: const EdgeInsets.all(4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 16, left: 16),
                            child: Text(
                              EnglishLang.certifications,
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.12,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.completedCourse.length > 3
                                  ? (_certificationSeeAllStatus
                                      ? widget.completedCourse.length
                                      : 3)
                                  : (widget.completedCourse.length < 3
                                      ? widget.completedCourse.length
                                      : 3),
                              itemBuilder: (context, index) {
                                return CompletedCourseItemCard(
                                  name: widget
                                      .completedCourse[index].raw['courseName'],
                                  description: widget.completedCourse[index]
                                      .raw['description'],
                                  image: widget.completedCourse[index]
                                      .raw['courseLogoUrl'],
                                  issuedDate: (widget
                                                  .completedCourse[index]
                                                  .raw['issuedCertificates']
                                                  .length >
                                              0 &&
                                          widget.completedCourse[index]
                                                      .raw['issuedCertificates']
                                                  [0]['lastIssuedOn'] !=
                                              null)
                                      ? 'Issued on ${DateFormat.yMMMd().format(DateTime.parse((widget.completedCourse[index].raw['issuedCertificates'][0]['lastIssuedOn'])))}'
                                      : EnglishLang.certificateIsBeingGenerated,
                                  completionCertificate:
                                      widget.completedCourse[index],
                                );
                              },
                            ),
                          ),
                          widget.completedCourse.length > 3
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _certificationSeeAllStatus =
                                          !_certificationSeeAllStatus;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text((!_certificationSeeAllStatus
                                            ? 'Show all'
                                            : 'Show less'))),
                                  ))
                              : Center()
                        ]))
                : Center(),
            widget.profileDetails.competencies != null &&
                    widget.profileDetails.competencies.length > 0
                ? Container(
                    alignment: Alignment.topLeft,
                    child: SectionHeading(EnglishLang.competencies),
                  )
                : Center(),
            widget.profileDetails.competencies != null &&
                    widget.profileDetails.competencies.length > 0
                ? Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Competencies(widget.profileDetails.competencies))
                : Center(),
            Container(
              alignment: Alignment.topLeft,
              child: SectionHeading(EnglishLang.hobbies),
            ),
            widget.profileDetails.interests != null &&
                    (widget.profileDetails.interests['hobbies'] != null &&
                        widget.profileDetails.interests['hobbies'].length > 0)
                ? Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Hobbies(widget.profileDetails.interests["hobbies"]))
                : NoInformationCard(
                    specialFieldText: EnglishLang.hobbies.toLowerCase(),
                  ),
            SizedBox(
              height: 80,
            )

            // Container(
            //   alignment: Alignment.topLeft,
            //   child: SectionHeading(EnglishLang.peopleYouMayKnow),
            // ),
            // Container(
            //   height: 280,
            //   width: double.infinity,
            //   padding: const EdgeInsets.only(top: 20, bottom: 18),
            //   child: FutureBuilder(
            //     future: suggestionService.getSuggestions(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<Suggestion>> snapshot) {
            //       if (snapshot.hasData) {
            //         List<Suggestion> suggestions = snapshot.data;
            //         return ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: suggestions.length,
            //           itemBuilder: (context, index) {
            //             return PeopleItem(
            //                 suggestion: suggestions[index],
            //                 parentAction: _createConnectionRequest);
            //             // return Center();
            //           },
            //         );
            //       } else {
            //         // return Center(child: CircularProgressIndicator());
            //         return Center();
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
