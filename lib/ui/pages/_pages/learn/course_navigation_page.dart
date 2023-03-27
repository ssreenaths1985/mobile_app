import 'dart:async';
// import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:karmayogi_mobile/feedback/pages/_pages/_cbpSurvey/content_feedback.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/oAuth2_login.dart';
import 'package:karmayogi_mobile/signup.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/learn/course_rating.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../util/faderoute.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../constants/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class CourseNavigationPage extends StatefulWidget {
  final course;
  final String identifier;
  final contentProgress;
  final navigation;
  final String moduleName;
  final String batchId;
  final ValueChanged<bool> parentAction;
  final bool isFeatured;
  final yourReviews;
  final updateReviewAction;
  final courseProgress;
  final updateCourseProgress;

  CourseNavigationPage(
      {this.course,
      this.identifier,
      this.contentProgress,
      this.navigation,
      this.moduleName = '',
      this.batchId,
      this.parentAction,
      this.isFeatured = false,
      this.yourReviews,
      this.updateReviewAction,
      this.courseProgress,
      this.updateCourseProgress});

  @override
  _CourseNavigationPageState createState() => _CourseNavigationPageState();
}

class _CourseNavigationPageState extends State<CourseNavigationPage> {
  final TelemetryService telemetryService = TelemetryService();
  final LearnService learnService = LearnService();
  int _courseIndex;
  List navigationItems = [];
  List _contentProgress;
  double progress = 0.0;
  int m = 0;
  // String _currentModuleName;
  bool _fullScreen = false;
  List widgetNavigation;
  var _yourReviews;

  ScrollController _scrollController;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String pageIdentifier;
  String deviceIdentifier;
  var telemetryEventData;

  void initState() {
    super.initState();
    // print('navigation batch id: ' + widget.batchId.toString());
    _scrollController = ScrollController();
    widgetNavigation = widget.navigation;
    _contentProgress = widget.contentProgress != null
        ? widget.contentProgress['result']['contentList']
        : [];
    // _currentModuleName = widget.moduleName;
    _generateNavigation();
    _generateTelemetryData();
    if (!widget.isFeatured) {
      _readContentProgress();
    }
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId(isPublic: widget.isFeatured);
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId(isPublic: widget.isFeatured);
  }

