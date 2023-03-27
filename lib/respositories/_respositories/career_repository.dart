import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/models/_models/career_opening_model.dart';
import 'package:karmayogi_mobile/models/_models/pagination_career_model.dart';
import '../../services/index.dart';

class CareerRepository with ChangeNotifier {
  List<CareerOpening> _careerOpenings = [];
  PaginationCareer _pageDetails;
  final CareerOpeningService careerService = CareerOpeningService();

  /// Process career openings
  Future<dynamic> getCareerOpenings(int pageNo) async {
    try {
      final careerOpenings =
          await careerService.getCareerOpeningsByPageNo(pageNo);
      List<dynamic> careers = careerOpenings['topics'];
      _careerOpenings = careers
          .map(
            (dynamic item) => CareerOpening.fromJson(item),
          )
          .toList();
    } catch (_) {
      return _;
    }
    // notifyListeners();
    return _careerOpenings;
  }

  /// Process career page counts
  Future<dynamic> getCareerPageCount(int pageNo) async {
    try {
      final careerPageInfo =
          await careerService.getCareerOpeningsByPageNo(pageNo);
      _pageDetails = PaginationCareer.fromJson(careerPageInfo['pagination']);
    } catch (_) {
      return _;
    }

    return _pageDetails;
  }
}
