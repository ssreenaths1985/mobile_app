import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/util/helper.dart';

// import 'dart:developer' as developer;

class EventService {
  final _storage = FlutterSecureStorage();

  Future<dynamic> getAllEvents() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "locale": ["en"],
      "query": "",
      "request": {
        "query": "",
        "filters": {
          "status": ["Live"],
          "contentType": "Event"
        },
        "sort_by": {"startDate": "desc"}
      }
    };

    var body = json.encode(data);

    Response response = await post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getAllEvents),
        headers: Helper.postHeaders(token, wid),
        body: body);
    // print('res: ' + res.body);

    return response;
  }

  Future<dynamic> getEventsForMDO() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String rootOrgId = await _storage.read(key: Storage.deptId);

    Map data = {
      "locale": ["en"],
      "query": "",
      "request": {
        "query": "",
        "filters": {
          "status": ["Live"],
          "contentType": "Event",
          "createdFor": ["$rootOrgId"]
        },
        "sort_by": {"startDate": "desc"}
      }
    };

    var body = json.encode(data);

    Response response = await post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getAllEvents),
        headers: Helper.postHeaders(token, wid),
        body: body);
    // print('res: ' + res.body);
    return response;
  }

  Future<dynamic> getEventDetails(String id) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Response response = await get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.readEvent + '$id'),
        headers: Helper.discussionGetHeaders(token, wid));
    // print('res: ' + res.body);
    // developer.log(utf8.decode(response.bodyBytes));
    return response;
  }
}