  void _generateInteractTelemetryData(String contentId, String mimeType) async {
    // String pageIdentifier = TelemetryPageIdentifier.courseDetailsPageUri
    //     .replaceAll(':do_ID', widget.course['identifier']);
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        (!widget.isFeatured
            ? TelemetryPageIdentifier.courseDetailsPageId
            : TelemetryPageIdentifier.publicCourseDetailsPageId),
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.contentCard);
    List allEventsData = [];
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
        isPublic: widget.isFeatured);
    // telemetryService.triggerEvent(allEventsData);
  }

  void manageScreen(bool fullScreen) {
    setState(() {
      _fullScreen = fullScreen;
    });
  }

  void _readContentProgress() async {
    // developer.log('_contentProgress: ' + _contentProgress.toString());
    for (int i = 0; i < navigationItems.length; i++) {
      for (int j = 0; j < _contentProgress.length; j++)
        if (navigationItems[i]['identifier'] ==
            _contentProgress[j]['contentId']) {
          // progress = _contentProgress[j]['completionPercentage'] / 100;
          navigationItems[i]['currentProgress'] = (_contentProgress[j]
                          ['progressdetails'] !=
                      null &&
                  (_contentProgress[j]['progressdetails']['current'] != null &&
                      _contentProgress[j]['progressdetails']['current'].length >
                          0))
              ? _contentProgress[j]['progressdetails']['current'].last
              : 0;
          navigationItems[i]['status'] = _contentProgress[j]['status'];
          navigationItems[i]['completionPercentage'] =
              _contentProgress[j]['completionPercentage'];
        }
    }
    // developer.log(jsonEncode(_contentProgress));
    // return navigationItems;
  }

  void _generateNavigation() {
    int index;
    int k = 0;
    if (widget.course['children'] != null) {
      for (index = 0; index < widget.course['children'].length; index++) {
        if ((widget.course['children'][index]['contentType'] == 'Collection' ||
            widget.course['children'][index]['contentType'] == 'CourseUnit')) {
          if (widget.course['children'][index]['children'] != null) {
            for (int i = 0;
                i < widget.course['children'][index]['children'].length;
                i++) {
              if (widget.course['children'][index]['children'][i]
                      ['identifier'] ==
                  widget.identifier) {
                _courseIndex = k;
              }
              navigationItems.add({
                'mimeType': widget.course['children'][index]['children'][i]
                    ['mimeType'],
                'identifier': widget.course['children'][index]['children'][i]
                    ['identifier'],
                'name': widget.course['children'][index]['children'][i]['name'],
                'artifactUrl': widget.course['children'][index]['children'][i]
                    ['artifactUrl'],
                'currentProgress': '0',
                'status': 0,
              });
              k++;
            }
          } else {
            if (widget.course['children'][index]['identifier'] ==
                widget.identifier) {
              _courseIndex = k;
            }
            navigationItems.add({
              'identifier': widget.course['children'][index]['identifier'],
              'name': widget.course['children'][index]['name'],
            });
            k++;
          }

          // navigationItems.add({
          //   // 'index': k++,
          //   'moduleName': widget.course['children'][index]['name'],
          //   'mimeType': 'Survey',
          //   'name': 'Survey',
          //   // 'artifactUrl': widget.course['children'][index]['children'][i]
          //   //     ['artifactUrl'],
          //   // 'contentId': widget.course['children'][index]['children'][i]
          //   //     ['identifier'],
          //   // 'currentProgress': '0',
          //   // 'completionPercentage': '0',
          //   'status': 0,
          // });
        }
        // Added below condition to handle course content items
        else if (widget.course['children'][index]['contentType'] == 'Course') {
          // List courseList = [];
          for (var i = 0;
              i < widget.course['children'][index]['children'].length;
              i++) {
            // List temp = [];
            if (widget.course['children'][index]['children'][i]
                        ['contentType'] ==
                    'Collection' ||
                widget.course['children'][index]['children'][i]
                        ['contentType'] ==
                    'CourseUnit') {
              for (var j = 0;
                  j <
                      widget
                          .course['children'][index]['children'][i]['children']
                          .length;
                  j++) {
                if (widget.course['children'][index]['children'][i]['children']
                        [j]['identifier'] ==
                    widget.identifier) {
                  _courseIndex = k;
                }
                navigationItems.add({
                  'index': k++,
                  // 'courseName': widget.course['children'][index]['name'],
                  // 'moduleName': widget.course['children'][index]['children'][i]
                  //     ['name'],
                  'mimeType': widget.course['children'][index]['children'][i]
                      ['children'][j]['mimeType'],
                  'identifier': widget.course['children'][index]['children'][i]
                      ['children'][j]['identifier'],
                  'name': widget.course['children'][index]['children'][i]
                      ['children'][j]['name'],
                  'artifactUrl': widget.course['children'][index]['children'][i]
                      ['children'][j]['artifactUrl'],
                  // 'contentId': widget.course['children'][index]['children'][i]
                  //     ['children'][j]['identifier'],
                  'currentProgress': '0',
                  // 'completionPercentage': '0',
                  'status': 0,
                });
                // k++;
              }
              // courseList.add(temp);
            } else {
              if (widget.course['children'][index]['children'][i]
                      ['identifier'] ==
                  widget.identifier) {
                _courseIndex = k;
              }
              navigationItems.add({
                'index': k++,
                // 'courseName': widget.course['children'][index]['name'],
                'mimeType': widget.course['children'][index]['children'][i]
                    ['mimeType'],
                'identifier': widget.course['children'][index]['children'][i]
                    ['identifier'],
                'name': widget.course['children'][index]['children'][i]['name'],
                'artifactUrl': widget.course['children'][index]['children'][i]
                    ['artifactUrl'],
                // 'contentId': widget.course['children'][index]['children'][i]
                //     ['identifier'],
                'currentProgress': '0',
                // 'completionPercentage': '0',
                'status': 0,
              });
              // k++;
            }
          }
          // navigationItems.add(courseList);
        } else {
          if (widget.course['children'][index]['identifier'] ==
              widget.identifier) {
            _courseIndex = k;
          }
          navigationItems.add({
            'mimeType': widget.course['children'][index]['mimeType'],
            'identifier': widget.course['children'][index]['identifier'],
            'name': widget.course['children'][index]['name'],
            'artifactUrl': widget.course['children'][index]['artifactUrl'],
            'currentProgress': '0',
            'status': 0,
          });
          k++;
        }
      }
    }
    // print('CI: $_courseIndex');
    // Code for testing youtube videos
    // navigationItems.add({
    //   'mimeType': EMimeTypes.externalLink,
    //   'identifier': 'https://www.youtube.com/embed/_NKvJ43XBkY',
    //   'name': 'Youtube test',
    //   'artifactUrl': 'https://www.youtube.com/embed/_NKvJ43XBkY'
    // });
    // developer.log(jsonEncode(navigationItems));
  }

  double _getModuleProgress(glanceListItems) {
    double _moduleProgressSum = 0.0;
    for (int i = 0; i < glanceListItems.length; i++) {
      if (glanceListItems[i]['status'] == 2) {
        _moduleProgressSum = _moduleProgressSum + 1;
      } else if (glanceListItems[i]['completionPercentage'] != '0' &&
          glanceListItems[i]['completionPercentage'] != null)
        _moduleProgressSum =
            _moduleProgressSum + glanceListItems[i]['completionPercentage'];
    }
    return _moduleProgressSum / glanceListItems.length;
  }

  double _getCourseProgress(glanceListItems) {
    double _courseProgressSum = 0.0;
    for (var i = 0; i < glanceListItems.length; i++) {
      for (int j = 0; j < glanceListItems[i].length; j++) {
        if (glanceListItems[i][j] != null) {
          if (glanceListItems[i][j]['status'] == 2) {
            _courseProgressSum = _courseProgressSum + 1;
          } else if (glanceListItems[i][j]['completionPercentage'] != '0' &&
              glanceListItems[i][j]['completionPercentage'] != null)
            _courseProgressSum = _courseProgressSum +
                glanceListItems[i][j]['completionPercentage'];
        } else if (glanceListItems[i] != null) {
          if (glanceListItems[i]['status'] == 2) {
            _courseProgressSum = _courseProgressSum + 1;
          } else if (glanceListItems[i]['completionPercentage'] != '0' &&
              glanceListItems[i]['completionPercentage'] != null)
            _courseProgressSum =
                _courseProgressSum + glanceListItems[i]['completionPercentage'];
        }
      }
    }
    return _courseProgressSum / glanceListItems.length;
    // return 0.5;
  }

  void updateContentProgress(Map data) {
    // print("I'm in navigation page $data");
    if (!widget.isFeatured) {
      for (int i = 0; i < navigationItems.length; i++) {
        if (navigationItems[i]['identifier'] == data['identifier']) {
          Timer.run(() {
            if (mounted) {
              setState(() {
                navigationItems[i]['completionPercentage'] =
                    (data['completionPercentage']).toString();
                navigationItems[i]['currentProgress'] =
                    data['mimeType'] == EMimeTypes.assessment
                        ? (data['completionPercentage']).toString()
                        : data['current'];
              });
            }
          });
          if (data['completionPercentage'] >= 99.0) {
            Timer.run(() {
              if (mounted) {
                setState(() {
                  navigationItems[i]['status'] = 2;
                });
              }
            });
          }
          // print('Updated item:' + navigationItems[i].toString());
        }
      }
      for (int i = 0; i < navigationItems.length; i++) {
        for (int j = 0; j < _contentProgress.length; j++)
          if (navigationItems[i]['identifier'] ==
              _contentProgress[j]['contentId']) {
            if (_contentProgress[j]['progressdetails'] != null) {
              _contentProgress[j]['progressdetails']['current'] =
                  navigationItems[i]['currentProgress'];
            }
            _contentProgress[j]['status'] = navigationItems[i]['status'];
            _contentProgress[j]['completionPercentage'] =
                navigationItems[i]['completionPercentage'];
          }
      }
      if (data['completionPercentage'] >= 99.0) {
        for (int i = 0; i < widgetNavigation.length; i++) {
          if (widgetNavigation[i][0] == null) {
            if (widgetNavigation[i]['identifier'] == data['identifier']) {
              Timer.run(() {
                if (mounted) {
                  setState(() {
                    widgetNavigation[i]['status'] = 2;
                  });
                }
              });
            }
          } else if (widgetNavigation[i][0][0] != null) {
            for (var k = 0; k < widgetNavigation[i].length; k++) {
              for (int j = 0; j < widgetNavigation[i][k].length; j++) {
                if (widgetNavigation[i][k][j] != null) {
                  if (widgetNavigation[i][k][j]['identifier'] ==
                      data['identifier']) {
                    Timer.run(() {
                      if (mounted) {
                        setState(() {
                          widgetNavigation[i][k][j]['status'] = 2;
                        });
                      }
                    });
                  }
                } else if (widgetNavigation[i][k][0] == null) {
                  if (widgetNavigation[i][k]['identifier'] ==
                      data['identifier']) {
                    Timer.run(() {
                      if (mounted) {
                        setState(() {
                          widgetNavigation[i][k]['status'] = 2;
                        });
                      }
                    });
                  }
                }
              }
            }
          } else {
            for (int j = 0; j < widgetNavigation[i].length; j++) {
              if (widgetNavigation[i][j]['identifier'] == data['identifier']) {
                Timer.run(() {
                  if (mounted) {
                    setState(() {
                      widgetNavigation[i][j]['status'] = 2;
                    });
                  }
                });
              }
            }
          }
        }
      }
      Timer.run(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  _getYourRatingAndReview() async {
    final response = await learnService.getYourReview(
        widget.course['identifier'], widget.course['primaryCategory']);
    setState(() {
      _yourReviews = response;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  Future<dynamic> _showFinishPopup() async {
    await _getYourRatingAndReview();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Congratulations for completing the \"${widget.course['name']}\"",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: AppColors.greys87,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'You have completed the course successfully. Please check back in some time to view your certificate of completion.',
                      style: GoogleFonts.lato(
                        color: AppColors.greys87,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                            text: 'Please take a moment to ',
                          ),
                          TextSpan(
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            text: 'rate this course',
                            recognizer: TapGestureRecognizer()
                              ..onTap = (() {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ContactUs()),
                                // );
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                      page: CourseRating(
                                    widget.course['name'],
                                    widget.course['identifier'],
                                    widget.course['primaryCategory'],
                                    _yourReviews,
                                    isFromContentPlayer: true,
                                  )),
                                );
                              }),
                          ),
                          TextSpan(
                            style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                            text: ' and tell us about your experience.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 4),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                      onPressed: (() async {
                        Navigator.of(context).pop();
                      }),
                      style: TextButton.styleFrom(
                          // primary: Colors.white,
                          // backgroundColor: AppColors.customBlue,
                          side: BorderSide(color: AppColors.customBlue)),
                      child: Text(EnglishLang.close,
                          style: GoogleFonts.lato(
                            color: AppColors.customBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ))),
                )
              ],
            ));
    return true;
    // if (_courseIndex ==
    //     widgetNavigation[widgetNavigation.length - 1]['index']) {
    //   developer.log('I am last');
    //   if (navigationItems[(navigationItems.length - 1)]
    //               ['completionPercentage'] !=
    //           null &&
    //       double.parse(navigationItems[(navigationItems.length - 1)]
    //               ['completionPercentage']) >=
    //           99) {
    //     showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //               title: Text("Congratulations for completing the"),
    //               content: Text(
    //                   'You have completed the course successfully. Please check back in some time to view your certificate of completion.'),
    //               actions: [
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: TextButton(
    //                       onPressed: (() => Navigator.of(context).pop()),
    //                       child: Text('Close')),
    //                 )
    //               ],
    //             ));
    //   }
    // }
  }

  _showLatestProgress(bool status) async {
    if (!widget.isFeatured) {
      _readContentProgress();
      setState(() {});
    }
  }

  Widget signInOrRegister() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        alignment: Alignment.bottomCenter,
        // height: MediaQuery.of(context).size.height *
        //     (MediaQuery.of(context).orientation == Orientation.portrait
        //         ? 0.12
        //         : 0.175),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'If you are a government official, register or sign in so you can track your learning progress and get certified.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primaryThree,
                      minimumSize: const Size.fromHeight(40), // NEW
                      side: BorderSide(width: 1, color: AppColors.primaryThree),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      EnglishLang.register,
                      style: GoogleFonts.lato(
                          height: 1.429,
                          letterSpacing: 0.5,
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'or',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryThree),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: AppColors.primaryThree,
                      primary: Colors.white,
                      minimumSize: const Size.fromHeight(40), // NEW
                      side: BorderSide(width: 1, color: AppColors.primaryThree),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => OAuth2Login(),
                        ),
                      );
                    },
                    child: Text(
                      EnglishLang.signIn,
                      style: GoogleFonts.lato(
                          height: 1.429,
                          letterSpacing: 0.5,
                          fontSize: 14,
                          color: AppColors.primaryThree,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getContentObject(content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
      ),
      margin: EdgeInsets.only(left: 0, right: 0),
      // padding: EdgeInsets.only(top: 5, bottom: 10),
      child: InkWell(
        onTap: () {
          _generateInteractTelemetryData(
              content['identifier'], content['mimeType']);
          if (content['mimeType'] == EMimeTypes.assessment &&
              !widget.isFeatured) {
            Navigator.push(
                context,
                FadeRoute(
                    page: CourseAssessmentPlayer(
                        widget.course,
                        content['name'],
                        content['identifier'],
                        content['artifactUrl'],
                        updateContentProgress,
                        widget.batchId,
                        content['duration'])));
            setState(() {
              _courseIndex = content['index'];
            });
          } else if (content['mimeType'] == EMimeTypes.survey &&
              !widget.isFeatured) {
            if (content['status'] != 2) {
              Navigator.push(
                  context,
                  FadeRoute(
                      page: ContentFeedback(
                          content['artifactUrl'],
                          content['name'],
                          widget.course,
                          content['identifier'],
                          widget.batchId)));
            }
            setState(() {
              _courseIndex = content['index'];
            });
          } else {
            setState(() {
              _courseIndex = content['index'];
            });
          }
          _scrollToTop();
        },
        child: content['mimeType'] != null
            ? Column(
                children: [
                  GlanceItem4(
                    icon: (content['mimeType'] == EMimeTypes.mp4 ||
                            content['mimeType'] == EMimeTypes.m3u8 ||
                            content['mimeType'] == EMimeTypes.mp3)
                        ? 'assets/img/icons-av-play.svg'
                        : (content['mimeType'] == EMimeTypes.externalLink ||
                                content['mimeType'] == EMimeTypes.youtubeLink)
                            ? 'assets/img/link.svg'
                            : content['mimeType'] == EMimeTypes.pdf
                                ? 'assets/img/icons-file-types-pdf-alternate.svg'
                                : (content['mimeType'] ==
                                            EMimeTypes.assessment ||
                                        content['mimeType'] ==
                                            EMimeTypes.newAssessment)
                                    ? 'assets/img/assessment_icon.svg'
                                    : 'assets/img/resource.svg',
                    text: content['name'],
                    status: content['status'],
                    duration: content['duration'],
                    background: _courseIndex == content['index'] ? true : false,
                    isFeaturedCourse: widget.isFeatured,
                    currentProgress: content['completionPercentage'],
                  ),
                ],
              )
            : Center(),
      ),
    );
  }

  _openInNewScreen(Widget player, {bool isYoutubeContent = false}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Press the Play button to start'),
        SizedBox(
          height: 16,
        ),
        IconButton(
            iconSize: 52,
            color: AppColors.greys60,
            onPressed: () {
              isYoutubeContent
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => player),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                backgroundColor: Colors.black,
                                body: SafeArea(
                                  child: NestedScrollView(
                                    headerSliverBuilder: (BuildContext context,
                                        bool innerBoxIsScrolled) {
                                      return <Widget>[
                                        SliverAppBar(
                                          backgroundColor: Colors.black,
                                          pinned: false,
                                          automaticallyImplyLeading: false,
                                          // expandedHeight: 112,
                                          flexibleSpace: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      color: AppColors.white70,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                                Text(
                                                  EnglishLang.back,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.white70,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ];
                                    },
                                    body: Center(child: player
                                        // CourseHtmlPlayer(
                                        //   widget.course,
                                        //   navigationItems[_courseIndex]['identifier'],
                                        //   navigationItems[_courseIndex]['artifactUrl'],
                                        //   widget.batchId,
                                        //   manageScreen,
                                        //   updateContentProgress,
                                        //   parentAction3: _showLatestProgress,
                                        //   isFeaturedCourse: widget.isFeatured,
                                        // ),
                                        ),
                                  ),
                                ),
                              )),
                    );
            },
            icon: Icon(Icons.play_circle_fill_outlined)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            navigationItems[_courseIndex]['name'],
            textAlign: TextAlign.center,
          ),
        )
      ],
    ));
  }

  @override
  void dispose() {
    if (widget.parentAction != null && !widget.isFeatured) {
      widget.parentAction(true);
      widget.updateCourseProgress();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // log(widgetNavigation.last.last['index'].toString());
    return Scaffold(
      body: SafeArea(
          child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      backgroundColor: Colors.white,
                      pinned: false,
                      automaticallyImplyLeading: false,
                      // expandedHeight: 112,
                      flexibleSpace: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: AppColors.greys87,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
                                child: Text(
                                  navigationItems[_courseIndex]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    color: AppColors.greys87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ];
              },
              body: SingleChildScrollView(
                  child: Column(children: [
                Container(
                  height: _fullScreen
                      ? MediaQuery.of(context).size.height - 100
                      : 250,
                  // height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 5.0),
                  child: (navigationItems[_courseIndex]['mimeType'] ==
                              EMimeTypes.mp4 ||
                          navigationItems[_courseIndex]['mimeType'] ==
                              EMimeTypes.m3u8)
                      ? CourseVideoPlayer(
                          course: widget.course,
                          identifier: navigationItems[_courseIndex]
                              ['identifier'],
                          fileUrl: navigationItems[_courseIndex]['artifactUrl'],
                          mimeType: navigationItems[_courseIndex]['mimeType'],
                          updateProgress: true,
                          currentProgress: navigationItems[_courseIndex]
                              ['currentProgress'],
                          status: navigationItems[_courseIndex]['status'],
                          batchId: widget.batchId,
                          parentAction: updateContentProgress,
                          isFeatured: widget.isFeatured,
                        )
                      : navigationItems[_courseIndex]['mimeType'] ==
                              EMimeTypes.mp3
                          ? CourseAudioPlayer(
                              identifier: navigationItems[_courseIndex]
                                  ['identifier'],
                              fileUrl: navigationItems[_courseIndex]
                                  ['artifactUrl'],
                              updateProgress: true,
                              batchId: widget.batchId,
                              course: widget.course,
                              status: navigationItems[_courseIndex]['status'],
                              parentAction: updateContentProgress,
                              isFeaturedCourse: widget.isFeatured,
                            )
                          : navigationItems[_courseIndex]['mimeType'] ==
                                  EMimeTypes.pdf
                              ? CoursePdfPlayer(
                                  course: widget.course,
                                  identifier: navigationItems[_courseIndex]
                                      ['identifier'],
                                  fileUrl: navigationItems[_courseIndex]
                                      ['artifactUrl'],
                                  currentProgress: navigationItems[_courseIndex]
                                      ['currentProgress'],
                                  status: navigationItems[_courseIndex]
                                      ['status'],
                                  batchId: widget.batchId,
                                  parentAction1: manageScreen,
                                  parentAction2: updateContentProgress,
                                  isFeaturedCourse: widget.isFeatured,
                                )
                              : navigationItems[_courseIndex]['mimeType'] ==
                                      EMimeTypes.html
                                  ? _openInNewScreen(
                                      CourseHtmlPlayer(
                                        widget.course,
                                        navigationItems[_courseIndex]
                                            ['identifier'],
                                        navigationItems[_courseIndex]
                                            ['artifactUrl'],
                                        widget.batchId,
                                        manageScreen,
                                        updateContentProgress,
                                        parentAction3: _showLatestProgress,
                                        isFeaturedCourse: widget.isFeatured,
                                      ),
                                    )
                                  : navigationItems[_courseIndex]['mimeType'] ==
                                              EMimeTypes.externalLink ||
                                          navigationItems[_courseIndex]
                                                  ['mimeType'] ==
                                              EMimeTypes.youtubeLink
                                      ? _openInNewScreen(
                                          CourseYoutubePlayer(
                                            widget.course,
                                            navigationItems[_courseIndex]
                                                ['identifier'],
                                            navigationItems[_courseIndex]
                                                ['artifactUrl'],
                                            navigationItems[_courseIndex]
                                                ['currentProgress'],
                                            navigationItems[_courseIndex]
                                                ['status'],
                                            widget.batchId,
                                            navigationItems[_courseIndex]
                                                ['mimeType'],
                                            isFeaturedCourse: widget.isFeatured,
                                          ),
                                          isYoutubeContent: true)
                                      : navigationItems[_courseIndex]
                                                  ['mimeType'] ==
                                              EMimeTypes.survey
                                          ? (!widget.isFeatured
                                              ? Center(
                                                  child: Text(
                                                  navigationItems[_courseIndex]
                                                              ['status'] ==
                                                          2
                                                      ? 'Survey is already submitted'
                                                      : 'Tap on survey to start',
                                                  style: GoogleFonts.lato(
                                                      height: 1.5,
                                                      color: AppColors.greys87,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ))
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                32, 16, 32, 8),
                                                        child: Text(
                                                          EnglishLang
                                                              .doSignInOrRegisterMessage,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.5,
                                                                  fontSize: 16),
                                                        ),
                                                      ),
                                                      // signInOrRegister(),
                                                    ],
                                                  ),
                                                ))
                                          : (!widget.isFeatured
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(32),
                                                  child: Center(
                                                      child: Text(
                                                    navigationItems[_courseIndex]
                                                                ['mimeType'] ==
                                                            EMimeTypes
                                                                .newAssessment
                                                        ? EnglishLang
                                                            .newAssessmentHoldInfo
                                                        : 'Tap on assessment to start',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                        height: 1.5,
                                                        color:
                                                            AppColors.greys87,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                32, 16, 32, 8),
                                                        child: Text(
                                                          EnglishLang
                                                              .newAssessmentHoldInfo,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 16),
                                                        ),
                                                      ),
                                                      // signInOrRegister(),
                                                    ],
                                                  ),
                                                )),
                ),
                !_fullScreen
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < widgetNavigation.length; i++)
                            if (widgetNavigation[i][0] == null)
                              _getContentObject(widgetNavigation[i])
                            //Added below condition to handle course item
                            else if (widgetNavigation[i][0][0] != null)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                ),
                                margin: EdgeInsets.only(top: 8),
                                child: (ExpansionTile(
                                  initiallyExpanded: true,
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2, left: 8),
                                        child: SvgPicture.asset(
                                          'assets/img/course_icon.svg',
                                          color: AppColors.greys87,
                                          // alignment: Alignment.topLeft,
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widgetNavigation[i][0][0]
                                                  ['courseName'],
                                              style: GoogleFonts.lato(
                                                  height: 1.5,
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: AppColors.greys87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            (widgetNavigation[i][0][0][
                                                            'courseDuration'] !=
                                                        null &&
                                                    widgetNavigation[i][0][0][
                                                            'courseDuration'] !=
                                                        '')
                                                ? Text(
                                                    widgetNavigation[i][0][0]
                                                        ['courseDuration'],
                                                    style: GoogleFonts.lato(
                                                        height: 1.5,
                                                        decoration:
                                                            TextDecoration.none,
                                                        color:
                                                            AppColors.greys87,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                : Center(),
                                          ],
                                        ),
                                      )),
                                      !widget.isFeatured
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12, right: 0, left: 4),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        backgroundColor:
                                                            AppColors.grey16,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          AppColors
                                                              .positiveLight,
                                                        ),
                                                        strokeWidth: 3,
                                                        value: _getCourseProgress(
                                                            widgetNavigation[
                                                                i])),
                                              ),
                                            )
                                          : Center()
                                    ],
                                  ),
                                  children: [
                                    for (var k = 0;
                                        k < widgetNavigation[i].length;
                                        k++)
                                      (widgetNavigation[i][k][0] != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    const Radius.circular(4.0)),
                                              ),
                                              margin: EdgeInsets.only(top: 8),
                                              // padding: EdgeInsets.only(top: 5, bottom: 10),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    const Radius
                                                                            .circular(
                                                                        4.0)),
                                                            color:
                                                                Colors.white),
                                                        child: ExpansionTile(
                                                            onExpansionChanged:
                                                                (value) {},
                                                            // initiallyExpanded:
                                                            //     _currentModuleName ==
                                                            //             widgetNavigation[i]
                                                            //                 [0]['moduleName']
                                                            //         ? true
                                                            //         : false,
                                                            initiallyExpanded:
                                                                true,
                                                            trailing: Text(' '),
                                                            backgroundColor:
                                                                Colors.white,
                                                            title: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 15),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/img/icons-file-types-module.svg',
                                                                    // color: AppColors.greys87,
                                                                    // alignment: Alignment.topLeft,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8),
                                                                  child: Text(
                                                                    widgetNavigation[i]
                                                                            [
                                                                            k][0]
                                                                        [
                                                                        'moduleName'],
                                                                    style: GoogleFonts.lato(
                                                                        height:
                                                                            1.5,
                                                                        decoration:
                                                                            TextDecoration
                                                                                .none,
                                                                        color: AppColors
                                                                            .greys87,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                )),
                                                                !widget
                                                                        .isFeatured
                                                                    ? Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                8,
                                                                            right:
                                                                                0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          child: CircularProgressIndicator(
                                                                              backgroundColor: AppColors.grey16,
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                AppColors.positiveLight,
                                                                              ),
                                                                              strokeWidth: 3,
                                                                              value: _getModuleProgress(widgetNavigation[i][k])),
                                                                        ))
                                                                    : Center()
                                                              ],
                                                            ),
                                                            children: [
                                                              for (int j = 0;
                                                                  j <
                                                                      widgetNavigation[i]
                                                                              [
                                                                              k]
                                                                          .length;
                                                                  j++)
                                                                InkWell(
                                                                    onTap: () {
                                                                      _generateInteractTelemetryData(
                                                                          widgetNavigation[i][k][j]
                                                                              [
                                                                              'identifier'],
                                                                          widgetNavigation[i][k][j]
                                                                              [
                                                                              'mimeType']);
                                                                      if (widgetNavigation[i][k][j]['mimeType'] ==
                                                                              EMimeTypes.assessment &&
                                                                          !widget.isFeatured) {
                                                                        Navigator.push(
                                                                            context,
                                                                            FadeRoute(page: CourseAssessmentPlayer(widget.course, widgetNavigation[i][k][j]['name'], widgetNavigation[i][k][j]['identifier'], widgetNavigation[i][k][j]['artifactUrl'], updateContentProgress, widget.batchId, widgetNavigation[i][k][j]['duration'])));
                                                                        setState(
                                                                            () {
                                                                          _courseIndex =
                                                                              widgetNavigation[i][k][j]['index'];
                                                                        });
                                                                      } else if (widgetNavigation[i][k][j]['mimeType'] ==
                                                                              EMimeTypes.survey &&
                                                                          !widget.isFeatured) {
                                                                        if (widgetNavigation[i][k][j]['status'] !=
                                                                            2) {
                                                                          Navigator.push(
                                                                              context,
                                                                              FadeRoute(page: ContentFeedback(widgetNavigation[i][k][j]['artifactUrl'], widgetNavigation[i][k][j]['name'], widget.course, widgetNavigation[i][k][j]['identifier'], widget.batchId)));
                                                                        }
                                                                        setState(
                                                                            () {
                                                                          _courseIndex =
                                                                              widgetNavigation[i][k][j]['index'];
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _courseIndex =
                                                                              widgetNavigation[i][k][j]['index'];
                                                                          // _currentModuleName =
                                                                          //     widgetNavigation[
                                                                          //             i][j][
                                                                          //         'moduleName'];
                                                                        });
                                                                      }
                                                                      _scrollToTop();
                                                                      // print('m: $m');
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      // color: Colors.red,
                                                                      child:
                                                                          GlanceItem4(
                                                                        icon: (widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.mp4 ||
                                                                                widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.m3u8 ||
                                                                                widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.mp3)
                                                                            ? 'assets/img/icons-av-play.svg'
                                                                            : (widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.externalLink || widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.youtubeLink)
                                                                                ? 'assets/img/link.svg'
                                                                                : widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.pdf
                                                                                    ? 'assets/img/icons-file-types-pdf-alternate.svg'
                                                                                    : (widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.assessment || widgetNavigation[i][k][j]['mimeType'] == EMimeTypes.newAssessment)
                                                                                        ? 'assets/img/assessment_icon.svg'
                                                                                        : 'assets/img/resource.svg',
                                                                        text: widget.navigation[i][k][j]
                                                                            [
                                                                            'name'],
                                                                        status: widget.navigation[i][k][j]
                                                                            [
                                                                            'status'],
                                                                        duration:
                                                                            widget.navigation[i][k][j]['duration'],
                                                                        background: _courseIndex ==
                                                                                widgetNavigation[i][k][j]['index']
                                                                            ? true
                                                                            : false,
                                                                        isFeaturedCourse:
                                                                            widget.isFeatured,
                                                                        currentProgress:
                                                                            widget.navigation[i][k][j]['completionPercentage'],
                                                                      ),
                                                                    )),
                                                            ]),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : (widgetNavigation[i][k] != null)
                                              ? _getContentObject(
                                                  widgetNavigation[i][k])
                                              : Center())
                                  ],
                                )),
                              )
                            // // Text("data")
                            else
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                ),
                                margin: EdgeInsets.only(top: 8),
                                // padding: EdgeInsets.only(top: 5, bottom: 10),
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  const Radius.circular(4.0)),
                                              color: Colors.white),
                                          child: ExpansionTile(
                                              onExpansionChanged: (value) {},
                                              // initiallyExpanded:
                                              //     _currentModuleName ==
                                              //             widgetNavigation[i]
                                              //                 [0]['moduleName']
                                              //         ? true
                                              //         : false,
                                              initiallyExpanded: true,
                                              trailing: Text(' '),
                                              backgroundColor: Colors.white,
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5, left: 15),
                                                    child: SvgPicture.asset(
                                                      widgetNavigation[i][0][
                                                                  'courseName'] !=
                                                              null
                                                          ? 'assets/img/course_icon.svg'
                                                          : 'assets/img/icons-file-types-module.svg',
                                                      color: AppColors.greys87,
                                                      // alignment: Alignment.topLeft,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      widgetNavigation[i][0][
                                                                  'moduleName'] !=
                                                              null
                                                          ? widgetNavigation[i]
                                                              [0]['moduleName']
                                                          : widgetNavigation[i]
                                                              [0]['courseName'],
                                                      style: GoogleFonts.lato(
                                                          height: 1.5,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          color:
                                                              AppColors.greys87,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )),
                                                  !widget.isFeatured
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  left: 8,
                                                                  right: 0),
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .grey16,
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      AppColors
                                                                          .positiveLight,
                                                                    ),
                                                                    strokeWidth:
                                                                        3,
                                                                    value: _getModuleProgress(
                                                                        widgetNavigation[
                                                                            i])),
                                                          ))
                                                      : Center()
                                                ],
                                              ),
                                              children: [
                                                for (int j = 0;
                                                    j <
                                                        widgetNavigation[i]
                                                            .length;
                                                    j++)
                                                  InkWell(
                                                      onTap: () {
                                                        _generateInteractTelemetryData(
                                                            widgetNavigation[i]
                                                                    [j]
                                                                ['identifier'],
                                                            widgetNavigation[i]
                                                                    [j]
                                                                ['mimeType']);
                                                        if (widgetNavigation[i]
                                                                        [j][
                                                                    'mimeType'] ==
                                                                EMimeTypes
                                                                    .assessment &&
                                                            !widget
                                                                .isFeatured) {
                                                          Navigator.push(
                                                              context,
                                                              FadeRoute(
                                                                  page: CourseAssessmentPlayer(
                                                                      widget
                                                                          .course,
                                                                      widgetNavigation[i]
                                                                              [j]
                                                                          [
                                                                          'name'],
                                                                      widgetNavigation[i]
                                                                              [
                                                                              j]
                                                                          [
                                                                          'identifier'],
                                                                      widgetNavigation[i]
                                                                              [
                                                                              j]
                                                                          [
                                                                          'artifactUrl'],
                                                                      updateContentProgress,
                                                                      widget
                                                                          .batchId,
                                                                      widgetNavigation[i]
                                                                              [
                                                                              j]
                                                                          [
                                                                          'duration'])));
                                                          setState(() {
                                                            _courseIndex =
                                                                widgetNavigation[
                                                                        i][j]
                                                                    ['index'];
                                                          });
                                                        } else if (widgetNavigation[
                                                                        i][j][
                                                                    'mimeType'] ==
                                                                EMimeTypes
                                                                    .survey &&
                                                            !widget
                                                                .isFeatured) {
                                                          if (widgetNavigation[
                                                                      i][j]
                                                                  ['status'] !=
                                                              2) {
                                                            Navigator.push(
                                                                context,
                                                                FadeRoute(
                                                                    page: ContentFeedback(
                                                                        widgetNavigation[i][j][
                                                                            'artifactUrl'],
                                                                        widgetNavigation[i][j]
                                                                            [
                                                                            'name'],
                                                                        widget
                                                                            .course,
                                                                        widgetNavigation[i][j]
                                                                            [
                                                                            'identifier'],
                                                                        widget
                                                                            .batchId)));
                                                          }
                                                          setState(() {
                                                            _courseIndex =
                                                                widgetNavigation[
                                                                        i][j]
                                                                    ['index'];
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _courseIndex = widget
                                                                    .navigation[
                                                                i][j]['index'];
                                                            // _currentModuleName =
                                                            //     widgetNavigation[
                                                            //             i][j][
                                                            //         'moduleName'];
                                                          });
                                                        }
                                                        _scrollToTop();
                                                        // print('m: $m');
                                                      },
                                                      child: Container(
                                                        // color: Colors.red,
                                                        child: widget.navigation[
                                                                        i][j][
                                                                    'mimeType'] !=
                                                                null
                                                            ? GlanceItem4(
                                                                icon: (widget.navigation[i][j]['mimeType'] == EMimeTypes.mp4 ||
                                                                        widgetNavigation[i][j]['mimeType'] ==
                                                                            EMimeTypes
                                                                                .m3u8 ||
                                                                        widgetNavigation[i][j]['mimeType'] ==
                                                                            EMimeTypes
                                                                                .mp3)
                                                                    ? 'assets/img/icons-av-play.svg'
                                                                    : (navigationItems[_courseIndex]['mimeType'] == EMimeTypes.externalLink ||
                                                                            navigationItems[_courseIndex]['mimeType'] ==
                                                                                EMimeTypes.youtubeLink)
                                                                        ? 'assets/img/link.svg'
                                                                        : widgetNavigation[i][j]['mimeType'] == EMimeTypes.pdf
                                                                            ? 'assets/img/icons-file-types-pdf-alternate.svg'
                                                                            : (widgetNavigation[i][j]['mimeType'] == EMimeTypes.assessment || widgetNavigation[i][j]['mimeType'] == EMimeTypes.newAssessment)
                                                                                ? 'assets/img/assessment_icon.svg'
                                                                                : 'assets/img/resource.svg',
                                                                text: widget
                                                                        .navigation[i]
                                                                    [j]['name'],
                                                                status: widget
                                                                        .navigation[i]
                                                                    [
                                                                    j]['status'],
                                                                duration: widget
                                                                            .navigation[
                                                                        i][j][
                                                                    'duration'],
                                                                background: _courseIndex ==
                                                                        widgetNavigation[i][j]
                                                                            [
                                                                            'index']
                                                                    ? true
                                                                    : false,
                                                                isFeaturedCourse:
                                                                    widget
                                                                        .isFeatured,
                                                                currentProgress:
                                                                    widget.navigation[
                                                                            i][j]
                                                                        [
                                                                        'completionPercentage'],
                                                              )
                                                            : Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child: Text(
                                                                    'No contents available')),
                                                      )),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          SizedBox(
                            height: widget.isFeatured ? 175 : 75,
                          )
                        ],
                      )
                    : Center()
              ])))),
      bottomSheet:
          (widget.courseProgress != null && widget.courseProgress == 100) &&
                  (_courseIndex ==
                      (widgetNavigation.last[0] == null
                          ? widgetNavigation.last['index']
                          : (widgetNavigation.last[0][0] == null
                              ? widgetNavigation.last.last['index']
                              : widgetNavigation.last[0][0][0] != null
                                  ? widgetNavigation.last.last.last['index']
                                  : 0)))
              ? (Container(
                  height: 48,
                  color: Colors.white,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextButton(
                    onPressed: () async {
                      if (!widget.isFeatured) {
                        bool isClosed = await _showFinishPopup();
                        if (isClosed) {
                          Navigator.of(context).pop();
                        }
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      // primary: Colors.white,
                      backgroundColor: AppColors.customBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: AppColors.grey16)),
                      // onSurface: Colors.grey,
                    ),
                    child: Text(
                      EnglishLang.finish,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ))
              : (widget.isFeatured ? signInOrRegister() : null),
    );
  }
}
