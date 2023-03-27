import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'dart:convert';
import 'dart:async';
import './../../constants/index.dart';
import './../../util/helper.dart';
import './../../util/telemetry.dart';
// import 'dart:developer' as developer;

class TelemetryService {
  final String telemetryUrl = ApiUrl.baseUrl + ApiUrl.getTelemetryUrl;
  final String telemetryPublicUrl =
      ApiUrl.baseUrl + ApiUrl.getPublicTelemetryUrl;
  final _storage = FlutterSecureStorage();

  Future<dynamic> triggerEvent(eventData, {bool isPublic = false}) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String messageId = await Telemetry.generateMessageId();

    Map data = {
      'id': TELEMETRY_ID,
      'ver': APP_VERSION,
      'params': {'msgid': '$messageId'},
      'ets': DateTime.now().millisecondsSinceEpoch,
      'events': eventData
    };

    var body = json.encode(data);
    // developer.log(body);
    Response res = !isPublic
        ? await post(Uri.parse(telemetryUrl),
            headers: Helper.postHeaders(token, wid), body: body)
        : await post(Uri.parse(telemetryPublicUrl),
            headers: Helper.registerPostHeaders(), body: body);
    var response = jsonDecode(res.body);
    // developer.log(telemetryUrl + ": " + res.body);
    if (response['responseCode'] == 'SUCCESS') {
      // developer.log(jsonEncode(response));
      return response;
    } else {
      throw 'Can\'t send telemetry event.';
    }
  }
}
