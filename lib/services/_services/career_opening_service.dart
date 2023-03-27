import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'dart:convert';
import 'dart:async';
import './../../constants/_constants/api_endpoints.dart';
import './../../models/index.dart';
import './../../util/helper.dart';

class CareerOpeningService {
  final String careerOpeningsUrl = ApiUrl.baseUrl + ApiUrl.getCareers;
  final _storage = FlutterSecureStorage();

  Future<dynamic> getCareerOpeningsByPageNo(int pageNo) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response res = await get(Uri.parse(careerOpeningsUrl + '?page=$pageNo'),
        headers: Helper.discussionGetHeaders(token, wid));
    // print('res: ' + res.body);
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents;
    } else {
      throw 'Can\'t get career openings.';
    }
  }

  Future<List<CareerOpening>> getCareerOpenings() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    // String nodebbUserId = await _storage.read(key: 'nodebbUserId');

    // print('nodeId: ' +
    //     Uri.parse(careerOpeningsUrl + '?_uid=$nodebbUserId').toString());

    Response res = await get(Uri.parse(careerOpeningsUrl),
        headers: Helper.discussionGetHeaders(token, wid));
    // print('Careers: ' + res.body);
    // print(careerOpeningsUrl + '&_uid=$nodebbUserId' + ": " + res.body);
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      List<dynamic> body = contents['topics'];
      List<CareerOpening> careerOpenings = body
          .map(
            (dynamic item) => CareerOpening.fromJson(item),
          )
          .toList();
      return careerOpenings;
    } else {
      throw 'Can\'t get career openings.';
    }
  }
}
