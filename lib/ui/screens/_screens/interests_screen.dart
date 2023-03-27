import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/app_routes.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/models/_models/profile_model.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/interests/current_competencies.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/interests/platform_walkthrough.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/interests/roles_and_activities.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/interests/topics.dart';
import 'package:karmayogi_mobile/ui/screens/_screens/welcome_screen.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/interests_tab.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:provider/provider.dart';

import '../../../constants/_constants/color_constants.dart';
import '../../../localization/_langs/english_lang.dart';
import '../../../respositories/_respositories/profile_repository.dart';
import '../../../services/_services/profile_service.dart';

class InterestsScreen extends StatefulWidget {
  final bool fromWelcome;
  final bool fromAppStart;
  const InterestsScreen(
      {Key key, this.fromWelcome = true, this.fromAppStart = true})
      : super(key: key);
  static const route = AppUrl.interestsPage;

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedTabIndex = 0;
  final ProfileService profileService = ProfileService();
  List<Profile> _profileDetails;
  int _selectedTopicsLength = 0;
  int _selectedRolesLength = 0;
  int _selectedDesiredTopicsLength = 0;

  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: InterestsTab.items.length, vsync: this, initialIndex: 0);
    // _controller.index = 1;

    // _selectedTabIndex = 0;
    _controller.addListener(() {
      setState(() {
        _selectedTabIndex = _controller.index;
      });
    });
    _getProfileDetails();
    _storage.write(
        key: Storage.guidedScreenStatus,
        value: EnglishLang.guidedScreenStarted);
  }

  _getBottomSheetStatus(value) async {
    if (value) {
      await _getProfileDetails();
    }
  }

  _navigateToForward(index) async {
    switch (index) {
      case 0:
        setState(() {
          _controller.animateTo(1);
        });
        break;
      case 1:
        setState(() {
          _controller.animateTo(2);
        });
        break;

      case 2:
        setState(() {
          _controller.animateTo(3);
        });
        break;

      default:
        setState(() {
          _controller.animateTo(4);
        });
        break;
    }
  }

  // _navigateToBackward(index) async {
  //   switch (index) {
  //     case 3:
  //       setState(() {
  //         _controller.animateTo(2);
  //       });
  //       break;
  //     case 2:
  //       setState(() {
  //         _controller.animateTo(1);
  //       });
  //       break;

  //     default:
  //       setState(() {
  //         _controller.animateTo(0);
  //       });
  //       break;
  //   }
  // }

  Future<List<Profile>> _getProfileDetails() async {
    _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    setState(() {
      _selectedRolesLength = _profileDetails[0].userRoles.length;
      _selectedTopicsLength = _profileDetails[0].selectedTopics.length;
      _selectedDesiredTopicsLength = _profileDetails[0].desiredTopics.length;
    });
    // print('Profile data: ' + _profileDetails[0].rawDetails.toString());
    // await _populateFields();
    return _profileDetails;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Index: ' + _selectedTabIndex.toString());
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DefaultTabController(
          length: InterestsTab.items.length,
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: false,
                    title: Padding(
                      padding: EdgeInsets.only(top: 3.0),
                      child: Image.asset(
                        'assets/img/igot_icon.png',
                        width: 110,
                        // height: 28,
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    // flexibleSpace: FlexibleSpaceBar(
                    //   centerTitle: true,
                    //   titlePadding: EdgeInsets.fromLTRB(40.0, 0.0, 10.0, 0.0),
                    //   title: Padding(
                    //     padding: EdgeInsets.only(left: 16, top: 0),
                    //     child: Row(
                    //       children: [
                    //         Container(
                    //           width: MediaQuery.of(context).size.width * 0.63,
                    //           child: Text(
                    //             "Enter all your \‘Role & Activities\’ to complete your profile",
                    //             style: GoogleFonts.lato(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w700,
                    //                 letterSpacing: 0.25,
                    //                 height: 1.429),
                    //           ),
                    //         ),
                    //         Container(
                    //           width: MediaQuery.of(context).size.width * 0.20,
                    //           child: ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               onPrimary: AppColors.primaryThree,
                    //               primary: Colors.white,
                    //               minimumSize: const Size.fromHeight(36), // NEW
                    //               side: BorderSide(
                    //                   width: 1, color: AppColors.grey16),
                    //             ),
                    //             onPressed: () async {
                    //               // await _shareCertificate();
                    //             },
                    //             child: Text(
                    //               'Skip',
                    //               style: GoogleFonts.lato(
                    //                   height: 1.429,
                    //                   letterSpacing: 0.5,
                    //                   fontSize: 14,
                    //                   color: AppColors.primaryThree,
                    //                   fontWeight: FontWeight.w700),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
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
                            for (var tabItem in InterestsTab.items)
                              Container(
                                // width: 125.0,
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
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
                          onTap: (value) {
                            setState(() {
                              _selectedTabIndex = value;
                            });
                            // if (_selectedRolesLength == 0) {
                            //   _controller.index = 0;
                            // }
                            // if (_selectedRolesLength > 0 &&
                            //     _selectedTopicsLength == 0) {
                            //   _controller.index = 1;
                            // }

                            // _triggerInteractTelemetryData(_controller.index),
                          }),
                    ),
                    pinned: true,
                    floating: false,
                  ),
                ];
              },

              // TabBar view
              body: Container(
                // color: AppColors.lightBackground,
                child: FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 500)),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _controller,
                        children: [
                          RolesAndActivities(
                            getRoleFilledStatus: _getBottomSheetStatus,
                          ),
                          Topics(
                            getTopicSelectedStatus: _getBottomSheetStatus,
                          ),
                          CurrentCompetencies(),
                          CurrentCompetencies(
                            isDesiredCompetencies: true,
                          ),
                          PlatformWalkThrough()
                        ],
                      );
                    }),
              ),
            ),
          ),
        ),
        bottomSheet: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              // height: _activeTabIndex == 0 ? 60 : 0,
              width: double.infinity,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primaryThree,
                        minimumSize: const Size.fromHeight(36), // NEW
                      ),
                      onPressed: () async {
                        if (_selectedTabIndex != 4) {
                          await _navigateToForward(_selectedTabIndex);
                        } else {
                          _storage.write(
                              key: Storage.guidedScreenStatus,
                              value: EnglishLang.guidedScreenEnded);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => CustomTabs(
                                        customIndex: 0,
                                      )));
                          // Navigator.pop(context);
                        }
                      },
                      child: Text(
                        (_selectedTabIndex != 4)
                            ? ('Go to' +
                                (_selectedTabIndex == 0
                                        ? EnglishLang.topics
                                        : _selectedTabIndex == 1
                                            ? EnglishLang.currentCompetencies
                                            : _selectedTabIndex == 2
                                                ? EnglishLang.desiredCompetency
                                                : EnglishLang
                                                    .platformWalkthrough)
                                    .split('.')
                                    .last)
                            : 'Done',
                        style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.429,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        minimumSize: const Size.fromHeight(36), // NEW
                        side: BorderSide(width: 1, color: AppColors.grey16),
                      ),
                      onPressed: _selectedTabIndex != 0
                          ? () {
                              setState(() {
                                _controller.animateTo(_selectedTabIndex - 1);
                              });
                            }
                          : (_selectedTabIndex == 0 && widget.fromWelcome
                              ? () {
                                  if (widget.fromAppStart) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => WelcomeScreen(),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                  }
                                  // Navigator.pop(context);
                                }
                              : (_selectedTabIndex == 0 &&
                                      (_selectedRolesLength > 0 &&
                                          (_selectedTopicsLength > 0 ||
                                              _selectedDesiredTopicsLength > 0))
                                  ? () {
                                      _storage.write(
                                          key: Storage.guidedScreenStatus,
                                          value: EnglishLang.guidedScreenEnded);
                                      Navigator.pop(context);
                                    }
                                  : null)),
                      child: Text(
                        (_selectedTabIndex != 0)
                            ? ('Back to' +
                                (_selectedTabIndex == 4
                                        ? EnglishLang.desiredCompetency
                                        : _selectedTabIndex == 3
                                            ? EnglishLang.currentCompetencies
                                            : _selectedTabIndex == 2
                                                ? EnglishLang.topics
                                                : EnglishLang
                                                    .rolesAndActivities)
                                    .split('.')
                                    .last)
                            : (widget.fromWelcome
                                ? 'Go back to Welcome'
                                : 'Cancel'),
                        style: TextStyle(
                            fontSize: 14,
                            color: ((!widget.fromWelcome &&
                                        _selectedTabIndex == 0) &&
                                    (_selectedRolesLength == 0 &&
                                        (_selectedTopicsLength == 0 &&
                                            _selectedDesiredTopicsLength == 0)))
                                ? AppColors.grey40
                                : AppColors.primaryThree,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
