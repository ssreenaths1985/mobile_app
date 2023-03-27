import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/_models/telemetry_event_model.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import './../../../ui/pages/index.dart';
import '../../../constants/index.dart';
import './../../widgets/index.dart';
import './../../../localization/index.dart';

class CompetencyHub extends StatefulWidget {
  static const route = AppUrl.networkHub;
  final bool isAddedCompetencies;
  CompetencyHub({this.isAddedCompetencies = false});

  @override
  _CompetencyHubState createState() => _CompetencyHubState();
}

class _CompetencyHubState extends State<CompetencyHub>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _tabIndex = 0;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  final service = HttpClient();

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: CompetencyTab.items.length, vsync: this, initialIndex: 0);
    _controller.addListener(() {
      setState(() {
        _tabIndex = _controller.index;
      });
    });
  }

  void _checkAddCompetencyStatus(bool value) {
    if (value == true) {
      setState(() {
        _controller.index = 1;
      });
    }
  }

  void _generateInteractTelemetryData(String contentId) async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        contentId == TelemetrySubType.competencyHome
            ? TelemetryPageIdentifier.competencyHomePageId
            : TelemetryPageIdentifier.allCompetenciesPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.sideMenu);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _triggerInteractTelemetryData(int index) {
    if (index == 0) {
      // print('yourCompetencies-menu');
      _generateInteractTelemetryData(TelemetrySubType.competencyHome);
    } else if (index == 1) {
      // print('allCompetencies-menu');
      _generateInteractTelemetryData(TelemetrySubType.allCompetencies);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          duration: Duration(milliseconds: 0),
          child: DefaultTabController(
            length: NetworkTab.items.length,
            child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      pinned: false,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding:
                            EdgeInsets.fromLTRB(60.0, 0.0, 10.0, 15.0),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon(
                            //   Icons.supervisor_account,
                            //   color: AppColors.primaryThree,
                            // ),
                            SvgPicture.asset(
                              'assets/img/competencies.svg',
                              width: 24.0,
                              height: 24.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 13.0, top: 3.0),
                              child: Text(
                                EnglishLang.competencies,
                                style: GoogleFonts.montserrat(
                                  color: AppColors.greys87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: SilverAppBarDelegate(
                        TabBar(
                          isScrollable: false,
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
                            for (var tabItem in CompetencyTab.items)
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
                          onTap: (value) =>
                              _triggerInteractTelemetryData(_controller.index),
                        ),
                      ),
                      pinned: true,
                      floating: false,
                    ),
                  ];
                },

                // TabBar view
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Container(
                    color: AppColors.lightBackground,
                    child: FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 500)),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return TabBarView(
                            controller: _controller,
                            children: [
                              YourCompetenciesPage(
                                checkAddCompetencyStatus:
                                    _checkAddCompetencyStatus,
                                currentTab:
                                    widget.isAddedCompetencies == true ? 2 : 0,
                              ),
                              AllCompetenciesPage(),
                              // DesiredCompetenciesPage(),
                            ],
                          );
                        }),
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomSheet:
            Container(height: _tabIndex == 0 ? 60 : 0, child: BottomBar()));
  }
}
