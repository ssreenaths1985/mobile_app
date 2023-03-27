import 'dart:convert';

import 'package:http/http.dart';
import 'package:karmayogi_mobile/env/env.dart';
import 'package:karmayogi_mobile/models/_models/landing_page_info_model.dart';

import '../../constants/_constants/api_endpoints.dart';
import '../../models/_models/course_model.dart';

class LandingPageService {
  Future<LandingPageInfo> getLandingPageInfo() async {
    Response response = await get(
      Uri.parse(Env.configUrl),
    );
    var contents = jsonDecode(response.body);
    LandingPageInfo landingPageInfo = LandingPageInfo.fromJson(contents);
    return landingPageInfo;
  }

  Future<List<Course>> getFeaturedCourses() async {
    String _errorMessage;
    List<Course> courses = [];
    Response response = await get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.getFeaturedCourses),
    );
    // print(contents);
    if (response.statusCode == 200) {
      var contents = jsonDecode(response.body);

      List<dynamic> body = contents['result']['content'];
      courses = body
          .map(
            (dynamic item) => Course.fromJson(item),
          )
          .toList();
      // print(courses);
      return courses;
    } else {
      _errorMessage = response.statusCode.toString();
      throw _errorMessage;
    }
    // LandingPageInfo landingPageInfo = LandingPageInfo.fromJson(contents);
    // return landingPageInfo;
  }
}
