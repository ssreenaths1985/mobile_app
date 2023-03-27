import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/_models/learn_config_model.dart';
import 'package:karmayogi_mobile/respositories/_respositories/career_repository.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/screens/_screens/welcome_screen.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/career_detailed_view.dart';
import 'package:karmayogi_mobile/ui/widgets/_learn/content_info.dart';
import 'package:provider/provider.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import '../../../respositories/_respositories/profile_repository.dart';
import './../../../respositories/index.dart';
import './../../../util/faderoute.dart';
import './../../../ui/screens/index.dart';
import './../../../constants/index.dart';
import './../../widgets/index.dart';
import './../../pages/index.dart';
import './../../../services/index.dart';
import './../../../models/index.dart';
import './../../../localization/index.dart';
import './../../../util/telemetry.dart';
import './../../../util/telemetry_db_helper.dart';

class HomePage extends StatefulWidget {
  static const route = AppUrl.homePage;
  final int index;

  HomePage({Key key, this.index}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CareerOpeningService careerOpeningService = CareerOpeningService();
  final SuggestionService suggestionService = SuggestionService();
  final TelemetryService telemetryService = TelemetryService();
  ScrollController _controller = ScrollController();

  List _data = [];
  int pageNo = 1;
  int totalCount = 1;
  int connectionRequests = 0;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  int _start = 0;
  List allEventsData;
  bool dataSent;
  String deviceIdentifier;
  var telemetryEventData;
  List<Profile> _profileDetails;
  List<Suggestion> _suggestions;
  List<dynamic> _requestedConnections = [];
  LearnConfig _homeCoursesConfig;
  List<Course> _curatedCollections;
  int _selectedTopicsLength = 0;
  int _selectedRolesLength = 0;
  int _selectedDesiredTopicsLength = 0;
  bool _pageInitialized = false;

  @override
  void initState() {
    super.initState();
    allEventsData = [];
    dataSent = false;
    if (widget.index == 0) {
      _getCourses();
      _getConnectionRequest();
      _getAllSuggestions();
      _getRequestedConnections();
      if (_start == 0) {
        _generateTelemetryData();
      }
      _start++;
      // _startTimer();
    }
    // _showPopupIfNoAddedCompetencies();
    // _previousIndex = widget.index;
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
      TelemetryPageIdentifier.homePageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.homePageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  _getCourses() async {
    _homeCoursesConfig =
        await Provider.of<LearnRepository>(context, listen: false)
            .getHomeCoursesConfig();
  }

  void _generateInteractTelemetryData(String contentId,
      {String subType = ''}) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.homePageId,
        userSessionId,
        messageIdentifier,
        contentId,
        subType);
    // allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<List<Profile>> _getProfileDetails() async {
    // _getConnectivity();
    // print('In profile api call');
    if (!_pageInitialized) {
      _profileDetails =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById('');
      setState(() {
        _selectedRolesLength = _profileDetails[0].userRoles.length;
        _selectedTopicsLength = _profileDetails[0].selectedTopics.length;
        _selectedDesiredTopicsLength = _profileDetails[0].desiredTopics.length;
        _pageInitialized = true;
      });
    }
    // print('Profile data: ' + _profileDetails[0].rawDetails.toString());
    // await _populateFields();
    return _profileDetails;
  }

  /// Get connection request response
  Future<void> _getConnectionRequest() async {
    try {
      var response =
          await Provider.of<NetworkRespository>(context, listen: false)
              .getCrList();
      setState(() {
        connectionRequests = response.data.length;
      });
    } catch (err) {
      return err;
    }
  }

  Future<List<Suggestion>> _getAllSuggestions() async {
    try {
      final response = await suggestionService.getSuggestions();
      setState(() {
        _suggestions = response;
      });
      return _suggestions;
    } catch (err) {
      return err;
    }
  }

  /// Get trending discussions
  Future<dynamic> _trendingDiscussion() async {
    try {
      // print('_trendingDiscussion:' +
      //     pageNo.toString() +
      //     ', ' +
      //     totalCount.toString());
      _data.addAll(await Provider.of<DiscussRepository>(context, listen: false)
          .getRecentDiscussions(pageNo));
    } catch (err) {
      return err;
    }
    // print(_data.toString());
    return _data;
  }

