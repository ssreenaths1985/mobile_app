import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
// import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'dart:convert';
import 'dart:async';
import './../../constants/index.dart';
import './../../util/helper.dart';
// import 'dart:developer' as developer;

class LearnService {
  final String coursesUrl = ApiUrl.baseUrl + ApiUrl.getTrendingCourses;
  final String continueLearningUrl =
      ApiUrl.baseUrl + ApiUrl.getContinueLearningCourses;
  final String courseDetailsUrl = ApiUrl.baseUrl + ApiUrl.getCourseDetails;
  final String courseLearnersUrl = ApiUrl.baseUrl + ApiUrl.getCourseLearners;
  final String courseAuthorsUrl = ApiUrl.baseUrl + ApiUrl.getCourseAuthors;
  final String setPdfCookieUrl = ApiUrl.baseUrl + ApiUrl.setPdfCookie;
  final String getAllTopics = ApiUrl.baseUrl + ApiUrl.getAllTopics;
  final String courseProgressUrl = ApiUrl.baseUrl + ApiUrl.getCourseProgress;
  final String updateContentProgressUrl =
      ApiUrl.baseUrl + ApiUrl.updateContentProgress;
  final String readContentProgressUrl =
      ApiUrl.baseUrl + ApiUrl.readContentProgress;
  final String getBatchListUrl = ApiUrl.baseUrl + ApiUrl.getBatchList;
  final String autoEnrollBatchUrl = ApiUrl.baseUrl + ApiUrl.autoEnrollBatch;
  final String getEnrollDetailsUrl = ApiUrl.baseUrl + ApiUrl.getEnrollDetails;
  final String getListOfCompetenciesUrl =
      ApiUrl.fracBaseUrl + ApiUrl.getListOfCompetencies;
  final String getAllCompetenciesUrl =
      ApiUrl.baseUrl + ApiUrl.getAllCompetencies;
  final String getCoursesByCompetenciesURL =
      ApiUrl.baseUrl + ApiUrl.getTrendingCourses;
  final String getListOfProvidersUrl =
      ApiUrl.baseUrl + ApiUrl.getListOfProviders;
  final String getAllProvidersUrl = ApiUrl.baseUrl + ApiUrl.getAllProviders;
  final _storage = FlutterSecureStorage();

  Future<dynamic> getListOfCompetencies() async {
    String token = await _storage.read(key: Storage.authToken);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ${ApiUrl.apiKey}',
      'x-authenticated-user-token': '$token',
    };

    Response response =
        await get(Uri.parse(getAllCompetenciesUrl), headers: headers);

