import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/models/_models/browse_competency_card_model.dart';
import 'package:karmayogi_mobile/models/_models/profile_model.dart';
import 'package:karmayogi_mobile/services/_services/profile_service.dart';
import 'dart:convert';
import 'dart:async';
import './../../constants/index.dart';
import './../../util/helper.dart';
// import 'dart:developer' as developer;

class CompetencyService {
  final _storage = FlutterSecureStorage();
  List<BrowseCompetencyCardModel> browseCompetencyCardModel = [];
  final ProfileService profileService = ProfileService();

  Future<dynamic> recommendedFromFrac() async {
    String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: 'wid');
    String designation = await _storage.read(key: Storage.designation);

    Map data = {
      'type': 'COMPETENCY',
      'mappings': [
        {
          'type': 'POSITION',
          'name': '$designation',
          // 'name': 'Director( Admin and GA)',
          'relation': 'parent'
        }
      ]
    };

    var body = json.encode(data);
    Response response = await post(
        Uri.parse(ApiUrl.fracBaseUrl + ApiUrl.recommendedFromFrac),
        headers: Helper.knowledgeResourcePostHeaders(token),
        body: body);
    // print(response.body);
    return response;
  }

  Future<dynamic> getLevelsForCompetency(id, competency) async {
    String token = await _storage.read(key: Storage.authToken);

    Response response = await get(
      Uri.parse(ApiUrl.fracBaseUrl +
          ApiUrl.getLevelsForCompetency +
          '?id=$id&type=$competency&isDetail=true'),
      headers: Helper.knowledgeResourcePostHeaders(token),
    );
    // print('Levels: ' + response.body);
    return response;
  }

  Future<dynamic> getCompetencies() async {
    String token = await _storage.read(key: Storage.authToken);

    Map data = {
      "searches": [
        {"type": "COMPETENCY", "field": "name", "keyword": ""},
        {"type": "COMPETENCY", "field": "status", "keyword": "VERIFIED"}
      ],
      "childNodes": true
    };

    var body = jsonEncode(data);

    Response response = await post(
        Uri.parse(ApiUrl.fracBaseUrl + ApiUrl.getCompetencies),
        headers: Helper.knowledgeResourcePostHeaders(token),
        body: body);
    // print('Competencies: ' + response.body);
    return response;
  }

  Future<dynamic> recommendedFromWat() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.recommendedFromWat + wid),
      headers: Helper.postHeaders(token, wid),
    );

    return response;
  }

  Future<dynamic> allCompetencies() async {
    String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: 'wid');

    Map data = {
      'searches': [
        {'type': 'COMPETENCY', 'field': 'name', 'keyword': ''},
        {'type': 'COMPETENCY', 'field': 'status', 'keyword': 'VERIFIED'}
      ]
    };

    var body = json.encode(data);
    Response res = await post(
        Uri.parse(ApiUrl.fracBaseUrl + ApiUrl.allCompetencies),
        headers: Helper.knowledgeResourcePostHeaders(token),
        body: body);
    // print(res.body);
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents;
    } else {
      throw 'Can\'t get all competencies.';
    }
  }

  Future<dynamic> selfAttestCompetency(
      Map attestedCompetency, List<Profile> profileDetails) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    var userTagged = profileDetails[0].competencies.where(
        (competency) => competency['id'].contains(attestedCompetency['id']));

    if (userTagged.length == 0) {
      profileDetails[0].competencies.add(attestedCompetency);

      Map data = {
        "request": {
          "userId": "$wid",
          "profileDetails": {
            "skills": profileDetails[0].skills,
            "professionalDetails": profileDetails[0].professionalDetails,
            "employmentDetails": profileDetails[0].employmentDetails,
            "photo": profileDetails[0].photo,
            "personalDetails": profileDetails[0].personalDetails,
            "academics": profileDetails[0].education,
            "id": "$wid",
            "mandatoryFieldsExists": true,
            "interests": profileDetails[0].interests,
            "userId": "$wid",
            "competencies": profileDetails[0].competencies,
            "userRoles": profileDetails[0].userRoles,
            "systemTopics": profileDetails[0].selectedTopics,
            "desiredTopics": profileDetails[0].desiredTopics,
            "desiredCompetencies": profileDetails[0].desiredCompetencies
          }
        }
      };

      var body = jsonEncode(data);

      Response res = await patch(
          Uri.parse(ApiUrl.baseUrl + ApiUrl.updateProfileDetailsWithoutPatch),
          headers: Helper.getHeaders(token, wid),
          body: body);
      return jsonDecode(res.body);
    } else {
      throw 'Already exist';
    }
  }

  Future<dynamic> removeFromYourCompetency(
      String id, List<Profile> profileDetails) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    profileDetails[0]
        .competencies
        .removeWhere((competency) => competency['id'] == id);

    Map data = {
      "request": {
        "userId": "$wid",
        "profileDetails": {
          "skills": profileDetails[0].skills,
          "professionalDetails": profileDetails[0].professionalDetails,
          "employmentDetails": profileDetails[0].employmentDetails,
          "photo": profileDetails[0].photo,
          "personalDetails": profileDetails[0].personalDetails,
          "academics": profileDetails[0].education,
          "id": "$wid",
          "mandatoryFieldsExists": true,
          "interests": profileDetails[0].interests,
          "userId": "$wid",
          "competencies": profileDetails[0].competencies,
          "userRoles": profileDetails[0].userRoles,
          "systemTopics": profileDetails[0].selectedTopics,
          "desiredTopics": profileDetails[0].desiredTopics,
          "desiredCompetencies": profileDetails[0].desiredCompetencies
        }
      }
    };

    var body = jsonEncode(data);

    Response res = await patch(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.updateProfileDetailsWithoutPatch),
        headers: Helper.getHeaders(token, wid),
        body: body);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw 'Removing failed';
    }
  }
}
