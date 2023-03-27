import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';
import './../../../../ui/pages/index.dart';
import './../../../../ui/widgets/index.dart';

class NetworkProfile extends StatefulWidget {
  static const route = AppUrl.networkProfilePage;

  final profileId;

  NetworkProfile(this.profileId);

  @override
  _NetworkProfileState createState() => _NetworkProfileState();
}

class _NetworkProfileState extends State<NetworkProfile>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<Profile> _profileDetails;
  double appBarHeight = 220;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    // print("We are in network profile");
    super.initState();
    _controller = TabController(
        length: NetworkProfileTab.items.length, vsync: this, initialIndex: 0);
    _generateTelemetryData();
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
      TelemetryPageIdentifier.userProfilePageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.userProfilePageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void setAppBarHeight() {
    if (_profileDetails[0].professionalDetails[0]['designation'] != null &&
        _profileDetails[0].professionalDetails[0]['name'] != null &&
        _profileDetails[0].experience[0]['location'] != null) {
      setState(() {
        appBarHeight = 250;
      });
    } else if (_profileDetails[0].professionalDetails[0]['designation'] !=
            null ||
        _profileDetails[0].professionalDetails[0]['name'] != null ||
        _profileDetails[0].experience[0]['location'] != null) {
      setState(() {
        appBarHeight = 220;
      });
    } else if (_profileDetails[0].professionalDetails[0]['designation'] ==
            null ||
        _profileDetails[0].professionalDetails[0]['name'] != null &&
            _profileDetails[0].experience[0]['location'] != null) {
      setState(() {
        appBarHeight = 200;
      });
    }
  }

  Future<List<Profile>> _getProfileDetails() async {
    // print("We are in network profile page");
    _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById(widget.profileId);
    // setAppBarHeight();
    // print(_profileDetails.toString());
    return _profileDetails;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tab controller
      body: DefaultTabController(
        length: NetworkProfileTab.items.length,
        child: SafeArea(
          child: FutureBuilder(
            future: _getProfileDetails(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  List<Profile> profileDetails = snapshot.data;
                  // print(profileDetails[0].personalDetails.toString());
                  return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                            pinned: false,
                            expandedHeight: 250,
                            flexibleSpace: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 57.0,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Container(
                                  child: BasicDetails(profileDetails[0]),
                                )
                              ],
                            )),
                        SliverPersistentHeader(
                          delegate: SilverAppBarDelegate(
                            TabBar(
                              isScrollable: true,
                              indicator: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.primaryThree,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              indicatorColor: Colors.white,
                              labelPadding: EdgeInsets.only(top: 0.0),
                              unselectedLabelColor: AppColors.greys60,
                              labelColor: AppColors.primaryThree,
                              labelStyle: GoogleFonts.lato(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                              ),
                              unselectedLabelStyle: GoogleFonts.lato(
                                fontSize: 10.0,
                                fontWeight: FontWeight.normal,
                              ),
                              tabs: [
                                for (var tabItem in NetworkProfileTab.items)
                                  Container(
                                    // width: 110,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Tab(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          tabItem.title,
                                          style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                              controller: _controller,
                            ),
                          ),
                          pinned: true,
                          floating: false,
                        ),
                      ];
                    },

                    // TabBar view
                    body: Container(
                      color: AppColors.lightBackground,
                      child: FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 500)),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return TabBarView(
                              controller: _controller,
                              children: [
                                NetworkProfileDetail(
                                    profileDetails[0], widget.profileId),
                                MyDiscussionsPage(
                                  wid: widget.profileId,
                                  isProfilePage: true,
                                ),
                                BestPostsPage(widget.profileId),
                              ],
                            );
                          }),
                    ),
                  );
                } else {
                  return Center();
                }
              } else {
                // return Center(child: CircularProgressIndicator());
                return PageLoader();
              }
            },
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your onPressed code here!
      //   },
      //   child: Icon(Icons.more_horiz),
      //   backgroundColor: AppColors.primaryThree,
      // ),
    );
  }
}
