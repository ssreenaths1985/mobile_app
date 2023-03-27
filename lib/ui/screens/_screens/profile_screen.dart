import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:provider/provider.dart';
import '../../../respositories/_respositories/learn_repository.dart';
import './../../pages/index.dart';
import './../../screens/index.dart';
import './../../widgets/index.dart';
import './../../../constants/index.dart';
import './../../../models/index.dart';
// import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  static const route = AppUrl.profilePage;
  final int index;

  ProfileScreen({Key key, this.index}) : super(key: key);

  @override
  ProfileScreenState createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  List<Profile> _profileDetails;
  List<Course> _completedLearningcourses;
  double appBarHeight = 220;

  @override
  void initState() {
    super.initState();
    // setAppBarHeight();
    if (widget.index == (VegaConfiguration.isEnabled ? 4 : 2)) {
      _getCompletedLearningCourses();
    }

    if (widget.index == (VegaConfiguration.isEnabled ? 4 : 2)) {
      _controller = TabController(
          length: ProfileTab.items.length, vsync: this, initialIndex: 0);
    }
  }

  Future<List<Course>> _getCompletedLearningCourses() async {
    final continueLearningCourses =
        await Provider.of<LearnRepository>(context, listen: false)
            .getContinueLearningCourses();
    // _AnimatedMovies = AllMovies.where((i) => i.isAnimated).toList();
    _completedLearningcourses = continueLearningCourses
        .where((course) => course.raw['completionPercentage'] == 100)
        .toList();
    return _completedLearningcourses;
  }

  Future<List<Profile>> _getProfileDetails() async {
    _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    // setAppBarHeight();
    // print(_profileDetails[0].toString());
    return _profileDetails;
  }

  void setAppBarHeight() {
    if (_profileDetails[0].professionalDetails.length > 0) {
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
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.index == (VegaConfiguration.isEnabled ? 4 : 2)
        ? Scaffold(
            // Tab controller
            body: DefaultTabController(
                length: ProfileTab.items.length,
                child: SafeArea(
                  child: FutureBuilder(
                      future: _getProfileDetails(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Profile>> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          // List<Profile> profileDetails = snapshot.data;

                          return NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[
                                SliverAppBar(
                                    pinned: false,
                                    expandedHeight: 260,
                                    flexibleSpace: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Padding(
                                            //   padding:
                                            //       EdgeInsets.only(top: 20, left: 20),
                                            //   child: Icon(
                                            //     Icons.account_circle,
                                            //     color: AppColors.primaryThree,
                                            //   ),
                                            // ),
                                            // Padding(
                                            //   padding:
                                            //       EdgeInsets.only(left: 10, top: 23),
                                            //   child: Text(
                                            //     'Profile',
                                            //     style: GoogleFonts.montserrat(
                                            //       color: AppColors.greys87,
                                            //       fontSize: 16.0,
                                            //       fontWeight: FontWeight.w600,
                                            //     ),
                                            //   ),
                                            // ),
                                            Spacer(),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.settings,
                                                  color: AppColors.greys60,
                                                ),
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      AppUrl.settingsPage);
                                                }),
                                          ],
                                        ),
                                        Container(
                                          child:
                                              BasicDetails(_profileDetails[0]),
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
                                        for (var tabItem in ProfileTab.items)
                                          Container(
                                            // width: 110,
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: Tab(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  tabItem.title.toUpperCase(),
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
                                  future: Future.delayed(
                                      Duration(milliseconds: 500)),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return TabBarView(
                                      controller: _controller,
                                      children: [
                                        ProfilePage(
                                          _profileDetails[0],
                                          widget.index,
                                          completedCourse:
                                              _completedLearningcourses,
                                        ),
                                        MyDiscussionsPage(
                                          isProfilePage: true,
                                        ),
                                        SavedPostsPage(),
                                      ],
                                    );
                                  }),
                            ),
                          );
                        } else {
                          // return Center(child: CircularProgressIndicator());
                          return PageLoader();
                        }
                      }),
                )),
            floatingActionButton: OpenContainer(
              openColor: Colors.white,
              transitionDuration: Duration(milliseconds: 750),
              openBuilder: (context, _) => EditProfileScreen(),
              closedShape: CircleBorder(),
              closedColor: Colors.white,
              transitionType: ContainerTransitionType.fadeThrough,
              closedBuilder: (context, openContainer) => FloatingActionButton(
                onPressed: openContainer,
                child: Icon(Icons.edit),
                backgroundColor: AppColors.primaryThree,
              ),
            ))
        : Center();
  }
}
