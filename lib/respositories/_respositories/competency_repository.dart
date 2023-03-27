import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:karmayogi_mobile/models/_models/browse_competency_card_model.dart';
import 'package:karmayogi_mobile/services/_services/competencies_service.dart';

class CompetencyRepository with ChangeNotifier {
  final CompetencyService competencyService = CompetencyService();
  List<BrowseCompetencyCardModel> browseCompetencyCardModel = [];
  String _errorMessage = '';
  Response _data;

  Future<List<BrowseCompetencyCardModel>> recommendedFromFrac() async {
    try {
      final response = await competencyService.recommendedFromFrac();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      List<dynamic> data = contents['responseData'];
      List<BrowseCompetencyCardModel> browseCompetencyCardModel = data
          .map(
            (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
          )
          .toList();

      return browseCompetencyCardModel;
    } else {
      // throw 'Can\'t get frac recommended competencies.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<dynamic> getLevelsForCompetency(id, competency) async {
    try {
      final response =
          await competencyService.getLevelsForCompetency(id, competency);
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      var contents = jsonDecode(_data.body);
      var levels = contents['responseData']['children'];
      return levels;
    } else {
      // throw 'Can\'t get frac recommended competencies.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<dynamic> getCompetencies() async {
    try {
      final response = await competencyService.getCompetencies();
      _data = response;
    } catch (_) {
      return _;
    }
    if (_data.statusCode == 200) {
      List<dynamic> contents = jsonDecode(_data.body)['responseData'];
      List<BrowseCompetencyCardModel> browseCompetencyCardModel = contents
          .map(
            (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
          )
          .toList();
      return browseCompetencyCardModel;
    } else {
      // throw 'Can\'t get frac recommended competencies.';
      _errorMessage = _data.statusCode.toString();
      throw _errorMessage;
    }
  }

  Future<List<BrowseCompetencyCardModel>> recommendedFromWat() async {
    try {
      final response = await competencyService.recommendedFromWat();
      _data = response;
    } catch (_) {
      return _;
    }

    if (_data.statusCode == 200) {
      List<dynamic> contents = jsonDecode(_data.body)['result']['data'];
      List<BrowseCompetencyCardModel> browseCompetencyCardModel = contents
          .map(
            (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
          )
          .toList();
      return browseCompetencyCardModel;
    } else
      // throw 'Can\'t get competencies from WAT.';
      throw _errorMessage = _data.statusCode.toString();
  }
}