    return response;
  }

  Future<dynamic> getListOfProviders() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(Uri.parse(getAllProvidersUrl),
        headers: Helper.postHeaders(token, wid));
    return response;
  }

  Future<dynamic> getCourses(int pageNo, String searchText,
      List primaryCategory, List mimeType, List source,
      {bool isCollection = false,
      bool hasRequestBody = false,
      Map requestBody}) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data;
    if (isCollection) {
      final response = await getCuratedHomeConfig();
      data = response['search']['searchReq'];
    } else if (hasRequestBody) {
      data = requestBody;
    } else {
      data = {
        'request': {
          'filters': {
            'contentType': [],
            'primaryCategory': primaryCategory,
            // 'mimeType': mimeType,
            'source': source,
          },
          'sort_by': {'lastUpdatedOn': 'desc'},
          'fields': [],
          'status': ['Live'],
          'query': searchText,
        },
        // 'limit': 100
        // 'offset': 0
      };
    }

    var body = json.encode(data);
    Response response = await post(Uri.parse(coursesUrl),
        headers: Helper.postHeaders(token, wid), body: body);

    return response;
  }

  Future<dynamic> getInterestedCourses(selectedTopics) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      'request': {
        'filters': {
          'contentType': [],
          'mediaType': [],
          'primaryCategory': ["Course"],
          'mimeType': [],
          'source': [],
          'status': ['Live'],
          'topics': selectedTopics
        },
        'facets': [
          "primaryCategory",
          "mimeType",
          "source",
          "competencies_v3.name",
          "topics"
        ],
        'sort_by': {'lastUpdatedOn': 'desc'},
        'fields': [],
        'limit': 100,
        'offset': 0,
        'query': '',
      },
    };
    var body = json.encode(data);
    Response response = await post(Uri.parse(coursesUrl),
        headers: Helper.postHeaders(token, wid), body: body);

    return response;
  }

  Future<dynamic> getRecommendedCourses(List addedCompetencies) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    List<dynamic> masterCompetencies = await getMasterCompetenciesJson();

    List recommendedCompetencies =
        masterCompetencies.map((e) => e['name']).toList();

    var set1 = Set.from(recommendedCompetencies);
    var set2 = Set.from(addedCompetencies);

    Map data = {
      "request": {
        "filters": {
          "primaryCategory": ["Course"],
          "contentType": ["Course"],
          "competencies_v3.name": List.from(set1.difference(set2))
        },
        "offset": 0,
        "limit": 10,
        "query": "",
        "sort_by": {"lastUpdatedOn": "desc"},
        "fields": [
          "name",
          "appIcon",
          "instructions",
          "description",
          "purpose",
          "mimeType",
          "gradeLevel",
          "identifier",
          "medium",
          "pkgVersion",
          "board",
          "subject",
          "resourceType",
          "primaryCategory",
          "contentType",
          "channel",
          "organisation",
          "trackable",
          "license",
          "posterImage",
          "idealScreenSize",
          "learningMode",
          "creatorLogo",
          "duration",
          "version"
        ]
      },
      "query": ""
    };
    var body = json.encode(data);
    // developer.log(body);
    Response response = await post(Uri.parse(coursesUrl),
        headers: Helper.postHeaders(token, wid), body: body);

    return response;
  }

  Future<dynamic> getCoursesByTopic(String identifier) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "request": {
        "query": "",
        "filters": {
          "status": ["Live"],
          "contentType": ["Collection", "Course", "Learning Path"],
          "topics": identifier
        },
        "sort_by": {"lastUpdatedOn": "desc"},
        "facets": ["primaryCategory", "mimeType"]
      },

      // 'limit': 100
      // 'offset': 0
    };
    var body = json.encode(data);

    Response response = await post(Uri.parse(coursesUrl),
        headers: Helper.postHeaders(token, wid), body: body);

    return response;
  }

  Future<dynamic> getCoursesByCollection(String identifier) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    String coursesByCollectionUrl =
        courseDetailsUrl + identifier + '?mode=minimal';

    Response response = await get(Uri.parse(coursesByCollectionUrl),
        headers: Helper.getHeaders(token, wid));

    // print(response.body);

    return response;
  }

  Future<dynamic> getCoursesByCompetencies(String competencyName,
      List<String> selectedTypes, List<String> selectedProviders) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "request": {
        "query": "",
        "filters": {
          "primaryCategory": selectedTypes,
          "status": ["Live"],
          "competencies_v3.name": [competencyName],
          "source": selectedProviders,
        },
        "sort_by": {"name": "Asc"},
        // "facets": [],
        // "fields": [
        //   "competencies_v3.name",
        //   "competencies_v3.competencyType",
        //   "taxonomyPaths_v2.name"
        // ]
        "limit": 100,
        // "offset": 0
      }
    };
    var body = json.encode(data);

    Response response = await post(Uri.parse(getCoursesByCompetenciesURL),
        headers: Helper.postHeaders(token, wid), body: body);
    // print('Course test in service: ' + response.body.toString());
    // print(getCoursesByCompetenciesURL);
    // print(body);
    return response;
  }

  Future<dynamic> getCoursesByProvider(String providerName) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "request": {
        "filters": {
          "contentType": ["Course"],
          "primaryCategory": [],
          "mimeType": [],
          "source": providerName,
          "mediaType": [],
          "status": ["Live"]
        },
        "query": "",
        "sort_by": {"lastUpdatedOn": ""},
        // "limit": 2,
        "offset": 0,
        "fields": [],
        "facets": ["contentType", "mimeType", "source"]
      }
    };
    var body = json.encode(data);

    Response response = await post(Uri.parse(getCoursesByCompetenciesURL),
        headers: Helper.postHeaders(token, wid), body: body);
    // print(res.body);
    return response;
  }

  Future<dynamic> getContinueLearningCourses() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    // Map data = {'pageSize': 12, 'sourceFields': 'creatorLogo'};
    // var body = json.encode(data);

    Response response = await get(
        Uri.parse(continueLearningUrl.replaceAll(':wid', wid)),
        headers: Helper.getHeaders(token, wid));
    return response;
  }

  Future<int> getTotalCoursePages() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      'request': {
        'filters': {
          'primaryCategory': ['Course'],
          'contentType': ['Course']
        },
        'query': '',
        'sort_by': {'lastUpdatedOn': 'desc'},
        'fields': [
          'name',
          'appIcon',
          'instructions',
          'description',
          'purpose',
          'mimeType',
          'gradeLevel',
          'identifier',
          'medium',
          'pkgVersion',
          'board',
          'subject',
          'resourceType',
          'primaryCategory',
          'contentType',
          'channel',
          'organisation',
          'trackable',
          'license',
          'posterImage',
          'idealScreenSize',
          'learningMode',
          'creatorLogo',
          'duration'
        ]
      },
      'query': ''
    };
    var body = json.encode(data);

    Response res = await post(Uri.parse(coursesUrl),
        headers: Helper.postHeaders(token, wid), body: body);

    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      // int count = (contents['filters'][0]['content'][0]['count'] / 10).ceil();
      int count = (contents['result']['count'] / 10).ceil();
      return count;
    } else {
      throw 'Can\'t get courses.';
    }
  }

  Future<dynamic> getCourseDetails(id, {bool isFeatured = false}) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    Response res = isFeatured
        ? await get(
            Uri.parse(courseDetailsUrl + id + '?hierarchyType=detail'),
          )
        : await get(Uri.parse(courseDetailsUrl + id + '?hierarchyType=detail'),
            headers: Helper.getHeaders(token, wid));
    // print('URL: ' + courseDetailsUrl + id + '?hierarchyType=detail');
    if (res.statusCode == 200) {
      var courseDetails = jsonDecode(res.body);
      // print('Response: ' + courseDetails['result']['content'].toString());
      return courseDetails['result']['content'];
    } else {
      return res.reasonPhrase;
    }
  }

  Future<dynamic> getCourseLearners(courseId) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(Uri.parse(courseLearnersUrl),
        headers: Helper.getCourseHeaders(token, wid, courseId));
    // developer.log(courseLearnersUrl + ": " + res.body);
    // developer.log(Helper.getCourseHeaders(token, wid, courseId).toString());
    return response;
  }

  Future<dynamic> getCourseAuthors(courseId) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(Uri.parse(courseAuthorsUrl),
        headers: Helper.getCourseHeaders(token, wid, courseId));
    // developer.log(courseAuthorsUrl + ": " + res.body);
    // developer.log(Helper.getCourseHeaders(token, wid, courseId).toString());
    return response;
  }

  Future<dynamic> setPdfCookie(identifer) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    Map data = {'contentId': identifer};
    var body = json.encode(data);
    // print('setPdfCookie: $identifer');
    Response res = await post(Uri.parse(setPdfCookieUrl),
        headers: Helper.postHeaders(token, wid), body: body);
    // print(res.body);
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      return response;
    } else {
      throw 'Can\'t set cookie.';
    }
  }

  Future<dynamic> getCourseTopics() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(Uri.parse(getAllTopics),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());
    return response;
  }

  Future<dynamic> getCourseProgress(courseId, batchId) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      'request': {
        'batchId': batchId,
        'userId': wid,
        'courseId': courseId,
        'contentIds': [],
        'fields': ['progressdetails']
      }
    };
    var body = json.encode(data);
    Response response = await post(Uri.parse(courseProgressUrl + courseId),
        headers: Helper.postHeaders(token, wid), body: body);
    return response;
  }

  Future<Map> updateContentProgress(
      String courseId,
      String batchId,
      String contentId,
      int status,
      String contentType,
      List current,
      var maxSize,
      double completionPercentage,
      {bool isAssessment = false}) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    List dateTime = DateTime.now().toUtc().toString().split('.');

    Map data;

    if (isAssessment) {
      data = {
        "request": {
          "userId": wid,
          "contents": [
            {
              "contentId": contentId,
              "batchId": batchId,
              "status": status,
              "courseId": courseId,
              "lastAccessTime": '${dateTime[0]}:00+0000',
              // "lastCompletedTime": '${dateTime[0]}:00+0000',
            }
          ]
        }
      };
    } else {
      data = {
        "request": {
          "userId": wid,
          "contents": [
            {
              "contentId": contentId,
              "batchId": batchId,
              "status": status,
              "courseId": courseId,
              "lastAccessTime": '${dateTime[0]}:00+0000',
              // "lastCompletedTime": '${dateTime[0]}:00+0000',
              "progressdetails": {
                "max_size": maxSize,
                "current": current,
                "mimeType": contentType
              },
              "completionPercentage": completionPercentage
            }
          ]
        }
      };
    }

    var body = json.encode(data);
    // log(body.toString());
    Response res = await patch(Uri.parse(updateContentProgressUrl),
        headers: Helper.postHeaders(token, wid), body: body);
    // print(res.body);
    if (res.statusCode == 200) {
      // var contents = jsonDecode(res.body);
      var contents = jsonDecode(res.body);
      return contents;
    } else {
      throw 'Can\'t update content progress';
    }
  }

  Future<Map> readContentProgress(
    String courseId,
    String batchId,
  ) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    Map data = {
      "request": {
        "batchId": batchId,
        "userId": wid,
        "courseId": courseId,
        "contentIds": [],
        "fields": ["progressdetails"]
      }
    };
    var body = jsonEncode(data);
    // print(data.toString());
    Response res = await post(Uri.parse(readContentProgressUrl),
        headers: Helper.postHeaders(token, wid), body: body);
    // developer.log('readContentProgress:' + res.body.toString());
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents;
    } else {
      throw 'Unable to fetch content progress';
    }
  }

  Future<dynamic> getBatchList(
    String courseId,
  ) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    Map data = {
      'request': {
        'filters': {
          'courseId': courseId,
          "status": ['0', '1', '2']
        },
        'sort_by': {'createdDate': 'desc'}
      }
    };
    var body = jsonEncode(data);
    Response response = await post(Uri.parse(getBatchListUrl),
        headers: Helper.postHeaders(token, wid), body: body);
    // print(res.body);
    return response;
  }

  Future<dynamic> autoEnrollBatch(
    String courseId,
  ) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response res = await get(Uri.parse(autoEnrollBatchUrl),
        headers: Helper.postCourseHeaders(token, wid, courseId));
    // print('auto_enroll: ' + res.body.toString());
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents['result']['response']['content'][0];
    } else {
      throw 'Unable to auto enroll a batch';
    }
  }

  // Assessment functions

  Future<dynamic> getAssessmentData(
    String fileUrl,
  ) async {
    Response res =
        await get(Uri.parse(Helper.convertToPortalUrl(fileUrl)), headers: {});
    // print(res.body);
    if (res.statusCode == 200) {
      var data = utf8.decode(res.bodyBytes);
      var contents = jsonDecode(data);
      // print(contents);
      return contents;
    } else {
      throw 'Unable to assessment data.';
    }
  }

  Future<dynamic> submitAssessment(Map data) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    var body = json.encode(data);
    Response res = await post(Uri.parse(ApiUrl.baseUrl + ApiUrl.saveAssessment),
        headers: Helper.postHeaders(token, wid), body: body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      var contents = jsonDecode(res.body);
      return contents;
    } else {
      throw 'Can\'t submit survey data';
    }
  }

  Future<dynamic> getCompletionCertificateId(String batchId) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "request": {
        "batchList": [
          {
            "batchId": "$batchId",
            "userList": ["$wid"]
          }
        ]
      }
    };

    var body = json.encode(data);
    Response res = await post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getUserProgress),
        headers: Helper.postHeaders(token, wid),
        body: body);
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents['result'][0]['issuedCertificates'].length > 0
          ? (contents['result'][0]['issuedCertificates'].length > 1
              ? contents['result'][0]['issuedCertificates'][1]['identifier']
              : contents['result'][0]['issuedCertificates'][0]['identifier'])
          : null;
    } else {
      throw 'Can\'t get the issued certificate';
    }
  }

  Future<dynamic> getCourseCompletionCertificate(String id) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response res = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getCourseCompletionCertificate + id),
        headers: Helper.discussionGetHeaders(token, wid));

    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents['result']['printUri'];
    } else {
      throw 'Can\'t get certificates';
    }
  }

  Future<dynamic> getYourReview(String id, String primaryCategory) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response res = await get(
        Uri.parse(ApiUrl.baseUrl +
            ApiUrl.getYourRating +
            '$id/$primaryCategory/$wid'),
        headers: Helper.getHeaders(token, wid));
    // print(res.body.toString());

    var contents = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return contents['result']['response'];
    } else {
      print(contents['params'] != null
          ? contents['params']['errmsg']
          : contents.toString());
      return null;
    }
  }

  Future<dynamic> postCourseReview(String courseId, String primaryCategory,
      double rating, String comment) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data;
    if (comment.trim().length > 0) {
      data = {
        "activityId": "$courseId",
        "userId": "$wid",
        "activityType": "$primaryCategory",
        "rating": rating.toInt(),
        "review": "$comment"
      };
    } else {
      data = {
        "activityId": "$courseId",
        "userId": "$wid",
        "activityType": "$primaryCategory",
        "rating": rating.toInt(),
      };
    }

    var body = json.encode(data);
    // print(body);
    Response response = await post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.postReview),
        headers: Helper.postHeaders(token, wid),
        body: body);
    return response;
  }

  Future<dynamic> getCourseReviewSummery(
      String id, String primaryCategory) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response res = await get(
        Uri.parse(ApiUrl.baseUrl +
            ApiUrl.getCourseReviewSummery +
            '$id/$primaryCategory'),
        headers: Helper.getHeaders(token, wid));

    // developer.log(res.body);
    var contents = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return contents['result']['response'];
    } else {
      print(contents['params']['errmsg']);
      return null;
    }
  }

  Future<dynamic> getCourseReview(
      String courseId, String primaryCategory) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "activityId": "$courseId",
      "activityType": "$primaryCategory",
      "limit": 3,
      "updateOn": ""
    };

    var body = json.encode(data);
    // print(body);
    Response res = await post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getCourseReview),
        headers: Helper.postHeaders(token, wid),
        body: body);
    // developer.log(res.body);
    var contents = jsonDecode(res.body);
    // developer.log(contents.toString());
    if (res.statusCode == 200) {
      return contents['result']['response'];
    } else {
      return null;
    }
  }

  Future<dynamic> getCourseReviewReply(
      String id, String primaryCategory, String userId) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response res = await get(
        Uri.parse(ApiUrl.baseUrl +
            ApiUrl.getYourRating +
            '$id/$primaryCategory/$userId'),
        headers: Helper.getHeaders(token, wid));

    // print(ApiUrl.baseUrl + ApiUrl.getYourRating + '$id/$userId');

    // developer.log(res.body.toString());
    var contents = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return contents['result']['response'];
    } else {
      print(contents['params']['errmsg']);
      return null;
    }
  }

  Future<dynamic> getCuratedHomeConfig() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getCuratedHomeConfig),
        headers: Helper.getHeaders(token, wid));

    return jsonDecode(response.body);
  }

  Future<dynamic> getLearnHubConfig() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getLearnHubConfig),
        headers: Helper.getHeaders(token, wid));

    return jsonDecode(response.body);
  }

  Future<dynamic> getHomeConfig() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getHomeConfig),
        headers: Helper.getHeaders(token, wid));

    return jsonDecode(response.body);
  }

  Future<dynamic> getMasterCompetenciesJson() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getMasterCompetencies),
        headers: Helper.getHeaders(token, wid));

    return jsonDecode(response.body);
  }
}
