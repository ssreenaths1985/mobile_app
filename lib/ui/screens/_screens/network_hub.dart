import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/_models/telemetry_event_model.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import './../../../ui/pages/_pages/network/my_mdo.dart';
import './../../../ui/pages/index.dart';
import '../../../constants/index.dart';
import './../../widgets/index.dart';
import './../../../localization/index.dart';

class NetworkHub extends StatefulWidget {
  static const route = AppUrl.networkHub;

  @override
  _NetworkHubState createState() => _NetworkHubState();
}

class _NetworkHubState extends State<NetworkHub>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String deviceIdentifier;
  var telemetryEventData;

  final service = HttpClient();

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: NetworkTab.items.length, vsync: this, initialIndex: 0);
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
        TelemetryPageIdentifier.networkHomePageId.replaceAll('home', contentId),
        userSessionId,
        messageIdentifier,
        contentId + '-tab',
        TelemetrySubType.sideMenu);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _triggerInteractTelemetryData(int index) {
    if (index == 0) {
      _generateInteractTelemetryData(NetworkTab.items[0].title
          .toLowerCase()
          .toString()
          .replaceAll(' ', '-'));
    } else if (index == 1) {
      _generateInteractTelemetryData(NetworkTab.items[1].title
          .toLowerCase()
          .toString()
          .replaceAll(' ', '-'));
    } else if (index == 2) {
      _generateInteractTelemetryData(NetworkTab.items[2].title
          .toLowerCase()
          .toString()
          .replaceAll(' ', '-'));
    } else {
      _generateInteractTelemetryData(NetworkTab.items[3].title
          .toLowerCase()
          .toString()
          .replaceAll(' ', '-'));
    }
  }

  void _switchIntoYourMDOTab(int tabIndex) {
    setState(() {
      _controller.index = tabIndex;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      titlePadding: EdgeInsets.fromLTRB(60.0, 0.0, 10.0, 15.0),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: SvgPicture.asset(
                              'assets/img/Network.svg',
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 12),
                            child: Text(
                              EnglishLang.network,
                              style: GoogleFonts.montserrat(
                                color: AppColors.greys87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                            child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: AppColors.greys60,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TextSearchPage()));
                                }),
                          ),
                        ],
                      ),
                    ),
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
                          for (var tabItem in NetworkTab.items)
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
              body: Container(
                color: AppColors.lightBackground,
                child: FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 500)),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return TabBarView(
                        controller: _controller,
                        children: [
                          NetworkHomePage(parentAction: _switchIntoYourMDOTab),
                          MyConnections(),
                          NetworkRequests(),
                          MyMDO(),
                          MyMDO(
                            isRecommended: true,
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: BottomBar(),
    );
  }
}
