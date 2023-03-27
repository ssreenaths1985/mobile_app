import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'dart:async';
import './../../constants/index.dart';
import './../../util/helper.dart';

class BadgeService {
  final String badgesUrl = ApiUrl.baseUrl + '/api/user/badge';
  final _storage = FlutterSecureStorage();

  Future<dynamic> getEarnedBadges() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response =
        await get(Uri.parse(badgesUrl), headers: Helper.getHeaders(token, wid));

    return response;
  }

  Future<dynamic> getCanEarnBadges() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response =
        await get(Uri.parse(badgesUrl), headers: Helper.getHeaders(token, wid));
    // print('header' + Helper.getHeaders(token, wid).toString());
    return response;
  }
}