  /// Navigate to discussion detail
  _navigateToDiscussionDetail(tid, userName, title, uid) {
    _generateInteractTelemetryData(tid.toString(),
        subType: TelemetrySubType.discussionCard);
    Navigator.push(
      context,
      FadeRoute(
          page: ChangeNotifierProvider<DiscussRepository>(
        create: (context) => DiscussRepository(),
        child: DiscussionPage(
            tid: tid, userName: userName, title: title, uid: uid),
      )),
    );
  }

  _loadMore() {
    // print('_loadMore');
    if (pageNo <= totalCount) {
      // print('_loadMore:' + pageNo.toString() + ', ' + totalCount.toString());
      setState(() {
        pageNo = pageNo + 1;
        if (_data[0].topicCount != null) {
          totalCount = (_data[0].topicCount / _data[0].nextStart).ceil();
        }
        // totalCount = 5;
        _trendingDiscussion();
      });
    }
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

  _navigateToCareerDetail(careerTitle, description, views, postedTime, tags) {
    // _generateInteractTelemetryData(tid.toString());

    Navigator.push(
        context,
        FadeRoute(
            page: ChangeNotifierProvider<CareerRepository>(
                create: (context) => CareerRepository(),
                child: CareerDetailedView(
                  title: careerTitle,
                  description: description,
                  viewCount: views,
                  postedTime: postedTime,
                  tags: tags,
                ))));
  }

  // Future<bool> _onBackPressed(contextMain) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => Stack(
  //             children: [
  //               Positioned(
  //                   child: Align(
  //                       alignment: Alignment.bottomCenter,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(12),
  //                             topRight: Radius.circular(12),
  //                           ),
  //                         ),
  //                         width: double.infinity,
  //                         child: Container(
  //                           margin: EdgeInsets.fromLTRB(0, 24, 0, 24),
  //                           height: (typesOfDiscussions.length * 52.0),
  //                           child: MediaQuery.removePadding(
  //                             removeTop: true,
  //                             removeBottom: true,
  //                             context: context,
  //                             child: ListView.builder(
  //                                 scrollDirection: Axis.vertical,
  //                                 itemCount: typesOfDiscussions.length,
  //                                 itemBuilder: (BuildContext context, index) =>
  //                                     _options(typesOfDiscussions[index])),
  //                           ),
  //                         ),
  //                       )))
  //             ],
  //           ));
  // }

  // Widget _options(String discussionTypes) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 16, right: 16),
  //     child: Container(
  //         decoration: BoxDecoration(
  //           color: discussionTypes == 'Trending'
  //               ? AppColors.lightSelected
  //               : Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(4)),
  //         ),
  //         height: 52,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 14, left: 16),
  //           child: Text(
  //             discussionTypes,
  //             style: GoogleFonts.lato(
  //                 color: AppColors.greys60,
  //                 fontWeight: FontWeight.w700,
  //                 fontSize: 16,
  //                 letterSpacing: 0.12,
  //                 height: 1.5),
  //           ),
  //         )),
  //   );
  // }

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Stat: $_previousIndex : ${widget.index}');
    return NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
          // _loadMore();
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMore();
          }
        },
        child: SingleChildScrollView(
            child: FutureBuilder(
                future: _trendingDiscussion(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  // print(MediaQuery.of(context).size.height.toString());
                  if (snapshot.hasData && snapshot.data != null) {
                    // List _data = snapshot.data.length > 0 ? snapshot.data : [];
                    return Container(
                      color: AppColors.scaffoldBackground,
                      padding: const EdgeInsets.only(bottom: 120, top: 16),
                      height: MediaQuery.of(context).size.height,
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        // Padding(padding: EdgeInsets.only(top: 0),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(), // new
                          controller: _controller,
                          shrinkWrap: false,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 8, bottom: 8),
                              // color: Colors.white,
                              height: 70,
                              // padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: HUBS
                                    .map(
                                      (hub) => InkWell(
                                        onTap: () => hub.comingSoon
                                            ? Navigator.push(
                                                context,
                                                FadeRoute(
                                                    page: ComingSoonScreen()),
                                              )
                                            : Navigator.pushNamed(
                                                context, hub.url),
                                        child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 8),
                                            width: 100.0,
                                            child: HomeHubItem(
                                                hub.id,
                                                hub.title,
                                                hub.icon,
                                                hub.iconColor,
                                                hub.url,
                                                (hub.id == 3 &&
                                                        connectionRequests > 0)
                                                    ? true
                                                    : false,
                                                hub.svgIcon)),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            FutureBuilder(
                                future: _getProfileDetails(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Profile>> snapshot) {
                                  return (snapshot.hasData &&
                                          (_selectedRolesLength == 0 &&
                                              (_selectedTopicsLength == 0 &&
                                                  _selectedDesiredTopicsLength ==
                                                      0)))
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              top: 16, left: 16, right: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'For a personalized learning experience',
                                                  style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  )),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              OutlinedButton(
                                                  onPressed: (() async {
                                                    // Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            WelcomeScreen(),
                                                      ),
                                                    );
                                                  }),
                                                  style: TextButton.styleFrom(
                                                      // primary: Colors.white,
                                                      // backgroundColor: AppColors.customBlue,
                                                      side: BorderSide(
                                                          color: AppColors
                                                              .customBlue)),
                                                  child: Text(
                                                      "Select your interests",
                                                      style: GoogleFonts.lato(
                                                        color: AppColors
                                                            .customBlue,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                      )))
                                            ],
                                          ),
                                        )
                                      : Center();
                                }),
                            // Container(height: 280, child: CarouselList()),
                            FutureBuilder(
                                future: Provider.of<LearnRepository>(context,
                                        listen: false)
                                    .getCourses(
                                        1,
                                        '',
                                        ['CuratedCollections'],
                                        [],
                                        [],
                                        hasRequestBody:
                                            _homeCoursesConfig != null
                                                ? true
                                                : false,
                                        requestBody: _homeCoursesConfig != null
                                            ? _homeCoursesConfig
                                                .curatedCollectionConfig
                                                .requestBody
                                            : null),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Course>> courses) {
                                  return courses.hasData && courses.data != null
                                      ? courses.data.length > 0
                                          ? Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 24, 16, 15),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        _homeCoursesConfig !=
                                                                null
                                                            ? _homeCoursesConfig
                                                                .curatedCollectionConfig
                                                                .title
                                                            : EnglishLang
                                                                .curatedCollections,
                                                        style: GoogleFonts.lato(
                                                          color:
                                                              AppColors.greys87,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16,
                                                          letterSpacing: 0.12,
                                                        ),
                                                      ),
                                                      ContentInfo(
                                                        infoMessage: _homeCoursesConfig !=
                                                                null
                                                            ? _homeCoursesConfig
                                                                .curatedCollectionConfig
                                                                .description
                                                            : EnglishLang
                                                                .curatedCollections,
                                                      ),
                                                      Spacer(),
                                                      InkWell(
                                                          onTap: () =>
                                                              Navigator.push(
                                                                context,
                                                                FadeRoute(
                                                                    page:
                                                                        BrowseByProvider(
                                                                      isCollections:
                                                                          true,
                                                                      isFromHome:
                                                                          true,
                                                                    ),
                                                                    routeName:
                                                                        AppUrl
                                                                            .browseByTopicPage),
                                                              ),
                                                          child: Text(
                                                            EnglishLang.seeAll,
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: AppColors
                                                                  .primaryThree,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  0.12,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                courses.data.length > 0
                                                    ? Container(
                                                        height: 348,
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                bottom: 0,
                                                                left: 4),
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: courses
                                                                      .data
                                                                      .length <
                                                                  10
                                                              ? courses
                                                                  .data.length
                                                              : 10,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return InkWell(
                                                                onTap: () {
                                                                  _generateInteractTelemetryData(
                                                                      courses
                                                                          .data[
                                                                              index]
                                                                          .id,
                                                                      subType:
                                                                          TelemetrySubType
                                                                              .courseCard);
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    FadeRoute(
                                                                        page:
                                                                            CoursesByProvider(
                                                                      courses
                                                                          .data[
                                                                              index]
                                                                          .name,
                                                                      isCollection:
                                                                          true,
                                                                      collectionId: courses
                                                                          .data[
                                                                              index]
                                                                          .id,
                                                                      collectionDescription: courses
                                                                          .data[
                                                                              index]
                                                                          .description,
                                                                      isFromHome:
                                                                          true,
                                                                    )),
                                                                  );
                                                                },
                                                                child: CourseItem(
                                                                    course: courses
                                                                            .data[
                                                                        index]));
                                                          },
                                                        ))
                                                    : Center(
                                                        child: PageLoader(),
                                                      ),
                                              ],
                                            )
                                          : Center()
                                      : Center();
                                }),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 24, 16, 15),
                              child: Row(
                                children: [
                                  Text(
                                    EnglishLang.trendingCBPs,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                  ContentInfo(
                                    infoMessage: _homeCoursesConfig != null
                                        ? _homeCoursesConfig
                                            .newlyAddedCourse.description
                                        : EnglishLang.trendingCBPs,
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () => Navigator.push(
                                            context,
                                            FadeRoute(
                                                page: TrendingCoursesPage()),
                                          ),
                                      child: Text(
                                        EnglishLang.seeAll,
                                        style: GoogleFonts.lato(
                                          color: AppColors.primaryThree,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: 0.12,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              height: 348,
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 20, left: 4),
                              child: FutureBuilder(
                                future: Provider.of<LearnRepository>(context,
                                        listen: false)
                                    .getCourses(1, '', ['course'], [], [],
                                        hasRequestBody:
                                            _homeCoursesConfig != null
                                                ? true
                                                : false,
                                        requestBody: _homeCoursesConfig != null
                                            ? _homeCoursesConfig
                                                .newlyAddedCourse.requestBody
                                            : null),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Course>> snapshot) {
                                  if (snapshot.hasData) {
                                    List<Course> courses = snapshot.data;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: courses.length < 10
                                          ? courses.length
                                          : 10,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              _generateInteractTelemetryData(
                                                  courses[index].id,
                                                  subType: TelemetrySubType
                                                      .courseCard);
                                              Navigator.push(
                                                context,
                                                FadeRoute(
                                                    page: CourseDetailsPage(
                                                  id: courses[index].id,
                                                )),
                                              );
                                            },
                                            child: CourseItem(
                                                course: courses[index]));
                                      },
                                    );
                                  } else {
                                    return Center(child: PageLoader());
                                    // return Center();
                                  }
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 16, bottom: 16),
                                child: InkWell(
                                  // onTap: () => _onBackPressed(context),
                                  // {
                                  //   setState(
                                  //     () {
                                  //       isDiscussionTypesOpen = true;
                                  //     },
                                  //   )
                                  // },
                                  child: Row(
                                    children: [
                                      Text(
                                        EnglishLang.trendingDiscussions,
                                        style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: 0.12,
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       top: 3, left: 2),
                                      //   child: Icon(
                                      //     Icons.arrow_drop_down,
                                      //     size: 26,
                                      //     color: AppColors.greys60,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                Positioned(
                                  // draw a red marble
                                  // top: -1,
                                  // right: -1,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    child: Column(
                                      children: <Widget>[
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 2,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: InkWell(
                                                  onTap: () =>
                                                      _navigateToDiscussionDetail(
                                                          _data[index].tid,
                                                          _data[index]
                                                              .user['fullname'],
                                                          _data[index].title,
                                                          _data[index]
                                                              .user['uid']),
                                                  child: (DiscussCardView(
                                                    data: _data[index],

                                                    // showVideo:
                                                    //     index == 2 ? true : false,
                                                  ))),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // ListView(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     shrinkWrap: true,
                            //     scrollDirection: Axis.vertical,
                            //     children: CARAOUSEL_DISCUSSION
                            //         .map((discussioncarouselcard) => InkWell(
                            //               child: Card(
                            //                 elevation: 0,
                            //                 color: Colors.white,
                            //                 margin:
                            //                     const EdgeInsets.only(top: 8),
                            //                 child: new Container(
                            //                     width: 100.0,
                            //                     child: DiscussCarouselCard(
                            //                       userName:
                            //                           discussioncarouselcard
                            //                               .userName,
                            //                       initials:
                            //                           discussioncarouselcard
                            //                               .initials,
                            //                       time: discussioncarouselcard
                            //                           .time,
                            //                       discussionName:
                            //                           discussioncarouselcard
                            //                               .discussionName,
                            //                       votes: discussioncarouselcard
                            //                           .votes,
                            //                       comments:
                            //                           discussioncarouselcard
                            //                               .comments,
                            //                       tags: discussioncarouselcard
                            //                           .tags,
                            //                       showCarousel:
                            //                           discussioncarouselcard
                            //                               .showCarousel,
                            //                       showVideo:
                            //                           discussioncarouselcard
                            //                               .showVideo,
                            //                       // showVideo: true,
                            //                     )),
                            //               ),
                            //             ))
                            //         .toList()),
                            _suggestions != null && _suggestions.length > 0
                                ? Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 24, 16, 15),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          EnglishLang.peopleYouMayKnow,
                                          style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            letterSpacing: 0.12,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 258,
                                          width: double.infinity,
                                          // margin: const EdgeInsets.only(bottom: 5),
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 10, left: 4),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _suggestions.length,
                                            itemBuilder: (context, index) {
                                              return PeopleItem(
                                                suggestion: _suggestions[index],
                                                parentAction1:
                                                    _createConnectionRequest,
                                                parentAction2:
                                                    _generateInteractTelemetryData,
                                                requestedConnections:
                                                    _requestedConnections,
                                              );
                                            },
                                          )),
                                    ],
                                  )
                                : Center(),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () =>
                                              _navigateToDiscussionDetail(
                                                  _data[index + 2].tid,
                                                  _data[index + 2]
                                                      .user['fullname'],
                                                  _data[index + 2].title,
                                                  _data[index + 2].user['uid']),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: (DiscussCardView(
                                                data: _data[index + 2])),
                                          ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: SectionHeading(
                                      EnglishLang.latestCareerOpenings),
                                ),
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 20),
                                  child: FutureBuilder(
                                    future: careerOpeningService
                                        .getCareerOpenings(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<CareerOpening>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        List<CareerOpening> careerOpenings =
                                            snapshot.data;
                                        return careerOpenings.length > 0
                                            ? ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    careerOpenings.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      _navigateToCareerDetail(
                                                          careerOpenings[index]
                                                              .title,
                                                          careerOpenings[index]
                                                              .description,
                                                          careerOpenings[index]
                                                              .viewCount,
                                                          careerOpenings[index]
                                                              .timeStamp,
                                                          careerOpenings[index]
                                                              .tags);
                                                    },
                                                    child: CareerOpeningItem(
                                                        careerOpenings[index]),
                                                  );
                                                },
                                              )
                                            : Container(
                                                alignment: Alignment.topLeft,
                                                child: InkWell(
                                                    child: Card(
                                                  color: Colors.white,
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                  child: new Container(
                                                    width: 300.0,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .grey08),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'No opening found',
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: AppColors
                                                                .greys87,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 14,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                              );
                                      } else {
                                        // return Center(child: CircularProgressIndicator());
                                        return Center();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Container(
                                padding: const EdgeInsets.only(bottom: 100),
                                // constraints: BoxConstraints(
                                //   minHeight: MediaQuery.of(context).size.height,
                                // ),
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _data.length - 5,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () =>
                                            _navigateToDiscussionDetail(
                                                _data[index + 5].tid,
                                                _data[index + 5]
                                                    .user['fullname'],
                                                _data[index + 5].title,
                                                _data[index + 5].user['uid']),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: (DiscussCardView(
                                              data: _data[index + 5])),
                                        ));
                                  },
                                ))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return PageLoader(
                      bottom: 150,
                    );
                  }
                })));
  }
}
