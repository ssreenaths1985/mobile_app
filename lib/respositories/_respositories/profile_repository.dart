import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:karmayogi_mobile/models/_models/degree_model.dart';
import 'package:karmayogi_mobile/models/_models/language_model.dart';
import 'package:karmayogi_mobile/models/_models/nationality_model.dart';
import 'package:karmayogi_mobile/models/_models/profile_model.dart';
import 'package:karmayogi_mobile/services/_services/profile_service.dart';

class ProfileRepository with ChangeNotifier {
  final ProfileService profileService = ProfileService();
  String _errorMessage = '';
  Response _data;

  Future<List<Profile>> getProfileDetails() async {
    try {
      final response = await profileService.getProfileDetails();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['result']['UserProfile'];
      // developer.log(jsonEncode(body));
      List<Profile> profileDetails = body
          .map(
            (dynamic item) => Profile.fromJson(item),
          )
          .toList();
      return profileDetails;
    } else {
      // throw 'Can\'t get profile details.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Profile>> getProfileDetailsById(id) async {
    // print('In profile api call repo $id');
    try {
      final response = await profileService.getProfileDetailsById(id);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      // print("Status = successful");
      var contents = jsonDecode(_data.body);
      // print("Contents $contents");
      Map body = contents['result']['response'];
      List<Profile> profileDetailsById = [];
      // print('body: $body');
      profileDetailsById.add(Profile.fromJson(body));
      // print('profileDetailsById: $profileDetailsById');
      return profileDetailsById;
    } else {
      // throw 'Can\'t get profile details by ID.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Nationality>> getNationalities() async {
    try {
      final response = await profileService.getNationalities();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['nationalities'];

      // print(body.toString());
      List<Nationality> nationalities = body
          .map(
            (dynamic item) => Nationality.fromJson(item),
          )
          .toList();
      return nationalities;
    } else {
      // throw 'Can\'t get nationalities.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Language>> getLanguages() async {
    try {
      final response = await profileService.getLanguages();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['languages'];
      List<Language> languages = body
          .map(
            (dynamic item) => Language.fromJson(item),
          )
          .toList();
      return languages;
    } else {
      // throw 'Can\'t get languages.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<Degree>> getDegrees(type) async {
    try {
      final response = await profileService.getDegrees(type);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body;
      if (type == 'graduation')
        body = contents['graduations'];
      else
        body = contents['postGraduations'];
      // print(body.toString());
      List<Degree> degrees = body
          .map(
            (dynamic item) => Degree.fromJson(item),
          )
          .toList();
      return degrees;
    } else {
      // throw 'Can\'t get degrees.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<dynamic>> getOrganisations() async {
    try {
      final response = await profileService.getOrganisations();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['ministries'];

      // print(body.toString());
      List<dynamic> organisations = body;
      return organisations;
    } else {
      // throw 'Can\'t get Organisations.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<dynamic>> getIndustries() async {
    try {
      final response = await profileService.getIndustries();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['industries'];

      List<dynamic> industries = body;
      return industries;
    } else {
      // throw 'Can\'t get Industries.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<dynamic>> getDesignations() async {
    try {
      final response = await profileService.getDesignations();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['designations'];

      List<dynamic> designations = body;
      return designations;
    } else {
      // throw 'Can\'t get Industries.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<dynamic>> getGradePay() async {
    try {
      final response = await profileService.getGradePay();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['gradePay'];

      List<dynamic> gradePay = body;
      return gradePay;
    } else {
      // throw 'Can\'t get Industries.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<dynamic>> getServices() async {
    try {
      final response = await profileService.getServices();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['services'];

      List<dynamic> services = body;
      return services;
    } else {
      // throw 'Can\'t get Industries.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<dynamic>> getCadre() async {
    try {
      final response = await profileService.getCadre();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> body = contents['cadre'];

      List<dynamic> cadre = body;
      return cadre;
    } else {
      // throw 'Can\'t get Industries.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<dynamic> getUserName(wid) async {
    try {
      final response = await profileService.getUserName(wid);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      Map wTokenResponse;
      wTokenResponse = json.decode(_data.body);

      return wTokenResponse['result']['response']['userName'];
    } else {
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }
}
