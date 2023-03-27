import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import './../../models/index.dart';
import './../../constants/index.dart';

class CurrentCourseService {
  final String coursesUrl = ApiUrl.baseUrl + ApiUrl.getCurrentCourse;

  Future<Course> getCurrentCourse() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'bearer ' + '$token',
      HttpHeaders.acceptHeader: '*/*',
      'hostpath': ApiUrl.baseUrl,
      'org': 'dopt',
      'rootorg': 'igot',
      'wid': '$wid',
    };

    Map data = {
      'additionalFields': [
        'averageRating',
        'body',
        'creatorContacts',
        'creatorDetails',
        'curatedTags',
        'contentType',
        'collections',
        'hasTranslations',
        'expiryDate',
        'exclusiveContent',
        'introductoryVideo',
        'introductoryVideoIcon',
        'isInIntranet',
        'isTranslationOf',
        'keywords',
        'learningMode',
        'license',
        'playgroundResources',
        'price',
        'registrationInstructions',
        'region',
        'registrationUrl',
        'resourceType',
        'subTitle',
        'softwareRequirements',
        'studyMaterials',
        'systemRequirements',
        'totalRating',
        'uniqueLearners',
        'viewCount',
        'labels',
        'sourceUrl',
        'sourceName',
        'sourceShortName',
        'sourceIconUrl',
        'locale',
        'hasAssessment',
        'preContents',
        'postContents',
        'kArtifacts',
        'equivalentCertifications',
        'certificationList',
        'posterImage'
      ]
    };
    var body = json.encode(data);
    Response res =
        await post(Uri.parse(coursesUrl), headers: headers, body: body);
    // print(res.body.toString());
    if (res.statusCode == 200) {
      // var contents = jsonDecode(res.body);
      var body = jsonDecode(res.body);
      // print(body.toString());
      Course course = Course.fromJson(body);
      // print(course.toString());
      return course;
    } else {
      throw 'Can\'t get courses.';
    }
  }
}
