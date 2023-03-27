import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../localization/_langs/english_lang.dart';
import './../../../../models/index.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../constants/index.dart';
import './../../../../services/index.dart';
// import './../../../../ui/pages/_pages/text_search_results/text_search_page.dart';
import './../../../../ui/pages/index.dart';
import './../../../../util/faderoute.dart';
import './../../../../util/telemetry.dart';
// import 'dart:developer' as developer;
import './../../../../util/telemetry_db_helper.dart';

class CourseDetailsPage extends StatefulWidget {
  final String id;
  final bool isContinueLearning;
  final bool isFeaturedCourse;

  const CourseDetailsPage(
      {Key key,
      this.id,
      this.isContinueLearning = false,
      this.isFeaturedCourse = false})
      : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage>
    with SingleTickerProviderStateMixin {
  var _courseDetails;
  TabController _controller;
  final LearnService learnService = LearnService();
  // final DiscussService discussService = DiscussService(HttpClient client);
  final TelemetryService telemetryService = TelemetryService();
  List<CourseLearner> _courseLearners = [];
  List<Course> _continueLearningcourses;
  // List<CourseAuthor> _courseAuthors = [];
  List _courseAuthors = [];
  List _courseCurators = [];
  List _navigationItems = [];
  double progress = 0.0;
  dynamic _contentProgress = Map();
  Map _currentCourse;
  Map _allContentProgress;
  // bool _showPopUp = true;
  // List<Profile> _profileDetails;
  String _batchId;
  double _rating;
  var _courseProgress;
  List _issuedCertificate;
  // List<Batch> _courseBatches = [];
  // List<String> _batchesNames = [];
  int _tabIndex;
  int _catId;
  var _base64CertificateImage;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  int _start = 0;
  String pageIdentifier;
  String pageUri;
  List allEventsData = [];
  Map rollup = {};
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length:
            (!widget.isFeaturedCourse ? LearnTab.items : LearnTab.majorItems)
                .length,
        vsync: this,
        initialIndex: 0);
    _getCategoryId(widget.id);
    // _getCourseBatches(widget.id);
    // _generateTelemetryData();
  }

  Future<dynamic> _getCompletionCertificate(dynamic certificateId) async {
    final certificate =
        await learnService.getCourseCompletionCertificate(certificateId);

    setState(() {
      _base64CertificateImage = certificate;
    });
    return _base64CertificateImage;
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId(isPublic: widget.isFeaturedCourse);
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId =
        await Telemetry.getUserDeptId(isPublic: widget.isFeaturedCourse);
    Map eventData1 = Telemetry.getImpressionTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        TelemetryType.page,
        pageUri);
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
        isPublic: widget.isFeaturedCourse);
  }

  void _generateInteractTelemetryData(String contentId) async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId(isPublic: widget.isFeaturedCourse);
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId =
        await Telemetry.getUserDeptId(isPublic: widget.isFeaturedCourse);
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        (widget.isFeaturedCourse
                ? TelemetryPageIdentifier.publicCourseDetailsPageId
                : TelemetryPageIdentifier.courseDetailsPageId) +
            '_' +
            contentId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.courseTab);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
        isPublic: widget.isFeaturedCourse);
  }

  void _triggerInteractTelemetryData(int index) {
    if (index == 0) {
      _generateInteractTelemetryData(TelemetrySubType.overviewTab);
    } else if (index == 1) {
      _generateInteractTelemetryData(TelemetrySubType.contentTab);
    } else if (index == 2) {
      _generateInteractTelemetryData(TelemetrySubType.discussionTab);
    } else
      _generateInteractTelemetryData(TelemetrySubType.learnersTab);
  }

  // Future<void> _getCourseBatches(courseId) async {
  //   _courseBatches = await Provider.of<LearnRepository>(context, listen: false).getBatchList(widget.id);
  //   _batchesNames.add(EnglishLang.selectBatchToEnroll);
  //   for (int i = 0; i < _courseBatches.length; i++) {
  //     _batchesNames.add(_courseBatches[i].name);
  //   }
  //   // print('_courseBatches:' + _courseBatches.toString());
  // }

  _getCourseProgress() async {
    _continueLearningcourses =
        await Provider.of<LearnRepository>(context, listen: false)
            .getContinueLearningCourses();
    final course = _continueLearningcourses
        .where((element) => element.raw['courseId'] == widget.id);

    Course courseDetails = course.length > 0 ? course.first : null;
    if (courseDetails != null) {
      var progress = courseDetails.raw['completionPercentage'];
      List issuedCertificate = courseDetails.raw['issuedCertificates'];
      String batchId = courseDetails.raw['batchId'];
      setState(() {
        _courseProgress = progress;
        _issuedCertificate = issuedCertificate;
        _batchId = batchId;
      });
    }
  }

  Future<dynamic> _getCourseDetails() async {
    if (_courseDetails == null) {
      _courseDetails = widget.isFeaturedCourse
          ? await learnService.getCourseDetails(widget.id, isFeatured: true)
          : await learnService.getCourseDetails(widget.id);
      // print(_courseDetails.runtimeType.toString());
      if (_courseDetails.toString() == EnglishLang.notFound) {
        return _courseDetails;
      }
      // _courseAuthors = await Provider.of<LearnRepository>(context, listen: false).getCourseAuthors(widget.id);
      if (_courseDetails['creatorContacts'] != null) {
        _courseCurators = jsonDecode(_courseDetails['creatorContacts']);
      } else {
        _courseCurators = [];
      }
      if (_courseDetails['creatorDetails'] != null) {
        _courseAuthors = jsonDecode(_courseDetails['creatorDetails']);
      } else {
        _courseAuthors = [];
      }
      await _generateNavigation();
      if (!widget.isFeaturedCourse) {
        _batchId = _courseDetails['batches'] != null
            ? (_courseDetails['batches'].runtimeType == String
                ? jsonDecode(_courseDetails['batches'])
                    .first['batchId']
                    .toString()
                : _courseDetails['batches'].first['batchId'].toString())
            : _batchId;
        await _getCourseProgress();
        if (_batchId != null) {
          await _readContentProgress();
          setState(() {});
        }
        if (_batchId != null && _courseProgress == 100) {
          final certificateId = _issuedCertificate.length > 0
              ? (_issuedCertificate.length > 1
                  ? _issuedCertificate[1]['identifier']
                  : _issuedCertificate[0]['identifier'])
              : null;
          if (certificateId != null) {
            await _getCompletionCertificate(certificateId);
          }
        }
      }
    }
    return _courseDetails;
  }

  _getCourseLearners() async {
    if (!widget.isFeaturedCourse) {
      _courseLearners =
          await Provider.of<LearnRepository>(context, listen: false)
              .getCourseLearners(widget.id);
      // _profileDetails =
      //     await Provider.of<ProfileRepository>(context, listen: false)
      //         .getProfileDetailsById('');
    }
    return _courseLearners;
  }

  _enrollCourse() async {
    var batchDetails = await learnService.autoEnrollBatch(widget.id);
    // print('batchDetails $batchDetails');
    setState(() {
      _batchId = batchDetails['batchId'];
    });
  }

  void updateContents(param) {
    _getCourseDetails();
  }

  Future<dynamic> _readContentProgress() async {
    // print('_readContentProgress');
    String courseId = _courseDetails['identifier'];
    var response = await learnService.readContentProgress(courseId, _batchId);
    // print('readContentProgress: ' + response.toString());
    List _sortContentProgress = [];
    for (int i = 0; i < response['result']['contentList'].length; i++) {
      if (response['result']['contentList'][i]['lastAccessTime'] != null) {
        _sortContentProgress.add(response['result']['contentList'][i]);
      } else if (response['result']['contentList'][i]['completionPercentage'] !=
          null) {
        _sortContentProgress.add(response['result']['contentList'][i]);
      }
    }
    if (_sortContentProgress.length > 0) {
      _sortContentProgress.sort((a, b) => (a['lastAccessTime'] != null
              ? a['lastAccessTime']
              : a['completionPercentage'])
          .compareTo(b['lastAccessTime'] != null
              ? b['lastAccessTime']
              : b['completionPercentage']));
    } else {
      _sortContentProgress = response['result']['contentList'];
    }

    _sortContentProgress = _sortContentProgress.reversed.toList();
    _allContentProgress = response;

    for (int i = 0; i < _navigationItems.length; i++) {
      if (_navigationItems[i][0] == null) {
        for (int j = 0; j < response['result']['contentList'].length; j++) {
          if (_navigationItems[i]['contentId'] ==
              response['result']['contentList'][j]['contentId']) {
            progress = response['result']['contentList'][j]
                        ['completionPercentage'] !=
                    null
                ? response['result']['contentList'][j]['completionPercentage'] /
                    100
                : 0;
            _contentProgress[response['result']['contentList'][j]
                ['contentId']] = progress;
            _navigationItems[i]['completionPercentage'] = progress;

            if (response['result']['contentList'].length > 0) {
              _navigationItems[i]['currentProgress'] = (response['result']
                              ['contentList'][j]['progressdetails'] !=
                          null &&
                      response['result']['contentList'][j]['progressdetails']
                              ['current'] !=
                          null)
                  ? response['result']['contentList'][j]['progressdetails']
                          ['current']
                      .last
                  : 0;
              _navigationItems[i]['status'] =
                  response['result']['contentList'][j]['status'];
              _navigationItems[i]['currentProgress'] = progress;
            }
          }
          if (_sortContentProgress.length > 0) {
            if (_navigationItems[i]['contentId'] ==
                _sortContentProgress[0]['contentId']) {
              _currentCourse = _navigationItems[i];
              _currentCourse['moduleItems'] = _navigationItems.length;
              _currentCourse['currentIndex'] = i + 1;
            }
          }
        }
      } else if (_navigationItems[i][0][0] != null) {
        for (var m = 0; m < _navigationItems[i].length; m++) {
          for (int k = 0; k < _navigationItems[i][m].length; k++) {
            for (int j = 0; j < response['result']['contentList'].length; j++) {
              if (_navigationItems[i][m][k] != null) {
                if (_navigationItems[i][m][k]['contentId'] ==
                    response['result']['contentList'][j]['contentId']) {
                  if (_navigationItems[i][m][k][0] == null) {
                    if (response['result']['contentList'][j]
                            ['completionPercentage'] !=
                        null) {
                      progress = response['result']['contentList'][j]
                              ['completionPercentage'] /
                          100;
                    } else {
                      progress = 0;
                    }
                    _contentProgress[response['result']['contentList'][j]
                        ['contentId']] = progress;
                    _navigationItems[i][m][k]['completionPercentage'] =
                        progress;
                    if (response['result']['contentList'].length > 0) {
                      if (response['result']['contentList'][j]
                                  ['progressdetails'] !=
                              null &&
                          response['result']['contentList'][j]
                                  ['progressdetails']['current'] !=
                              null) {
                        _navigationItems[i][m][k]['currentProgress'] =
                            response['result']['contentList'][j]
                                            ['progressdetails']['current']
                                        .length >
                                    0
                                ? response['result']['contentList'][j]
                                        ['progressdetails']['current']
                                    .last
                                : 0;
                      }
                      _navigationItems[i][m][k]['status'] =
                          response['result']['contentList'][j]['status'];
                      _navigationItems[i][m][k]['currentProgress'] = progress;
                    }
                  } else {
                    if (response['result']['contentList'][j]
                            ['completionPercentage'] !=
                        null) {
                      progress = response['result']['contentList'][j]
                              ['completionPercentage'] /
                          100;
                    } else {
                      progress = 0;
                    }
                    _contentProgress[response['result']['contentList'][j]
                        ['contentId']] = progress;
                    if (response['result']['contentList'].length > 0) {
                      if (response['result']['contentList'][j]
                                  ['progressdetails'] !=
                              null &&
                          response['result']['contentList'][j]
                                  ['progressdetails']['current'] !=
                              null) {
                        _navigationItems[i][m][k][0]['currentProgress'] =
                            response['result']['contentList'][j]
                                            ['progressdetails']['current']
                                        .length >
                                    0
                                ? response['result']['contentList'][j]
                                        ['progressdetails']['current']
                                    .last
                                : 0;
                      }
                      _navigationItems[i][m][k][0]['status'] =
                          response['result']['contentList'][j]['status'];
                      _navigationItems[i][m][k][0]['currentProgress'] =
                          progress;
                    }
                  }
                }
                //Added this condition
                if (_sortContentProgress.length > 0) {
                  if (_navigationItems[i][m][k]['contentId'] ==
                      _sortContentProgress[0]['contentId']) {
                    _currentCourse = _navigationItems[i][m][k];
                    _currentCourse['moduleItems'] = _navigationItems.length;
                    _currentCourse['currentIndex'] = k + 1;
                  }
                }
              }
              // Added this as latest
              else if (_navigationItems[i][m][0] == null) {
                for (int j = 0;
                    j < response['result']['contentList'].length;
                    j++) {
                  if (_navigationItems[i][m]['contentId'] ==
                      response['result']['contentList'][j]['contentId']) {
                    progress = response['result']['contentList'][j]
                                ['completionPercentage'] !=
                            null
                        ? response['result']['contentList'][j]
                                ['completionPercentage'] /
                            100
                        : 0;
                    _contentProgress[response['result']['contentList'][j]
                        ['contentId']] = progress;
                    _navigationItems[i][m]['completionPercentage'] = progress;

                    if (response['result']['contentList'].length > 0) {
                      _navigationItems[i][m]['currentProgress'] =
                          (response['result']['contentList'][j]
                                          ['progressdetails'] !=
                                      null &&
                                  response['result']['contentList'][j]
                                          ['progressdetails']['current'] !=
                                      null)
                              ? response['result']['contentList'][j]
                                      ['progressdetails']['current']
                                  .last
                              : 0;
                      _navigationItems[i][m]['status'] =
                          response['result']['contentList'][j]['status'];
                      _navigationItems[i][m]['currentProgress'] = progress;
                    }
                  }
                  if (_sortContentProgress.length > 0) {
                    if (_navigationItems[i][m]['contentId'] ==
                        _sortContentProgress[0]['contentId']) {
                      _currentCourse = _navigationItems[i][m];
                      _currentCourse['moduleItems'] = _navigationItems.length;
                      _currentCourse['currentIndex'] = i + 1;
                    }
                  }
                }
              }

              // print(
              // "${_navigationItems[i][k]['contentId']}, ${response['result']['contentList'][j]['contentId']}");
              if (_sortContentProgress.length > 0) {
                if (_navigationItems[i][m][k] != null) {
                  if (_navigationItems[i][m][k]['contentId'] ==
                      _sortContentProgress[0]['contentId']) {
                    _currentCourse = _navigationItems[i][m][k];
                    _currentCourse['moduleItems'] = _navigationItems[i].length;
                    _currentCourse['currentIndex'] = k + 1;
                  }
                }
              }
            }
          }
        }
      } else {
        for (int k = 0; k < _navigationItems[i].length; k++) {
          for (int j = 0; j < response['result']['contentList'].length; j++) {
            if (_navigationItems[i][k]['contentId'] ==
                response['result']['contentList'][j]['contentId']) {
              if (_navigationItems[i][k][0] == null) {
                if (response['result']['contentList'][j]
                        ['completionPercentage'] !=
                    null) {
                  progress = response['result']['contentList'][j]
                          ['completionPercentage'] /
                      100;
                } else {
                  progress = 0;
                }
                _contentProgress[response['result']['contentList'][j]
                    ['contentId']] = progress;
                _navigationItems[i][k]['completionPercentage'] = progress;
                if (response['result']['contentList'].length > 0) {
                  if (response['result']['contentList'][j]['progressdetails'] !=
                          null &&
                      response['result']['contentList'][j]['progressdetails']
                              ['current'] !=
                          null) {
                    _navigationItems[i][k]['currentProgress'] =
                        response['result']['contentList'][j]['progressdetails']
                                        ['current']
                                    .length >
                                0
                            ? response['result']['contentList'][j]
                                    ['progressdetails']['current']
                                .last
                            : 0;
                  }
                  _navigationItems[i][k]['status'] =
                      response['result']['contentList'][j]['status'];
                  _navigationItems[i][k]['currentProgress'] = progress;
                }
              } else {
                if (response['result']['contentList'][j]
                        ['completionPercentage'] !=
                    null) {
                  progress = response['result']['contentList'][j]
                          ['completionPercentage'] /
                      100;
                } else {
                  progress = 0;
                }
                _contentProgress[response['result']['contentList'][j]
                    ['contentId']] = progress;
                if (response['result']['contentList'].length > 0) {
                  if (response['result']['contentList'][j]['progressdetails'] !=
                          null &&
                      response['result']['contentList'][j]['progressdetails']
                              ['current'] !=
                          null) {
                    _navigationItems[i][k][0]['currentProgress'] =
                        response['result']['contentList'][j]['progressdetails']
                                        ['current']
                                    .length >
                                0
                            ? response['result']['contentList'][j]
                                    ['progressdetails']['current']
                                .last
                            : 0;
                  }
                  _navigationItems[i][k][0]['status'] =
                      response['result']['contentList'][j]['status'];
                  _navigationItems[i][k][0]['currentProgress'] = progress;
                }
              }
            }
            // print(
            // "${_navigationItems[i][k]['contentId']}, ${response['result']['contentList'][j]['contentId']}");
            if (_sortContentProgress.length > 0) {
              if (_navigationItems[i][k]['contentId'] ==
                  _sortContentProgress[0]['contentId']) {
                _currentCourse = _navigationItems[i][k];
                _currentCourse['moduleItems'] = _navigationItems[i].length;
                _currentCourse['currentIndex'] = k + 1;
              }
            }
          }
        }
      }
    }

    if (_start == 0) {
      pageIdentifier = !widget.isFeaturedCourse
          ? TelemetryPageIdentifier.courseDetailsPageId
          : TelemetryPageIdentifier.publicCourseDetailsPageId;
      pageUri = (!widget.isFeaturedCourse
              ? TelemetryPageIdentifier.courseDetailsPageUri
              : TelemetryPageIdentifier.publicCourseDetailsPageUri)
          .replaceAll(':do_ID', widget.id);
      if (_batchId != null) {
        pageUri = '?batchId=$_batchId';
      }
      rollup['l1'] = widget.id;
      _generateTelemetryData();
    }
    // _startTimer();
    setState(() {});

    return response['result']['contentList'];
  }

  Future<dynamic> _generateNavigation() async {
    _navigationItems = [];
    int index;
    int k = 0;
    if (_courseDetails['children'] != null) {
      for (index = 0; index < _courseDetails['children'].length; index++) {
        if ((_courseDetails['children'][index]['contentType'] == 'Collection' ||
            _courseDetails['children'][index]['contentType'] == 'CourseUnit')) {
          // Added this
          List temp = [];

          if (_courseDetails['children'][index]['children'] != null) {
            for (int i = 0;
                i < _courseDetails['children'][index]['children'].length;
                i++) {
              // Added this
              temp.add({
                'index': k++,
                'moduleName': _courseDetails['children'][index]['name'],
                'mimeType': _courseDetails['children'][index]['children'][i]
                    ['mimeType'],
                'identifier': _courseDetails['children'][index]['children'][i]
                    ['identifier'],
                'name': _courseDetails['children'][index]['children'][i]
                    ['name'],
                'artifactUrl': _courseDetails['children'][index]['children'][i]
                    ['artifactUrl'],
                'contentId': _courseDetails['children'][index]['children'][i]
                    ['identifier'],
                'currentProgress': '0',
                'status': 0,
                'moduleDuration':
                    _courseDetails['children'][index]['duration'] != null
                        ? Helper.getFullTimeFormat(
                            _courseDetails['children'][index]['duration'])
                        : '',
                'duration': ((_courseDetails['children'][index]['children'][i]
                                    ['duration'] !=
                                null &&
                            _courseDetails['children'][index]['children'][i]
                                    ['duration'] !=
                                '') ||
                        (_courseDetails['children'][index]['children'][i]
                                    ['expectedDuration'] !=
                                null &&
                            _courseDetails['children'][index]['children'][i]
                                    ['expectedDuration'] !=
                                ''))
                    ? _courseDetails['children'][index]['children'][i]['mimeType'] ==
                            EMimeTypes.pdf
                        ? 'PDF - ' +
                            Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                        : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.mp4
                            ? 'Video - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                            : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.mp3
                                ? 'Audio - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                                : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.assessment
                                    ? 'Assessment - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                                    : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.survey
                                        ? 'Survey - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                                        : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.newAssessment
                                            ? Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['expectedDuration'].toString())
                                            : 'Resource - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                    : ''
              });
            }
          } else {
            temp.add({
              'index': k++,
              'moduleName': _courseDetails['children'][index]['name'],
              'moduleDuration':
                  _courseDetails['children'][index]['duration'] != null
                      ? Helper.getFullTimeFormat(
                          _courseDetails['children'][index]['duration'])
                      : '',
              'identifier': _courseDetails['children'][index]['identifier'],
            });
          }
          // temp.add({
          //   'index': k++,
          //   'moduleName': _courseDetails['children'][index]['name'],
          //   'mimeType': 'Survey',
          //   'name': 'Survey',
          //   // 'artifactUrl': widget.course['children'][index]['children'][i]
          //   //     ['artifactUrl'],
          //   // 'contentId': widget.course['children'][index]['children'][i]
          //   //     ['identifier'],
          //   // 'currentProgress': '0',
          //   'completionPercentage': 100,
          //   'status': 0,
          //   // 'duration': '1s',
          //   'duration': 'Survey - ' + Helper.getFullTimeFormat('1200')
          // });

          // Added this
          _navigationItems.add(temp);
        }
        //Added below condition to handle course items
        else if (_courseDetails['children'][index]['contentType'] == 'Course') {
          List courseList = [];
          for (var i = 0;
              i < _courseDetails['children'][index]['children'].length;
              i++) {
            List temp = [];
            if (_courseDetails['children'][index]['children'][i]
                        ['contentType'] ==
                    'Collection' ||
                _courseDetails['children'][index]['children'][i]
                        ['contentType'] ==
                    'CourseUnit') {
              for (var j = 0;
                  j <
                      _courseDetails['children'][index]['children'][i]
                              ['children']
                          .length;
                  j++) {
                temp.add({
                  'index': k++,
                  'courseName': _courseDetails['children'][index]['name'],
                  'moduleName': _courseDetails['children'][index]['children'][i]
                      ['name'],
                  'mimeType': _courseDetails['children'][index]['children'][i]
                      ['children'][j]['mimeType'],
                  'identifier': _courseDetails['children'][index]['children'][i]
                      ['children'][j]['identifier'],
                  'name': _courseDetails['children'][index]['children'][i]
                      ['children'][j]['name'],
                  'artifactUrl': _courseDetails['children'][index]['children']
                      [i]['children'][j]['artifactUrl'],
                  'contentId': _courseDetails['children'][index]['children'][i]
                      ['children'][j]['identifier'],
                  'currentProgress': '0',
                  'completionPercentage': '0',
                  'status': 0,
                  'moduleDuration': _courseDetails['children'][index]
                              ['children'][i]['duration'] !=
                          null
                      ? Helper.getFullTimeFormat(_courseDetails['children']
                          [index]['children'][i]['duration'])
                      : '',
                  'courseDuration':
                      _courseDetails['children'][index]['duration'] != null
                          ? Helper.getFullTimeFormat(
                              _courseDetails['children'][index]['duration'])
                          : '',
                  'duration': ((_courseDetails['children'][index]['children'][i]
                                      ['children'][j]['duration'] !=
                                  null &&
                              _courseDetails['children'][index]['children'][i]['children'][j]['duration'] !=
                                  '') ||
                          (_courseDetails['children'][index]['children'][i]
                                      ['children'][j]['expectedDuration'] !=
                                  null &&
                              _courseDetails['children'][index]['children'][i]
                                      ['children'][j]['expectedDuration'] !=
                                  ''))
                      ? _courseDetails['children'][index]['children'][i]['children'][j]['mimeType'] == EMimeTypes.pdf
                          ? 'PDF - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['duration'])
                          : _courseDetails['children'][index]['children'][i]['children'][j]['mimeType'] == EMimeTypes.mp4
                              ? 'Video - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['duration'])
                              : _courseDetails['children'][index]['children'][i]['children'][j]['mimeType'] == EMimeTypes.mp3
                                  ? 'Audio - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['duration'])
                                  : _courseDetails['children'][index]['children'][i]['children'][j]['mimeType'] == EMimeTypes.assessment
                                      ? 'Assessment - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['duration'])
                                      : _courseDetails['children'][index]['children'][i]['children'][j]['mimeType'] == EMimeTypes.survey
                                          ? 'Survey - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['duration'])
                                          : _courseDetails['children'][index]['children'][i]['children'][j]['mimeType'] == EMimeTypes.newAssessment
                                              ? Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['expectedDuration'].toString())
                                              : 'Resource - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['duration'])
                      : 'Link - ' + _courseDetails['children'][index]['children'][i]['children'][j]['duration'] != null
                          ? Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['children'][j]['duration'])
                          : ''
                });
              }
              courseList.add(temp);
            } else {
              courseList.add({
                'index': k++,
                'courseName': _courseDetails['children'][index]['name'],
                'mimeType': _courseDetails['children'][index]['children'][i]
                    ['mimeType'],
                'identifier': _courseDetails['children'][index]['children'][i]
                    ['identifier'],
                'name': _courseDetails['children'][index]['children'][i]
                    ['name'],
                'artifactUrl': _courseDetails['children'][index]['children'][i]
                    ['artifactUrl'],
                'contentId': _courseDetails['children'][index]['children'][i]
                    ['identifier'],
                'currentProgress': '0',
                'completionPercentage': '0',
                'status': 0,
                // 'duration': '1s',
                'duration': ((_courseDetails['children'][index]['children'][i]
                                    ['duration'] !=
                                null &&
                            _courseDetails['children'][index]['children'][i]
                                    ['duration'] !=
                                '') ||
                        (_courseDetails['children'][index]['children'][i]
                                    ['expectedDuration'] !=
                                null &&
                            _courseDetails['children'][index]['children'][i]
                                    ['expectedDuration'] !=
                                ''))
                    ? _courseDetails['children'][index]['children'][i]['mimeType'] ==
                            EMimeTypes.pdf
                        ? 'PDF - ' +
                            Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                        : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.mp4
                            ? 'Video - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                            : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.mp3
                                ? 'Audio - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                                : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.assessment
                                    ? 'Assessment - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                                    : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.survey
                                        ? 'Survey - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                                        : _courseDetails['children'][index]['children'][i]['mimeType'] == EMimeTypes.newAssessment
                                            ? Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['expectedDuration'].toString())
                                            : 'Resource - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                    : 'Link - ' + _courseDetails['children'][index]['children'][i]['duration'] != null
                        ? Helper.getFullTimeFormat(_courseDetails['children'][index]['children'][i]['duration'])
                        : ''
              });
            }
          }
          _navigationItems.add(courseList);
        } else {
          _navigationItems.add({
            'index': k++,
            'mimeType': _courseDetails['children'][index]['mimeType'],
            'identifier': _courseDetails['children'][index]['identifier'],
            'name': _courseDetails['children'][index]['name'],
            'artifactUrl': _courseDetails['children'][index]['artifactUrl'],
            'contentId': _courseDetails['children'][index]['identifier'],
            'currentProgress': '0',
            'status': 0,
            'courseDuration':
                _courseDetails['children'][index]['duration'] != null
                    ? Helper.getFullTimeFormat(
                        _courseDetails['children'][index]['duration'])
                    : '',
            'duration': ((_courseDetails['children'][index]['duration'] != null &&
                        _courseDetails['children'][index]['duration'] != '') ||
                    ((_courseDetails['children'][index]['expectedDuration'] !=
                            null &&
                        _courseDetails['children'][index]['expectedDuration'] !=
                            '')))
                ? _courseDetails['children'][index]['mimeType'] ==
                        EMimeTypes.pdf
                    ? 'PDF - ' +
                        Helper.getFullTimeFormat(
                            _courseDetails['children'][index]['duration'])
                    : _courseDetails['children'][index]['mimeType'] ==
                            EMimeTypes.mp4
                        ? 'Video - ' +
                            Helper.getFullTimeFormat(
                                _courseDetails['children'][index]['duration'])
                        : _courseDetails['children'][index]['mimeType'] ==
                                EMimeTypes.mp3
                            ? 'Audio - ' +
                                Helper.getFullTimeFormat(_courseDetails['children'][index]['duration'])
                            : _courseDetails['children'][index]['mimeType'] == EMimeTypes.assessment
                                ? 'Assessment - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['duration'])
                                : _courseDetails['children'][index]['mimeType'] == EMimeTypes.survey
                                    ? 'Survey - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['duration'])
                                    : _courseDetails['children'][index]['mimeType'] == EMimeTypes.newAssessment
                                        ? Helper.getFullTimeFormat(_courseDetails['children'][index]['expectedDuration'].toString())
                                        : 'Resource - ' + Helper.getFullTimeFormat(_courseDetails['children'][index]['duration'])
                : ''
          });
        }
        // developer.log(jsonEncode(_navigationItems));
      }
    }
    return _navigationItems;
    // Code for testing youtube videos
    // _navigationItems.add({
    //   'mimeType': EMimeTypes.externalLink,
    //   'identifier': 'https://www.youtube.com/embed/_NKvJ43XBkY',
    //   'name': 'Youtube test',
    //   'artifactUrl': 'https://www.youtube.com/embed/_NKvJ43XBkY'
    // });
    // print((_navigationItems[0] != null).toString());
  }

  // void enrollToBatch(String batchName) {
  //   print(batchName);
  // }

  Future<int> _getCategoryId(String id) async {
    final response = await DiscussService.getCategoryIdOfCourse(id);
    // print(response.toString());
    int catId;
    if (response.length > 0) {
      // setState(() {
      _catId = response[0];
      // });
      // catId = response[0];
    }
    // return response.length > 0 ? response[0] : null;
    return catId;
  }

  void _getRating(rating) async {
    _rating = rating;
    // print('Rating: ' + _rating.toString());
  }

  void _updateData(bool status) async {
    if (!widget.isFeaturedCourse) {
      await _readContentProgress();
      setState(() {});
    }
  }

  List<Widget> _getTags(tagsList) {
    List<Widget> tags = [];
    for (int i = 0; i < tagsList.length; i++) {
      tags.add(InkWell(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.grey04,
              border: Border.all(color: AppColors.grey08),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Text(
                tagsList[i],
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 1.0,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return tags;
  }

  @override
  void dispose() async {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // developer.log(_base64CertificateImage.toString());
    return Scaffold(
        body: DefaultTabController(
            length: LearnTab.items.length,
            child: SafeArea(
              child: FutureBuilder(
                  future: _getCourseDetails(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == EnglishLang.notFound) {
                        return Scaffold(
                          appBar: AppBar(
                            titleSpacing: 0,
                            // leading: IconButton(
                            //   icon: Icon(Icons.clear, color: AppColors.greys60),
                            //   onPressed: () => Navigator.of(context).pop(),
                            // ),
                            title: Text(
                              EnglishLang.back,
                              style: GoogleFonts.montserrat(
                                color: AppColors.greys87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          body: Stack(
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 125),
                                        child: SvgPicture.asset(
                                          'assets/img/empty_search.svg',
                                          alignment: Alignment.center,
                                          // color: AppColors.grey16,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      EnglishLang.resourceNotFound,
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        height: 1.5,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        var course = snapshot.data;
                        var imageExtension;
                        if (snapshot.data['posterImage'] != null &&
                            snapshot.data['posterImage'] != '') {
                          imageExtension = course['posterImage']
                              .substring(course['posterImage'].length - 3);
                        }
                        return NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverAppBar(
                                  pinned: false,
                                  // expandedHeight: 450,
                                  expandedHeight:
                                      MediaQuery.of(context).size.height *
                                          0.525,
                                  leading: BackButton(color: AppColors.greys60),
                                  flexibleSpace: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 0, 8),
                                              child: !widget.isFeaturedCourse
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.search,
                                                        color:
                                                            AppColors.greys60,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        TextSearchPage()));
                                                      })
                                                  : SizedBox(
                                                      height: 36,
                                                    ),
                                            )
                                          ]),
                                      Container(
                                          width: double.infinity,
                                          child: course['posterImage'] != null
                                              ? imageExtension != 'svg'
                                                  ? Image.network(
                                                      Helper.convertToPortalUrl(
                                                          course[
                                                              'posterImage']),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Image.asset(
                                                            'assets/img/image_placeholder.jpg',
                                                            // width: 320,
                                                            // height: 182,
                                                            fit: BoxFit.cover,
                                                          ))
                                                  : Image.asset(
                                                      'assets/img/image_placeholder.jpg',
                                                      // width: 320,
                                                      // height: 182,
                                                      fit: BoxFit.cover,
                                                    )
                                              : Image.asset(
                                                  'assets/img/image_placeholder.jpg',
                                                  // width: 320,
                                                  // height: 182,
                                                  fit: BoxFit.cover,
                                                )),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 20, 10),
                                        child: Text(
                                          course['name'] != null
                                              ? course['name']
                                              : '',
                                          style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          course['purpose'] != null
                                              ? course['purpose']
                                              : '',
                                          maxLines: 2,
                                          style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            height: 1.5,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            // Container(
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, top: 15),
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Text(
                                                        (_rating != null
                                                                ? double.parse(
                                                                        (_rating)
                                                                            .toStringAsFixed(1))
                                                                    .toString()
                                                                : 0.0)
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                          color: AppColors
                                                              .primaryOne,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                    RatingBarIndicator(
                                                      rating: _rating != null
                                                          ? _rating
                                                          : 0,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Icon(
                                                        Icons.star,
                                                        color: AppColors
                                                            .primaryOne,
                                                      ),
                                                      itemCount: 5,
                                                      itemSize: 20.0,
                                                      direction:
                                                          Axis.horizontal,
                                                    ),
                                                  ],
                                                )),
                                            // Spacer(),
                                            // _courseBatches.length > 0
                                            //     ? Container(
                                            //         padding: EdgeInsets.only(
                                            //             top: 10,
                                            //             // left: 20,
                                            //             right: 20),
                                            //         child: SimpleDropdown(
                                            //             items: _batchesNames,
                                            //             selectedItem:
                                            //                 _batchesNames[0],
                                            //             parentAction:
                                            //                 enrollToBatch),
                                            //       )
                                            //     : Center(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 300,
                                            top: 8,
                                            bottom: 10),
                                        child: Container(
                                          height: 48,
                                          width: 48,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: course['creatorLogo'] !=
                                                            null &&
                                                        course['creatorLogo'] !=
                                                            ''
                                                    ? NetworkImage(Helper
                                                        .convertToPortalUrl(
                                                            course[
                                                                'creatorLogo']))
                                                    : AssetImage(
                                                        'assets/img/igot_icon.png'),
                                                fit: BoxFit.scaleDown),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(4.0)),
                                            // shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.grey08,
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                                offset: Offset(
                                                  3,
                                                  3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      course['keywords'] != null &&
                                              course['keywords'].length > 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Wrap(
                                                  children: _getTags(
                                                      course['keywords'])),
                                            )
                                          : Center()
                                      // SvgPicture.memory(_base64CertificateImage)
                                      // SvgPicture.string(
                                      //   _base64CertificateImage.toString(),
                                      //   fit: BoxFit.cover,
                                      // )
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
                                      for (var tabItem
                                          in (!widget.isFeaturedCourse
                                              ? LearnTab.items
                                              : LearnTab.majorItems))
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
                                    onTap: (value) {
                                      setState(() {
                                        _tabIndex = _controller.index;
                                      });
                                      _triggerInteractTelemetryData(
                                          _controller.index);
                                    },
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
                                future:
                                    Future.delayed(Duration(milliseconds: 500)),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  return !widget.isFeaturedCourse
                                      ? TabBarView(
                                          controller: _controller,
                                          children: [
                                            CourseOverviewPage(
                                              course: course,
                                              courseAuthors: _courseAuthors,
                                              courseCurators: _courseCurators,
                                              // taggedCompetency:
                                              //     _profileDetails != null
                                              //         ? _profileDetails
                                              //             .first.competencies
                                              //         : [],
                                              certificate:
                                                  _base64CertificateImage,
                                              progress: _courseProgress,
                                              parentAction: _getRating,
                                              isStarted: (_navigationItems
                                                              .length >
                                                          0 &&
                                                      _currentCourse != null)
                                                  ? true
                                                  : false,
                                              isFeatured:
                                                  widget.isFeaturedCourse,
                                            ),
                                            CourseContentPage(
                                              course: course,
                                              isContinueLearning:
                                                  widget.isContinueLearning,
                                              batchId: _batchId,
                                              contentProgress:
                                                  _allContentProgress,
                                              parentAction: updateContents,
                                              isFeatured:
                                                  widget.isFeaturedCourse,
                                            ),
                                            CourseDiscussionPage(course),
                                            FutureBuilder(
                                                future: _getCourseLearners(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<dynamic>
                                                        snapshot) {
                                                  return CourseLearnersPage(
                                                      course, _courseLearners);
                                                }),
                                          ],
                                        )
                                      : TabBarView(
                                          controller: _controller,
                                          children: [
                                            CourseOverviewPage(
                                              course: course,
                                              courseAuthors: _courseAuthors,
                                              courseCurators: _courseCurators,
                                              // taggedCompetency:
                                              //     _profileDetails != null
                                              //         ? _profileDetails
                                              //             .first.competencies
                                              //         : [],
                                              certificate:
                                                  _base64CertificateImage,
                                              progress: _courseProgress,
                                              parentAction: _getRating,
                                              isStarted: (_navigationItems
                                                              .length >
                                                          0 &&
                                                      _currentCourse != null)
                                                  ? true
                                                  : false,
                                              isFeatured:
                                                  widget.isFeaturedCourse,
                                            ),
                                            CourseContentPage(
                                              course: course,
                                              isContinueLearning:
                                                  widget.isContinueLearning,
                                              batchId: _batchId,
                                              contentProgress:
                                                  _allContentProgress,
                                              parentAction: updateContents,
                                              isFeatured:
                                                  widget.isFeaturedCourse,
                                            ),
                                          ],
                                        );
                                }),
                          ),
                        );
                      }
                    } else {
                      // return Center(child: CircularProgressIndicator());
                      return PageLoader();
                    }
                  }),
            )),
        floatingActionButton: (_tabIndex == 2 && !widget.isFeaturedCourse)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: OpenContainer(
                    closedElevation: 10,
                    openColor: AppColors.primaryThree,
                    transitionDuration: Duration(milliseconds: 750),
                    openBuilder: (context, _) => NewDiscussionPage(
                          isCourseDiscussion: true,
                          cid: _catId,
                        ),
                    closedShape: CircleBorder(),
                    closedColor: AppColors.primaryThree,
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedBuilder: (context, openContainer) =>
                        FloatingActionButton(
                          //   boxShadow: [
                          //   BoxShadow(
                          //     color: AppColors.grey08,
                          //     blurRadius: 3,
                          //     spreadRadius: 0,
                          //     offset: Offset(
                          //       3,
                          //       3,
                          //     ),
                          //   ),
                          // ],
                          elevation: 10,
                          heroTag: 'newDiscussion',
                          onPressed: openContainer,
                          child: Icon(Icons.add),
                          backgroundColor: AppColors.primaryThree,
                        )),
              )
            : Center(),
        bottomSheet: FutureBuilder(
            future: _getCourseDetails(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return _navigationItems.length > 0
                    ? _currentCourse != null
                        ? Container(
                            height: 48,
                            color: Colors.white,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                                if (_courseProgress == 100) {
                                  setState(() {
                                    _currentCourse =
                                        _navigationItems.first[0] == null
                                            ? _navigationItems.first
                                            : (_navigationItems.first[0][0] ==
                                                    null
                                                ? _navigationItems.first.first
                                                : _navigationItems
                                                    .first.first.first);
                                  });
                                }
                                Navigator.push(
                                    context,
                                    FadeRoute(
                                        page: CourseNavigationPage(
                                      course: _courseDetails,
                                      identifier: _currentCourse['contentId'],
                                      contentProgress: _allContentProgress,
                                      navigation: _navigationItems,
                                      moduleName:
                                          _currentCourse['moduleName'] != null
                                              ? _currentCourse['moduleName']
                                              : (_currentCourse['courseName']),
                                      batchId: _batchId,
                                      courseProgress: _courseProgress,
                                      updateCourseProgress: _getCourseProgress,
                                    )));
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
                                _courseProgress == 100
                                    ? EnglishLang.startAgain
                                    : EnglishLang.resume,
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        // Container(
                        //     height: _currentCourse != null ? 75 : 0,
                        //     child: Stack(children: [
                        //       Positioned(
                        //           child: Align(
                        //               alignment: FractionalOffset.bottomCenter,
                        //               child: Container(
                        //                   // padding: EdgeInsets.all(20),
                        //                   width: double.infinity,
                        //                   height: 75,
                        //                   color: Colors.white,
                        //                   child: InkWell(
                        //                       onTap: () {
                        //                         Navigator.of(context)
                        //                             .pop(false);
                        //                         Navigator.push(
                        //                             context,
                        //                             FadeRoute(
                        //                                 page:
                        //                                     CourseNavigationPage(
                        //                               course: _courseDetails,
                        //                               identifier:
                        //                                   _currentCourse[
                        //                                       'contentId'],
                        //                               contentProgress:
                        //                                   _allContentProgress,
                        //                               navigation:
                        //                                   _navigationItems,
                        //                               moduleName:
                        //                                   _currentCourse[
                        //                                       'moduleName'],
                        //                               batchId: _batchId,
                        //                             )));
                        //                       },
                        //                       child: Stack(children: [
                        //                         SizedBox(
                        //                           width: double.infinity,
                        //                           child: SvgPicture.asset(
                        //                             'assets/img/login_header.svg',
                        //                             fit: BoxFit.cover,
                        //                             height: 75,

                        //                             // alignment: Alignment.topLeft,
                        //                           ),
                        //                         ),
                        //                         LinearProgressIndicator(
                        //                           minHeight: 4,
                        //                           backgroundColor:
                        //                               AppColors.grey16,
                        //                           valueColor:
                        //                               AlwaysStoppedAnimation<
                        //                                   Color>(
                        //                             AppColors.primaryThree,
                        //                           ),
                        //                           value: _currentCourse[
                        //                                           'currentProgress']
                        //                                       .runtimeType !=
                        //                                   String
                        //                               ? _currentCourse[
                        //                                   'currentProgress']
                        //                               : double.parse(
                        //                                   _currentCourse[
                        //                                       'currentProgress']),
                        //                         ),
                        //                         Container(
                        //                           height: 64,
                        //                           margin: EdgeInsets.only(
                        //                               top: 10.0),
                        //                           child: Row(
                        //                             children: [
                        //                               Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .only(left: 18),
                        //                                 child: SvgPicture.asset(
                        //                                   'assets/img/icons-av-play.svg',
                        //                                   color: AppColors
                        //                                       .primaryThree,
                        //                                   height: 22,
                        //                                 ),
                        //                                 // Icon(
                        //                                 //   Icons.play_circle_fill,
                        //                                 //   color: AppColors.primaryThree,
                        //                                 //   size: 22,
                        //                                 // ),
                        //                               ),
                        //                               Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .only(left: 16),
                        //                                 child: Column(
                        //                                     crossAxisAlignment:
                        //                                         CrossAxisAlignment
                        //                                             .start,
                        //                                     children: [
                        //                                       Container(
                        //                                         width: MediaQuery.of(
                        //                                                     context)
                        //                                                 .size
                        //                                                 .width -
                        //                                             56,
                        //                                         padding:
                        //                                             const EdgeInsets
                        //                                                     .only(
                        //                                                 top: 8),
                        //                                         child: Text(
                        //                                           _currentCourse[
                        //                                               'name'],
                        //                                           overflow:
                        //                                               TextOverflow
                        //                                                   .ellipsis,
                        //                                           style:
                        //                                               GoogleFonts
                        //                                                   .lato(
                        //                                             color: AppColors
                        //                                                 .greys87,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .w700,
                        //                                             fontSize:
                        //                                                 16,
                        //                                           ),
                        //                                         ),
                        //                                       ),
                        //                                       Container(
                        //                                         width: MediaQuery.of(
                        //                                                     context)
                        //                                                 .size
                        //                                                 .width -
                        //                                             56,
                        //                                         padding:
                        //                                             const EdgeInsets
                        //                                                     .only(
                        //                                                 top: 8),
                        //                                         child: Text(
                        //                                           '${_currentCourse['currentIndex']}/${_currentCourse['moduleItems']} ${_currentCourse['name']}',
                        //                                           overflow:
                        //                                               TextOverflow
                        //                                                   .ellipsis,
                        //                                           style:
                        //                                               GoogleFonts
                        //                                                   .lato(
                        //                                             color: AppColors
                        //                                                 .greys60,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .w700,
                        //                                             fontSize:
                        //                                                 14,
                        //                                           ),
                        //                                         ),
                        //                                       )
                        //                                     ]),
                        //                               )
                        //                             ],
                        //                           ),
                        //                         )
                        //                       ])))))
                        //     ]),
                        //   )
                        : (_courseDetails['primaryCategory'] !=
                                EnglishLang.program
                            ? Container(
                                height: 48,
                                color: Colors.white,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: TextButton(
                                  onPressed: () {
                                    // Navigator.of(context).pop(false);
                                    if (!widget.isFeaturedCourse) {
                                      _enrollCourse();
                                    }
                                    Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: CourseNavigationPage(
                                          course: _courseDetails,
                                          identifier: _navigationItems[0][0] ==
                                                  null
                                              ? _navigationItems[0]['contentId']
                                              : (_navigationItems[0][0][0] !=
                                                      null
                                                  ? _navigationItems[0][0][0]
                                                      ['contentId']
                                                  : _navigationItems[0][0]
                                                      ['contentId']),
                                          contentProgress: _allContentProgress,
                                          navigation: _navigationItems,
                                          moduleName:
                                              _navigationItems[0][0] == null
                                                  ? _navigationItems[0]
                                                      ['moduleName']
                                                  : _navigationItems[0][0][0] !=
                                                          null
                                                      ? _navigationItems[0][0]
                                                          [0]['moduleName']
                                                      : _navigationItems[0][0]
                                                          ['moduleName'],
                                          batchId: _batchId,
                                          parentAction: _updateData,
                                          isFeatured: widget.isFeaturedCourse,
                                          courseProgress: _courseProgress,
                                          updateCourseProgress:
                                              _getCourseProgress,
                                        )));
                                  },
                                  style: TextButton.styleFrom(
                                    // primary: Colors.white,
                                    backgroundColor: AppColors.customBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                            color: AppColors.grey16)),
                                    // onSurface: Colors.grey,
                                  ),
                                  child: Text(
                                    widget.isFeaturedCourse
                                        ? EnglishLang.view
                                        : EnglishLang.start,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                color: AppColors.grey04,
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'You are not invited for this Program.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                )))
                    : Container(
                        height: 0,
                        child: Center(),
                      );
              } else {
                return PageLoader();
              }
            }));
  }
}
