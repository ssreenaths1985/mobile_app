import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/_models/learn_config_model.dart';
import 'package:karmayogi_mobile/models/_models/course_config_model.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/services/_services/learn_service.dart';
// import 'dart:developer' as developer;

class LearnRepository with ChangeNotifier {
  final LearnService learnService = LearnService();
  List<BrowseCompetencyCardModel> browseCompetencyCard = [];
  List<ProviderCardModel> providerCardModel = [];
  List<Course> courses = [];
  String _errorMessage = '';
  Response _data;

  Future<List<BrowseCompetencyCardModel>> getListOfCompetencies(context) async {
    try {
      final response = await learnService.getListOfCompetencies();
      _data = response;
    } catch (_) {
      return _;
    }

    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents;
      List<BrowseCompetencyCardModel> browseCompetencyCard = body
          .map(
            (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
          )
          .toList();
      return browseCompetencyCard;
    } else {
      _errorMessage = _data.statusCode.toString();
      // return Helper.showErrorPopup(context, _data.body);
    }
  }

  Future<List<ProviderCardModel>> getListOfProviders() async {
    try {
      final response = await learnService.getListOfProviders();
      _data = response;
    } catch (_) {
      return _;
    }

    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents;
      providerCardModel = body
          .map(
            (dynamic item) => ProviderCardModel.fromJson(item),
          )
          .toList();
      return providerCardModel;
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getCourses(int pageNo, String searchText,
      List primaryCategory, List mimeType, List source,
      {bool isCollection = false,
      bool hasRequestBody = false,
      Map requestBody}) async {
    try {
      final response = await learnService.getCourses(
          pageNo, searchText, primaryCategory, mimeType, source,
          isCollection: isCollection,
          hasRequestBody: hasRequestBody,
          requestBody: requestBody);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);

      List<dynamic> body = contents['result']['content'] != null
          ? contents['result']['content']
          : [];
      courses = body
          .map(
            (dynamic item) => Course.fromJson(item),
          )
          .toList();
      return courses;
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getInterestedCourses(selectedTopics) async {
    try {
      final response = await learnService.getInterestedCourses(selectedTopics);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);

      List<dynamic> body = contents['result']['content'] != null
          ? contents['result']['content']
          : [];
      courses = body
          .map(
            (dynamic item) => Course.fromJson(item),
          )
          .toList();
      return courses;
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getRecommendedCourses(competencies) async {
    try {
      final response = await learnService.getRecommendedCourses(competencies);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);

      List<dynamic> body = contents['result']['content'];
      if (contents['result']['content'] != null) {
        courses = body
            .map(
              (dynamic item) => Course.fromJson(item),
            )
            .toList();
      }
      return courses;
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getCoursesByTopic(String identifier) async {
    try {
      final response = await learnService.getCoursesByTopic(identifier);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body =
          contents['result']['count'] > 0 ? contents['result']['content'] : [];

      if (body.length > 0) {
        courses = body
            .map(
              (dynamic item) => Course.fromJson(item),
            )
            .toList();
      }
      return courses;
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getCoursesByCollection(String identifier) async {
    try {
      final response = await learnService.getCoursesByCollection(identifier);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = ((contents['result']['content'] != null &&
                  contents['result']['content']['children'] != null) &&
              contents['result']['content']['children'].length > 0)
          ? contents['result']['content']['children']
          : [];
      if (body.length > 0) {
        courses = body
            .map(
              (dynamic item) => Course.fromJson(item),
            )
            .toList();
      }
      return courses;
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getCoursesByCompetencies(
      competencyName, selectedTypes, selectedProviders) async {
    try {
      final response = await learnService.getCoursesByCompetencies(
          competencyName, selectedTypes, selectedProviders);
      _data = response;
    } catch (_) {
      return _;
    }

    if (_data.statusCode == 200) {
      courses = [];
      var contents = jsonDecode(_data.body);
      List<dynamic> body =
          contents['result']['count'] > 0 ? contents['result']['content'] : [];
      if (body.length > 0) {
        courses = body
            .map(
              (dynamic item) => Course.fromJson(item),
            )
            .toList();
      }
      // print('Course test: ' + courses.toString());
      return courses;
    } else {
      // throw 'Can\'t get courses by competencies!';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getCoursesByProvider(String providerName) async {
    try {
      final response = await learnService.getCoursesByProvider(providerName);
      _data = response;
    } catch (_) {
      return _;
    }

    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body =
          contents['result']['count'] > 0 ? contents['result']['content'] : [];
      if (body.length > 0) {
        courses = body
            .map(
              (dynamic item) => Course.fromJson(item),
            )
            .toList();
      }
      return courses;
    } else {
      // throw 'Can\'t get courses by competencies!';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getContinueLearningCourses() async {
    List<Course> coursesList;
    try {
      final response = await learnService.getContinueLearningCourses();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var data = utf8.decode(_data.bodyBytes);
      var contents = jsonDecode(data);
      List<dynamic> body = contents['result']['courses'];
      coursesList = body
          .map(
            (dynamic item) => Course.fromJson(item),
          )
          .toList();
      return coursesList;
    } else {
      // throw 'Can\'t get courses.';
      _errorMessage = _data.statusCode.toString();
      // print('object $_data');
      // throw _errorMessage;
    }
    return coursesList;
  }

  Future<List<CourseLearner>> getCourseLearners(courseId) async {
    try {
      final response = await learnService.getCourseLearners(courseId);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      List<dynamic> contents = jsonDecode(_data.body);
      List<CourseLearner> learners = contents
          .map(
            (dynamic item) => CourseLearner.fromJson(item),
          )
          .toList();

      return learners;
    } else {
      // throw 'Can\'t get courses learners.';
      _errorMessage = _data.statusCode.toString();
      // print(_errorMessage);
    }
  }

  Future<List<CourseAuthor>> getCourseAuthors(courseId) async {
    try {
      final response = await learnService.getCourseAuthors(courseId);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      List<dynamic> contents = jsonDecode(_data.body);
      List<CourseAuthor> authors = contents
          .map(
            (dynamic item) => CourseAuthor.fromJson(item),
          )
          .toList();
      // print('Authours service ' + contents.toString());
      return authors;
    } else {
      // throw 'Can\'t get courses authors.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<CourseTopics>> getCourseTopics() async {
    try {
      final response = await learnService.getCourseTopics();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> courseTopic = contents['terms'];
      List<CourseTopics> topics = courseTopic
          .map(
            (dynamic item) => CourseTopics.fromJson(item),
          )
          .toList();
      // print('Learners service ' + learners.toString());

      return topics;
    } else {
      // throw 'Can\'t get courses topics';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<double> getCourseProgress(courseId, batchId) async {
    try {
      final response = await learnService.getCourseProgress(courseId, batchId);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      var tempProgress =
          contents['result']['contentList'][0]['completionPercentage'];
      double progress = tempProgress != null ? tempProgress / 100 : 0.0;

      return progress;
    } else {
      // throw 'Can\'t get course progress';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Batch>> getBatchList(courseId) async {
    try {
      final response = await learnService.getBatchList(courseId);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> batches = contents['result']['response']['content'];
      List<Batch> courseBatches = batches
          .map(
            (dynamic item) => Batch.fromJson(item),
          )
          .toList();
      return courseBatches;
    } else {
      // throw 'Unable to get batch list';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Course>> getMandatoryCourses() async {
    try {
      final response = await learnService.getContinueLearningCourses();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var data = utf8.decode(_data.bodyBytes);
      var contents = jsonDecode(data);
      List<dynamic> body = contents['result']['courses'];
      List<Course> courses = body
          .map(
            (dynamic item) => Course.fromJson(item),
          )
          .toList();
      // print(courses.last.raw['content']['primaryCategory'].toString());
      List<Course> mandatoryCourse = courses
          .where(
              (course) => course.contentType == EnglishLang.mandatoryCourseGoal)
          .toList();

      return mandatoryCourse;
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<dynamic> getLearnToolTipInfo() async {
    try {
      final response = await learnService.getLearnHubConfig();
      CourseConfig continueLearningInfo;
      CourseConfig mandatoryCoursesInfo;
      CourseConfig recommendedCoursesInfo;
      CourseConfig newlyAddedCoursesConfig;
      CourseConfig programsConfig;
      CourseConfig basedOnInterestInfo;
      LearnConfig learnToolTipInfo;
      List<dynamic> content = response['pageLayout']['widgetData']['widgets'];
      if (content.length > 0) {
        for (var i = 0; i < content.length; i++) {
          if ((content[i][0]['widget']['widgetData'] != null &&
                  content[i][0]['widget']['widgetData'].runtimeType != List) &&
              content[i][0]['widget']['widgetData']['strips'] != null &&
              (content[i][0]['widget']['widgetData']['strips'][0] != null &&
                  content[i][0]['widget']['widgetData']['strips'][0]['key'] !=
                      null)) {
            switch (content[i][0]['widget']['widgetData']['strips'][0]['key']) {
              case 'continueLearning':
                continueLearningInfo = CourseConfig.fromJson({
                  "title": content[i][0]['widget']['widgetData']['strips'][0]
                      ['title'],
                  "description": content[i][0]['widget']['widgetData']['strips']
                      [0]['titleDescription']
                });
                break;
              case 'mandatoryCourses':
                if (content[i][0]['widget']['widgetData']['strips'][0]
                        ['info'] !=
                    null) {
                  mandatoryCoursesInfo = CourseConfig.fromJson({
                    "title": content[i][0]['widget']['widgetData']['strips'][0]
                        ['title'],
                    "description": content[i][0]['widget']['widgetData']
                        ['strips'][0]['info']['widget']['widgetData']['html']
                  });
                }
                break;
              case 'recommendedCourses':
                if (content[i][0]['widget']['widgetData']['strips'][0]
                        ['info'] !=
                    null) {
                  recommendedCoursesInfo = CourseConfig.fromJson({
                    "title": content[i][0]['widget']['widgetData']['strips'][0]
                        ['title'],
                    "description": content[i][0]['widget']['widgetData']
                        ['strips'][0]['info']['widget']['widgetData']['html']
                  });
                }
                break;
              case 'basedOnInterest':
                if (content[i][0]['widget']['widgetData']['strips'][0]
                        ['info'] !=
                    null) {
                  basedOnInterestInfo = CourseConfig.fromJson({
                    "title": content[i][0]['widget']['widgetData']['strips'][0]
                        ['title'],
                    "description": content[i][0]['widget']['widgetData']
                        ['strips'][0]['info']['widget']['widgetData']['html']
                  });
                }
                break;
              case 'latest':
                if (content[i][0]['widget']['widgetData']['strips'][0]
                        ['info'] !=
                    null) {
                  CourseConfig data = CourseConfig.fromJson({
                    "title": content[i][0]['widget']['widgetData']['strips'][0]
                        ['title'],
                    "description": content[i][0]['widget']['widgetData']
                        ['strips'][0]['info']['widget']['widgetData']['html'],
                    "request": content[i][0]['widget']['widgetData']['strips']
                        [0]['request']['searchV6']
                  });
                  if (content[i][0]['widget']['widgetData']['strips'][0]
                          ['title'] ==
                      EnglishLang.programs.toString()) {
                    programsConfig = data;
                  } else {
                    newlyAddedCoursesConfig = data;
                  }
                }
                break;

              default:
                break;
            }
          }
        }
        learnToolTipInfo = LearnConfig.fromJson({
          'continueLearning': continueLearningInfo,
          'mandatoryCourse': mandatoryCoursesInfo,
          'recommendedCourse': recommendedCoursesInfo,
          'basedOnInterest': basedOnInterestInfo,
          'latestCourses': newlyAddedCoursesConfig,
          'programs': programsConfig
        });
        return learnToolTipInfo;
      }
    } catch (_) {
      return _;
    }
  }

  Future<dynamic> getHomeCoursesConfig() async {
    try {
      final response = await learnService.getHomeConfig();
      dynamic newlyAddedCoursesConfig;
      dynamic curatedCollectionConfig;
      LearnConfig learnToolTipInfo;
      List<dynamic> content = response['pageLayout']['widgetData']['widgets'];
      if (content.length > 0) {
        for (var i = 0; i < content.length; i++) {
          if ((content[i][0]['widget']['widgetData'] != null &&
                  content[i][0]['widget']['widgetData'].runtimeType != List) &&
              content[i][0]['widget']['widgetData']['strips'] != null &&
              (content[i][0]['widget']['widgetData']['strips'][0] != null &&
                  content[i][0]['widget']['widgetData']['strips'][0]['key'] !=
                      null)) {
            switch (content[i][0]['widget']['widgetData']['strips'][0]['key']) {
              case 'latest':
                if (content[i][0]['widget']['widgetData']['strips'][0]
                        ['info'] !=
                    null) {
                  newlyAddedCoursesConfig = CourseConfig.fromJson({
                    "title": content[i][0]['widget']['widgetData']['strips'][0]
                        ['title'],
                    "description": content[i][0]['widget']['widgetData']
                        ['strips'][0]['info']['widget']['widgetData']['html'],
                    "request": content[i][0]['widget']['widgetData']['strips']
                        [0]['request']['searchV6']
                  });
                }
                break;

              case 'curatedCollections':
                if (content[i][0]['widget']['widgetData']['strips'][0]
                        ['info'] !=
                    null) {
                  curatedCollectionConfig = CourseConfig.fromJson({
                    "title": content[i][0]['widget']['widgetData']['strips'][0]
                        ['title'],
                    "description": content[i][0]['widget']['widgetData']
                        ['strips'][0]['info']['widget']['widgetData']['html'],
                    "request": content[i][0]['widget']['widgetData']['strips']
                        [0]['request']['curatedCollections']
                  });
                }
                break;
              default:
                break;
            }
          }
        }
        learnToolTipInfo = LearnConfig.fromJson({
          'latestCourses': newlyAddedCoursesConfig,
          'curatedCollections': curatedCollectionConfig
        });
        return learnToolTipInfo;
      }
    } catch (_) {
      return _;
    }
  }
}
