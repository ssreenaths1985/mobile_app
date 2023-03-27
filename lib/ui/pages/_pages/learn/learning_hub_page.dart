import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/_models/learn_config_model.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/learn/mandatory_courses_page.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/learn/see_all_courses.dart';
import 'package:karmayogi_mobile/ui/widgets/_learn/content_info.dart';
import 'package:provider/provider.dart';
// import 'package:karmayogi_mobile/ui/widgets/_home/program_item.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../respositories/_respositories/profile_repository.dart';
import './../../../../ui/pages/index.dart';
import './../../../../util/faderoute.dart';
import './../../../../constants/index.dart';
import './../../../widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../models/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class LearningHubPage extends StatefulWidget {
  final parentAction;
  const LearningHubPage({this.parentAction});
  @override
  _LearningHubPageState createState() => _LearningHubPageState();
}

class _LearningHubPageState extends State<LearningHubPage> {
  TelemetryService telemetryService = TelemetryService();
  final LearnService learnService = LearnService();
  // ScrollController _controller = ScrollController();
  List<Course> _continueLearningcourses;
  List<Course> _notCompletedContinueLearningcourses;
  List<Course> _mandatoryCourses;
  List<dynamic> _selectedTopics = [];
  List<CourseTopics> _courseTopics = [];
  List<BrowseCompetencyCardModel> _competencies = [];
  ScrollController _scrollController;
  List<Profile> _profileDetails;
  LearnConfig _learnConfig;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // Timer _timer;
  int _start = 0;
  List allEventsData = [];
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _getLearnHomeConfig();
    // _getMandatoryCourses();
    if (_start == 0) {
      _generateTelemetryData();
    }
  }

  _getLearnHomeConfig() async {
    _learnConfig = await Provider.of<LearnRepository>(context, listen: false)
        .getLearnToolTipInfo();
  }

  // Future<dynamic> _getMandatoryCourses() async {
  //   try {
  //     List _data = await Provider.of<LearnRepository>(context, listen: false)
  //         .getMandatoryCourses();
  //     return _data;
  //   } catch (err) {
  //     return err;
  //   }
  // }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData2 = Telemetry.getImpressionTelemetryEvent(
      deviceIdentifier,
      userId,
      departmentId,
      TelemetryPageIdentifier.learnPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.learnPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData2);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<List<Course>> _getInterestedCBPs() async {
    List<Course> interestedCourses;
    _profileDetails[0].selectedTopics.forEach((element) {
      _selectedTopics.add(element['identifier']);
    });
    _profileDetails[0].desiredTopics.forEach((element) {
      _selectedTopics.add(element);
    });
    if (_selectedTopics.length > 0) {
      interestedCourses =
          await Provider.of<LearnRepository>(context, listen: false)
              .getInterestedCourses(_selectedTopics);
    }
    return interestedCourses;
  }

  Future<List<Course>> _getRecommendedCourses() async {
    List<dynamic> profileCompetency = _profileDetails.first.competencies;
    List<dynamic> addedCompetenciesList = [];
    profileCompetency
        .map((competency) => addedCompetenciesList.add(competency['name']))
        .toList();

    return await Provider.of<LearnRepository>(context, listen: false)
        .getRecommendedCourses(addedCompetenciesList);
  }

  Future<dynamic> _getData() async {
    _continueLearningcourses =
        await Provider.of<LearnRepository>(context, listen: false)
            .getContinueLearningCourses();

    _notCompletedContinueLearningcourses = _continueLearningcourses
        .where((course) => course.raw['completionPercentage'] != 100)
        .toList();

    _mandatoryCourses = _continueLearningcourses
        .where((course) =>
            (course.contentType == EnglishLang.mandatoryCourseGoal &&
                course.raw['completionPercentage'] != 100))
        .toList();
    _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    // _mandatoryCourses =
    //     await Provider.of<LearnRepository>(context, listen: false)
    //         .getMandatoryCourses();
    // _courseTopics = await courseService.getCourseTopics();
    // print(_courseTopics.toString());
    return true;
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  Future<dynamic> _getCourseTopics() async {
    _courseTopics = await Provider.of<LearnRepository>(context, listen: false)
        .getCourseTopics();
    return true;
  }

  Future<dynamic> _getCourseCompetencies() async {
    _competencies = await Provider.of<LearnRepository>(context, listen: false)
        .getListOfCompetencies(context);
    return true;
  }

  // /// Navigate to discussion detail
  // _navigateToDetail(tid, userName, title) {
  //   Navigator.push(
  //     context,
  //     FadeRoute(
  //         page: ChangeNotifierProvider<DiscussRepository>(
  //       create: (context) => DiscussRepository(),
  //       child: DiscussionPage(tid: tid, userName: userName, title: title),
  //     )),
  //   );
  // }

  void _generateInteractTelemetryData(String contentId) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.learnPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.courseCard);
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(
      telemetryEventData.toMap(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: FutureBuilder(
            future: _getData(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              // print(MediaQuery.of(context).size.height.toString());
              if (snapshot.hasData && snapshot.data != null) {
                // List<Course> courses = snapshot.data;
                return Container(
                  padding: const EdgeInsets.only(bottom: 120),
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(), // new
                    controller: _scrollController,
                    shrinkWrap: false,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      // Container(
                      //   padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         EnglishLang.bites,
                      //         style: GoogleFonts.lato(
                      //           color: AppColors.greys87,
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 16,
                      //           letterSpacing: 0.12,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   height: 250,
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.only(top: 5, bottom: 15),
                      //   child: ListView(
                      //       scrollDirection: Axis.horizontal,
                      //       children: BITES_DATA
                      //           .map((bitescardmodel) => InkWell(
                      //                 child: ClipRRect(
                      //                   borderRadius: BorderRadius.circular(4),
                      //                   child: Container(
                      //                       margin:
                      //                           const EdgeInsets.only(left: 10),
                      //                       child: BitesCard(
                      //                         imageUrl: bitescardmodel.imageUrl,
                      //                         title: bitescardmodel.title,
                      //                         iconImage:
                      //                             bitescardmodel.iconImage,
                      //                       )),
                      //                 ),
                      //               ))
                      //           .toList()),
                      // ),
                      _notCompletedContinueLearningcourses.length > 0
                          ? Container(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 15, 12, 15),
                              child: Row(
                                children: [
                                  Text(
                                    EnglishLang.yourLearning,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                  ContentInfo(
                                    infoMessage: _learnConfig != null
                                        ? _learnConfig
                                            .continueLearning.description
                                        : EnglishLang.yourLearning,
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () => widget.parentAction(),
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
                            )
                          : Center(),
                      _notCompletedContinueLearningcourses.length > 0
                          ? Container(
                              height: 348,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _notCompletedContinueLearningcourses
                                            .length <
                                        10
                                    ? _notCompletedContinueLearningcourses
                                        .length
                                    : 10,
                                // itemCount: 1,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        _generateInteractTelemetryData(
                                            _notCompletedContinueLearningcourses[
                                                    index]
                                                .raw['courseId']);
                                        Navigator.push(
                                          context,
                                          FadeRoute(
                                              page: CourseDetailsPage(
                                            id: _notCompletedContinueLearningcourses[
                                                    index]
                                                .raw['courseId'],
                                            isContinueLearning: true,
                                          )),
                                        );
                                      },
                                      child: Container(
                                        // padding: const EdgeInsets.only(right: 16),
                                        child: Container(
                                          // width: MediaQuery.of(context).size.width -
                                          //     10,
                                          child: CourseItem(
                                            course:
                                                _notCompletedContinueLearningcourses[
                                                    index],
                                            progress:
                                                (_notCompletedContinueLearningcourses[
                                                                index]
                                                            .raw[
                                                        'completionPercentage'] /
                                                    100),
                                            displayProgress: true,
                                          ),
                                        ),
                                      ));
                                  // CourseItem(
                                  // course: _continueLearningcourses[index]);
                                },
                              ))
                          : Center(),
                      _mandatoryCourses.length > 0
                          ? Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 15, 12, 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        EnglishLang.mandatoryCourses,
                                        style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: 0.12,
                                        ),
                                      ),
                                      ContentInfo(
                                        infoMessage: _learnConfig
                                            .mandatoryCourse.description,
                                      ),
                                      Spacer(),
                                      InkWell(
                                          onTap: () => Navigator.push(
                                                context,
                                                FadeRoute(
                                                    page:
                                                        MandatoryCoursesPage()),
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
                                    height: 381,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 15),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _mandatoryCourses.length < 10
                                          ? _mandatoryCourses.length
                                          : 10,
                                      // itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              _generateInteractTelemetryData(
                                                  _mandatoryCourses[index]
                                                      .raw['courseId']);
                                              Navigator.push(
                                                context,
                                                FadeRoute(
                                                    page: CourseDetailsPage(
                                                  id: _mandatoryCourses[index]
                                                                  .raw[
                                                              'courseId'] !=
                                                          null
                                                      ? _mandatoryCourses[index]
                                                          .raw['courseId']
                                                      : _mandatoryCourses[index]
                                                          .id,
                                                  isContinueLearning: true,
                                                )),
                                              );
                                            },
                                            child: Container(
                                              // padding: const EdgeInsets.only(right: 16),
                                              child: Container(
                                                // width: MediaQuery.of(context).size.width -
                                                //     10,
                                                child: CourseItem(
                                                  course:
                                                      _mandatoryCourses[index],
                                                  progress: (_mandatoryCourses[
                                                                  index]
                                                              .raw[
                                                          'completionPercentage'] /
                                                      100),
                                                  displayProgress: true,
                                                  isMandatory: true,
                                                ),
                                              ),
                                            ));
                                        // CourseItem(
                                        // course: _continueLearningcourses[index]);
                                      },
                                    ))
                              ],
                            )
                          : Center(),
                      FutureBuilder(
                          future: _getInterestedCBPs(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Course>> courses) {
                            return (courses.hasData && courses.data != null)
                                ? Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 15, 12, 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              EnglishLang.basedOnYourInterests,
                                              style: GoogleFonts.lato(
                                                color: AppColors.greys87,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: 0.12,
                                              ),
                                            ),
                                            ContentInfo(
                                              infoMessage: _learnConfig
                                                  .basedOnInterest.description,
                                            ),
                                            Spacer(),
                                            courses.data.length > 0
                                                ? InkWell(
                                                    onTap: () => Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                              page:
                                                                  SeeAllCoursesPage(
                                                            courses.data,
                                                            isInterested: true,
                                                          )),
                                                        ),
                                                    child: Text(
                                                      EnglishLang.seeAll,
                                                      style: GoogleFonts.lato(
                                                        color: AppColors
                                                            .primaryThree,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                        letterSpacing: 0.12,
                                                      ),
                                                    ))
                                                : Center()
                                          ],
                                        ),
                                      ),
                                      courses.data.length > 0
                                          ? Container(
                                              height: 348,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 15),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    courses.data.length < 10
                                                        ? courses.data.length
                                                        : 10,
                                                // itemCount: 1,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        _generateInteractTelemetryData(
                                                            courses.data[index]
                                                                .id);
                                                        Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                              page:
                                                                  CourseDetailsPage(
                                                            id: courses
                                                                .data[index].id,
                                                            // isContinueLearning: true,
                                                          )),
                                                        );
                                                      },
                                                      child: Container(
                                                        // padding: const EdgeInsets.only(right: 16),
                                                        child: Container(
                                                          // width: MediaQuery.of(context).size.width -
                                                          //     10,
                                                          child: CourseItem(
                                                              course: courses
                                                                  .data[index]),
                                                        ),
                                                      ));
                                                  // CourseItem(
                                                  // course: _continueLearningcourses[index]);
                                                },
                                              ))
                                          : Center(child: PageLoader())
                                    ],
                                  )
                                : Center();
                          }),
                      FutureBuilder(
                          future: _getRecommendedCourses(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Course>> courses) {
                            return (courses.hasData && courses.data != null)
                                ? Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 15, 16, 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              EnglishLang.recommendedCBPs,
                                              style: GoogleFonts.lato(
                                                color: AppColors.greys87,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: 0.12,
                                              ),
                                            ),
                                            ContentInfo(
                                              infoMessage: _learnConfig
                                                  .recommendedCourse
                                                  .description,
                                            ),
                                            Spacer(),
                                            InkWell(
                                                onTap: () => Navigator.push(
                                                      context,
                                                      FadeRoute(
                                                          page:
                                                              SeeAllCoursesPage(
                                                        courses.data,
                                                        isRecommended: true,
                                                      )),
                                                    ),
                                                child: Text(
                                                  EnglishLang.seeAll,
                                                  style: GoogleFonts.lato(
                                                    color:
                                                        AppColors.primaryThree,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    letterSpacing: 0.12,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      courses.data.length > 0
                                          ? Container(
                                              height: 348,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 6, top: 5, bottom: 15),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    courses.data.length < 10
                                                        ? courses.data.length
                                                        : 10,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap:
                                                          () => Navigator.push(
                                                                context,
                                                                FadeRoute(
                                                                    page: CourseDetailsPage(
                                                                        id: courses
                                                                            .data[index]
                                                                            .id)),
                                                              ),
                                                      child: CourseItem(
                                                          course: courses
                                                              .data[index]));
                                                },
                                              ))
                                          : Center(child: PageLoader()),
                                    ],
                                  )
                                : Center();
                          }),
                      FutureBuilder(
                          future: Provider.of<LearnRepository>(context,
                                  listen: false)
                              .getCourses(1, '', ['program'], [], []),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Course>> programs) {
                            return (programs.hasData && programs.data != null)
                                ? Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 25, 16, 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              EnglishLang.programs,
                                              style: GoogleFonts.lato(
                                                color: AppColors.greys87,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: 0.12,
                                              ),
                                            ),
                                            ContentInfo(
                                              infoMessage: _learnConfig
                                                  .newlyAddedCourse.description,
                                            ),
                                            Spacer(),
                                            InkWell(
                                                onTap: () => {
                                                      Navigator.push(
                                                        context,
                                                        FadeRoute(
                                                            page:
                                                                TrendingCoursesPage(
                                                          selectedContentType:
                                                              'program',
                                                          isProgram: true,
                                                        )),
                                                      )
                                                    },
                                                child: Text(
                                                  EnglishLang.seeAll,
                                                  style: GoogleFonts.lato(
                                                    color:
                                                        AppColors.primaryThree,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    letterSpacing: 0.12,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      programs.data.length > 0
                                          ? Container(
                                              color: Colors.white,
                                              height: 348,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 6, top: 5, bottom: 25),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    programs.data.length < 10
                                                        ? programs.data.length
                                                        : 10,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () => {
                                                            Navigator.push(
                                                              context,
                                                              FadeRoute(
                                                                  page: CourseDetailsPage(
                                                                      id: programs
                                                                          .data[
                                                                              index]
                                                                          .id)),
                                                            )
                                                          },
                                                      child: CourseItem(
                                                          course: programs
                                                              .data[index],
                                                          isProgram: true));
                                                },
                                              ))
                                          : Center(child: PageLoader()),
                                    ],
                                  )
                                : Center();
                          }),
                      FutureBuilder(
                          future: Provider.of<LearnRepository>(context,
                                  listen: false)
                              .getCourses(1, '', ['course'], [], []),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Course>> courses) {
                            return (courses.hasData && courses.data != null)
                                ? Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 32, 16, 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              EnglishLang.recentlyAdded,
                                              style: GoogleFonts.lato(
                                                color: AppColors.greys87,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: 0.12,
                                              ),
                                            ),
                                            ContentInfo(
                                              infoMessage: _learnConfig
                                                  .newlyAddedCourse.description,
                                            ),
                                            Spacer(),
                                            InkWell(
                                                onTap: () => Navigator.push(
                                                      context,
                                                      FadeRoute(
                                                          page:
                                                              TrendingCoursesPage()),
                                                    ),
                                                child: Text(
                                                  EnglishLang.seeAll,
                                                  style: GoogleFonts.lato(
                                                    color:
                                                        AppColors.primaryThree,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    letterSpacing: 0.12,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      courses.data.length > 0
                                          ? Container(
                                              height: 348,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 6, top: 5, bottom: 15),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    courses.data.length < 10
                                                        ? courses.data.length
                                                        : 10,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        _generateInteractTelemetryData(
                                                            courses.data[index]
                                                                .id);
                                                        Navigator.push(
                                                            context,
                                                            FadeRoute(
                                                                page: CourseDetailsPage(
                                                                    id: courses
                                                                        .data[
                                                                            index]
                                                                        .id)));
                                                      },
                                                      child: CourseItem(
                                                          course: courses
                                                              .data[index]));
                                                },
                                              ))
                                          : Center(
                                              child: PageLoader(),
                                            ),
                                    ],
                                  )
                                : Center();
                          }),
                      FutureBuilder(
                          future: _getCourseTopics(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return (_courseTopics != null &&
                                    _courseTopics.length > 0)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, bottom: 12),
                                          child: Text(
                                            EnglishLang.popularTopics,
                                            style: GoogleFonts.lato(
                                              color: AppColors.greys87,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              letterSpacing: 0.12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _courseTopics.length > 1
                                          ? Container(
                                              height: 100,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: 2,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                              page: TopicCourses(
                                                                  _courseTopics[
                                                                          index]
                                                                      .identifier,
                                                                  _courseTopics[
                                                                          index]
                                                                      .name,
                                                                  _courseTopics[
                                                                          index]
                                                                      .raw)),
                                                        );
                                                      },
                                                      child:
                                                          CompetenciesAndTopicsCard(
                                                        cardColor: Colors.black,
                                                        courseTopics:
                                                            _courseTopics[
                                                                index],
                                                        isTopic: true,
                                                      ));
                                                },
                                              ),
                                            )
                                          : Center(),
                                      _courseTopics.length > 3
                                          ? Container(
                                              height: 100,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: 2,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        FadeRoute(
                                                            page: TopicCourses(
                                                                _courseTopics[
                                                                        index +
                                                                            2]
                                                                    .identifier,
                                                                _courseTopics[
                                                                        index +
                                                                            2]
                                                                    .name,
                                                                _courseTopics[
                                                                        index +
                                                                            2]
                                                                    .raw)),
                                                      );
                                                    },
                                                    child:
                                                        CompetenciesAndTopicsCard(
                                                      cardColor: Colors.black,
                                                      courseTopics:
                                                          _courseTopics[
                                                              index + 2],
                                                      isTopic: true,
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Center(),
                                      // Row(
                                      //   children: [
                                      //     _competenciesAndTopicsCard(
                                      //       name: 'Politics',
                                      //       count: 321,
                                      //       cardColor: Colors.black,
                                      //     ),
                                      //     _competenciesAndTopicsCard(
                                      //       name: 'Economics',
                                      //       count: 182,
                                      //       cardColor: Colors.black,
                                      //     ),
                                      //   ],
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              AppUrl.browseByTopicPage);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 8, 16, 16),
                                          child: OutlineButtonLearn(
                                            name: EnglishLang.exploreByTopic,
                                            url: AppUrl.browseByTopicPage,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center();
                          }),
                      FutureBuilder(
                          future: _getCourseCompetencies(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return (_competencies != null &&
                                    _competencies.length > 0)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, bottom: 16, top: 16),
                                          child: Text(
                                            EnglishLang.trendingCompetencies,
                                            style: GoogleFonts.lato(
                                              color: AppColors.greys87,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              letterSpacing: 0.12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _competencies.length > 1
                                          ? Container(
                                              height: 100,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: 2,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                              page: CoursesInCompetency(
                                                                  _competencies[
                                                                      index])),
                                                        );
                                                      },
                                                      child:
                                                          CompetenciesAndTopicsCard(
                                                        cardColor: Colors.black,
                                                        name:
                                                            _competencies[index]
                                                                .name,
                                                        count:
                                                            _competencies[index]
                                                                .count,
                                                        isTopic: false,
                                                      ));
                                                },
                                              ),
                                            )
                                          : Center(),
                                      _competencies.length > 3
                                          ? Container(
                                              height: 100,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: 2,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                              page: CoursesInCompetency(
                                                                  _competencies[
                                                                      index])),
                                                        );
                                                      },
                                                      child:
                                                          CompetenciesAndTopicsCard(
                                                        cardColor: Colors.black,
                                                        name:
                                                            _competencies[index]
                                                                .name,
                                                        count:
                                                            _competencies[index]
                                                                .count,
                                                        isTopic: false,
                                                      ));
                                                },
                                              ),
                                            )
                                          : Center(),
                                      // Container(
                                      //   height: 100,
                                      //   child: Row(
                                      //     children: [
                                      //       _competenciesAndTopicsCard(
                                      //         name: 'Communication',
                                      //         count: 580,
                                      //         cardColor: AppColors.blueCard,
                                      //       ),
                                      //       _competenciesAndTopicsCard(
                                      //         name: 'Vigilance and Planning',
                                      //         count: 342,
                                      //         cardColor: AppColors.blueCard,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // Container(
                                      //   height: 100,
                                      //   child: Row(
                                      //     children: [
                                      //       _competenciesAndTopicsCard(
                                      //         name: 'Time management',
                                      //         count: 321,
                                      //         cardColor: AppColors.blueCard,
                                      //       ),
                                      //       _competenciesAndTopicsCard(
                                      //         name: 'Design thinking',
                                      //         count: 182,
                                      //         cardColor: AppColors.blueCard,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              AppUrl.browseByCompetencyPage);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 8, 16, 0),
                                          child: OutlineButtonLearn(
                                            name: EnglishLang
                                                .browseByCompetencies,
                                            url: AppUrl.browseByCompetencyPage,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center();
                          }),
                      // InkWell(
                      //     onTap: () {
                      //       Navigator.pushNamed(
                      //           context, AppUrl.browseByCompetencyPage);
                      //     },
                      //     child: Padding(
                      //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      //       child: OutlineButtonLearn(
                      //         name: 'Browse by _competencies',
                      //       ),
                      //     )),
                      // Container(
                      //   padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         EnglishLang.lastViewedCBPs,
                      //         style: GoogleFonts.lato(
                      //           color: AppColors.greys87,
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 16,
                      //           letterSpacing: 0.12,
                      //         ),
                      //       ),
                      //       Spacer(),
                      //       InkWell(
                      //           onTap: () => Navigator.push(
                      //                 context,
                      //                 FadeRoute(page: TrendingCoursesPage()),
                      //               ),
                      //           child: Text(
                      //             EnglishLang.seeAll,
                      //             style: GoogleFonts.lato(
                      //               color: AppColors.primaryThree,
                      //               fontWeight: FontWeight.w700,
                      //               fontSize: 16,
                      //               letterSpacing: 0.12,
                      //             ),
                      //           ))
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 16),
                      //   child: Container(
                      //       height: 348,
                      //       width: double.infinity,
                      //       padding: const EdgeInsets.only(
                      //           left: 6, top: 5, bottom: 15),
                      //       child: ListView.builder(
                      //         scrollDirection: Axis.horizontal,
                      //         itemCount: _trendingCourses.length,
                      //         itemBuilder: (context, index) {
                      //           return InkWell(
                      //               onTap: () {
                      //                 _generateInteractTelemetryData(
                      //                     _trendingCourses[index].id);
                      //                 Navigator.push(
                      //                   context,
                      //                   FadeRoute(
                      //                       page: CourseDetailsPage(
                      //                           id: _trendingCourses[index]
                      //                               .id)),
                      //                 );
                      //               },
                      //               child: CourseItem(
                      //                   course: _trendingCourses[index]));
                      //         },
                      //       )),
                      // ),
                      InkWell(
                        onTap: _scrollToTop,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 32),
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
                                padding:
                                    const EdgeInsets.only(bottom: 100, top: 12),
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
                    ],
                  ),
                );
              } else {
                return PageLoader(
                  bottom: 150,
                );
              }
            }));
  }
}
