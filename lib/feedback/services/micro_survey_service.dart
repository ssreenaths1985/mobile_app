import 'dart:io';
import 'package:http/http.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';
import '../../constants/_constants/api_endpoints.dart';
import './../models/micro_survey_model.dart';
import './../constants.dart';
import 'dart:developer' as developer;

class MicroSurveyService {
  final String surveyDetailsUrl =
      FeedbackApiEndpoint.baseUrl + FeedbackApiEndpoint.getSurveyDetails;
  final String saveSurveyUrl =
      FeedbackApiEndpoint.baseUrl + FeedbackApiEndpoint.submitSurvey;
  final String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0YXJlbnRvYWRtaW5AdGFyZW50by5jb20iLCJzY29wZXMiOlt7ImF1dGhvcml0eSI6IlJPTEVfQURNSU4ifV0sImlzcyI6Imh0dHA6Ly9kZXZnbGFuLmNvbSIsImlhdCI6MTYyMzI0MDEzMiwiZXhwIjoxNjI1ODMyMTMyfQ.qsECzM9fsBp6d4M2grQm2LlGJxwlVoCxuNI4CK-SFog';
  // final _storage = FlutterSecureStorage();

  Future<dynamic> getMicroSurveyDetails(String id,
      {bool isContentFeedback = false}) async {
    // String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: Storage.wid);

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader:
          isContentFeedback ? 'bearer ${ApiUrl.apiKey}' : 'Bearer $token',
      HttpHeaders.acceptHeader: '*/*',
      'content-type': 'application/json; charset=utf-8',
      'hostpath':
          isContentFeedback ? ApiUrl.baseUrl : FeedbackApiEndpoint.baseUrl,
    };

    Response res = await get(
        Uri.parse((isContentFeedback
                ? (ApiUrl.baseUrl + FeedbackApiEndpoint.getSurveyDetails)
                : surveyDetailsUrl) +
            id),
        headers: headers);

    // print('URL: ' +
    //     ((isContentFeedback
    //             ? (ApiUrl.baseUrl + FeedbackApiEndpoint.getSurveyDetails)
    //             : surveyDetailsUrl) +
    //         id));

    // print(res.body.toString());

    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      List<dynamic> body = contents['responseData']['fields'];
      List<MicroSurvey> surveys = body
          .map(
            (dynamic item) => MicroSurvey.fromJson(item),
          )
          .toList();
      List<MicroSurvey> tempSurveys = [];
      int i = 1;
      for (var survey in surveys) {
        if (survey.fieldType != QuestionType.heading) {
          survey.id = i++;
          tempSurveys.add(survey);
        }
      }
      Map surveyDetails = {
        'id': contents['responseData']['id'],
        'title': contents['responseData']['title'],
        'version': contents['responseData']['version'],
        'questions': tempSurveys,
      };
      return surveyDetails;
    } else {
      throw 'Can\'t get surveys.';
    }
  }

  Future<dynamic> saveMicroSurvey(Map data,
      {bool isContentFeedback = false}) async {
    // String token = await _storage.read(key: 'authToken');
    // String wid = await _storage.read(key: 'wid');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader:
          isContentFeedback ? 'bearer ${ApiUrl.apiKey}' : 'Bearer $token',
      HttpHeaders.acceptHeader: '*/*',
      'content-type': 'application/json; charset=utf-8',
      'hostpath':
          isContentFeedback ? ApiUrl.baseUrl : FeedbackApiEndpoint.baseUrl,
    };

    var body = json.encode(data);
    // print('URL to submit: ' +
    //     (isContentFeedback
    //         ? (ApiUrl.baseUrl + FeedbackApiEndpoint.submitSurvey)
    //         : saveSurveyUrl));

    Response res = await post(
        Uri.parse((isContentFeedback
            ? (ApiUrl.baseUrl + FeedbackApiEndpoint.submitContentSurvey)
            : saveSurveyUrl)),
        headers: headers,
        body: body);
    // print(saveSurveyUrl + ': ' + res.body);

    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      var response = contents['responseData'];
      return response;
    } else {
      throw 'Can\'t save surveys.';
    }
  }

  Future<dynamic> getSubmittedFeedback(String id) async {
    // String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: Storage.wid);
    // print('ID: $id');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'bearer ${ApiUrl.apiKey}',
      HttpHeaders.acceptHeader: '*/*',
      'content-type': 'application/json; charset=utf-8',
      'hostpath': ApiUrl.baseUrl,
    };

    Map data = {
      "searchObjects": [
        {"key": "formId", "values": "$id"}
      ]
    };

    var body = jsonEncode(data);

    Response res = await post(
        Uri.parse(ApiUrl.baseUrl + FeedbackApiEndpoint.getSubmittedFeedback),
        headers: headers,
        body: body);

    // print('URL: ' + ApiUrl.baseUrl + FeedbackApiEndpoint.getSubmittedFeedback);

    // developer.log('Getting submitted feedback: ' + res.body.toString());

    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      var submittedFeedbacks = contents['responseData'].length > 0
          ? contents['responseData'][0]['dataObject']
          : null;
      // print(submittedFeedbacks.toString());
      //   List<MicroSurvey> surveys = body
      //       .map(
      //         (dynamic item) => MicroSurvey.fromJson(item),
      //       )
      //       .toList();
      //   print('Survey length before: ' + surveys.length.toString());
      //   List<MicroSurvey> tempSurveys = [];
      //   int i = 1;
      //   for (var survey in surveys) {
      //     if (survey.fieldType != QuestionType.heading) {
      //       survey.id = i++;
      //       tempSurveys.add(survey);
      //     }
      //   }
      //   Map surveyDetails = {
      //     'id': contents['responseData']['id'],
      //     'title': contents['responseData']['title'],
      //     'version': contents['responseData']['version'],
      //     'questions': tempSurveys,
      //   };
      return submittedFeedbacks;
    } else {
      throw 'Can\'t get surveys.';
    }
  }
}
