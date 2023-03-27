// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/competency_repository.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:karmayogi_mobile/services/index.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../index.dart';
// import './../../../../constants/index.dart';
// import './../../../widgets/index.dart';
// import './../../../../services/index.dart';

class YourCompetenciesPage extends StatefulWidget {
  final ValueChanged<bool> checkAddCompetencyStatus;
  final currentTab;
  YourCompetenciesPage({this.checkAddCompetencyStatus, this.currentTab});
  @override
  _YourCompetenciesPageState createState() => _YourCompetenciesPageState();
}

class _YourCompetenciesPageState extends State<YourCompetenciesPage>
    with SingleTickerProviderStateMixin {
  List<Profile> _profileDetails;
  List<BrowseCompetencyCardModel> _profileCompetencies = [];
  // List<BrowseCompetencyCardModel> _desiredCompetencies = [];
  List<BrowseCompetencyCardModel> _recommendedCompetenciesFromWat = [];
  final TelemetryService telemetryService = TelemetryService();

  TabController _controller;
  // int _tabIndex = 0;
  List<BrowseCompetencyCardModel> _recommendedCompetenciesFromFrac = [];

  ScrollController _scrollController;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: CompetencyTypesTab.items.length, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();
    _generateTelemetryData();
    _getData();
    _controller.index = widget.currentTab;
    // _getRecommendedCompetencies();
    // _getAddedCompetencies();
    // _controller.addListener(() {
    //   setState(() {
    //     _tabIndex = _controller.index;
    //   });
    // });
    // _getCompetenciesRecommendedFromFrac();
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
      TelemetryPageIdentifier.competencyHomePageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.competencyHomePageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _generateInteractTelemetryData(String contentId) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.competencyHomePageId + '_' + contentId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.competencyTab);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _triggerInteractTelemetryData(int index) {
    if (index == 0) {
      _generateInteractTelemetryData(TelemetrySubType.recommendedFromFracTab);
    } else if (index == 1) {
      _generateInteractTelemetryData(TelemetrySubType.recommendedFromWatTab);
    } else {
      _generateInteractTelemetryData(TelemetrySubType.addedByYouTab);
    }
  }

  void _checkAddCompetencyStatus(bool value) {
    widget.checkAddCompetencyStatus(value);
    setState(() {});
  }

  Future<bool> _getData() async {
    await _getCompetenciesRecommendedFromFrac();
    await _getRecommendedCompetenciesFromWat();
    await _getAddedCompetencies();
    return true;
    // if (_profileCompetencies != null && _profileCompetencies.length > 0) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  _updateAddedCompetencies(bool value) async {
    await _getAddedCompetencies();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  Future<List<BrowseCompetencyCardModel>> _getAddedCompetencies() async {
    _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    List<dynamic> profileCompetency = _profileDetails.first.competencies;
    // List<dynamic> desiredCompetency = _profileDetails.first.desiredCompetencies;
    _profileCompetencies = profileCompetency
        .map(
          (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
        )
        .toList();
    // _desiredCompetencies = desiredCompetency
    //     .map(
    //       (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
    //     )
    //     .toList();
    return _profileCompetencies;
  }

  Future<List<BrowseCompetencyCardModel>>
      _getRecommendedCompetenciesFromWat() async {
    _recommendedCompetenciesFromWat =
        await Provider.of<CompetencyRepository>(context, listen: false)
            .recommendedFromWat();

    return _recommendedCompetenciesFromWat;
  }

  Future<List<BrowseCompetencyCardModel>>
      _getCompetenciesRecommendedFromFrac() async {
    _recommendedCompetenciesFromFrac =
        await Provider.of<CompetencyRepository>(context, listen: false)
            .recommendedFromFrac();

    return _recommendedCompetenciesFromFrac;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: DefaultTabController(
          length: CompetencyTypesTab.items.length,
          child: FutureBuilder(
              future: _getData(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == true) {
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            EnglishLang.yourCompetencies,
                            style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                letterSpacing: 0.12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 16),
                          child: Container(
                            width: double.infinity,
                            height: 160,
                            child: Card(
                              child: ClipPath(
                                child: Stack(
                                    fit: StackFit.passthrough,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/img/competency_card.svg',
                                        alignment: Alignment.center,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 16,
                                        child: Container(
                                            // height: 84,
                                            // width: double.infinity,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 0, 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  height: 6,
                                                  width: 68,
                                                  color: AppColors.greys60,
                                                ),
                                                Text(
                                                  (_recommendedCompetenciesFromWat
                                                              .length +
                                                          _recommendedCompetenciesFromFrac
                                                              .length)
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    height: 1.5,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  EnglishLang
                                                      .recommendedCompetencies,
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    height: 1.5,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 24),
                                                  child: Container(
                                                    height: 6,
                                                    width: 68,
                                                    color:
                                                        AppColors.primaryThree,
                                                  ),
                                                ),
                                                Text(
                                                  _profileCompetencies.length
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    height: 1.5,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  EnglishLang.yourCompetencies,
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    height: 1.5,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.only(top: 24),
                                                //   child: Container(
                                                //     height: 6,
                                                //     width: 68,
                                                //     color: Colors.red,
                                                //   ),
                                                // ),
                                                // Text(
                                                //   "2",
                                                //   style: GoogleFonts.lato(
                                                //     color: AppColors.greys60,
                                                //     height: 1.5,
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.w700,
                                                //   ),
                                                // ),
                                                // Text(
                                                //   "Competencies with gaps",
                                                //   style: GoogleFonts.lato(
                                                //     color: AppColors.greys60,
                                                //     height: 1.5,
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.w700,
                                                //   ),
                                                // ),
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.only(top: 24.0),
                                                //   child: Container(
                                                //     height: 6,
                                                //     width: 332,
                                                //     color: Colors.deepPurple.shade900,
                                                //   ),
                                                // ),
                                                // Text(
                                                //   "7.7",
                                                //   style: GoogleFonts.lato(
                                                //     color: AppColors.greys60,
                                                //     height: 1.5,
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.w700,
                                                //   ),
                                                // ),
                                                // Text(
                                                //   "Platform average",
                                                //   style: GoogleFonts.lato(
                                                //     color: AppColors.greys60,
                                                //     height: 1.5,
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.w700,
                                                //   ),
                                                // ),
                                              ],
                                            )),
                                      ),
                                    ]),
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                              ),
                            ),
                          ),
                        ),
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
                            for (var tabItem in CompetencyTypesTab.items)
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
                        Container(
                          height: MediaQuery.of(context).size.height +
                              (_recommendedCompetenciesFromFrac.length > 3
                                  ? _recommendedCompetenciesFromFrac.length * 75
                                  : _profileCompetencies.length > 3
                                      ? _profileCompetencies.length * 100
                                      : (300)),
                          color: AppColors.lightBackground,
                          child: FutureBuilder(
                              future:
                                  Future.delayed(Duration(milliseconds: 500)),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                return TabBarView(
                                  controller: _controller,
                                  children: [
                                    RecommendedCompetenciesFromFrac(
                                        _recommendedCompetenciesFromFrac),
                                    RecommendedCompetenciesFromWat(
                                        _recommendedCompetenciesFromWat),
                                    CompetenciesAddedByYou(
                                      checkAddCompetencyStatus:
                                          _checkAddCompetencyStatus,
                                      profileCompetencies: _profileCompetencies,
                                      updateAddedCompetencies:
                                          _updateAddedCompetencies,
                                    ),
                                    // CompetenciesAddedByYou(
                                    //   isDesired: true,
                                    //   checkAddCompetencyStatus:
                                    //       _checkAddCompetencyStatus,
                                    //   profileCompetencies: _desiredCompetencies,
                                    //   updateAddedCompetencies:
                                    //       _updateAddedCompetencies,
                                    // ),
                                  ],
                                );
                              }),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: _scrollToTop,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 32, bottom: 32),
                              child: Column(
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(50)),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_upward,
                                            color: AppColors.greys60,
                                            size: 24,
                                          ),
                                          onPressed: _scrollToTop),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 100, top: 12),
                                    child: Text(
                                      EnglishLang.backToTop,
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        letterSpacing: 0.12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return PageLoader(
                    bottom: 200,
                  );
                }
              }),
        ));
  }
}
