import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import './../../constants/index.dart';
import './../../services/index.dart';
import './../../util/helper.dart';

class NotificationService extends BaseService {
  NotificationService(HttpClient client) : super(client);

  /// Return list of people as you may know as response
  static Future<dynamic> fetchNotifications(nextPage) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String url;
    if (nextPage != '') {
      url = ApiUrl.baseUrl + ApiUrl.notifications + '&page=' + nextPage;
    } else {
      url = ApiUrl.baseUrl + ApiUrl.notifications;
    }
    final response = await http.get(
      Uri.parse(url),
      headers: Helper.getHeaders(token, wid),
    );

    Map notifications = json.decode(response.body);

    return notifications;
  }

  static Future<dynamic> fetchUnSeenNotificationsCount() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.notificationsCount),
      headers: Helper.getHeaders(token, wid),
    );

    return response.body;
  }

  static Future<dynamic> markReadNotifications() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.patch(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.markReadNotifications),
      headers: Helper.getHeaders(token, wid),
    );

    return response.body;
  }

  static Future<dynamic> markReadNotification(id) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.patch(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.markReadNotification + id + '/Action'),
      headers: Helper.getHeaders(token, wid),
    );

    return response.body;
  }

  static Future<dynamic> fetchNotificationPreferenceSettings() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.notificationPreferenceSettings),
      headers: Helper.getHeaders(token, wid),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else
      // print(jsonDecode(response.body)['params']['errmsg']);
      throw response.statusCode;
  }

  static Future<dynamic> fetchNotificationPreference() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.userNotificationPreference),
      headers: Helper.getHeaders(token, wid),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else
      throw response.statusCode;
  }

  static Future<dynamic> updateNotificationSettings(
      Map notificationSettings) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {'request': notificationSettings};

    var body = json.encode(data);

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.userNotificationPreference),
        headers: Helper.notificationPostHeaders(token, wid),
        body: body);

    var contents = jsonDecode(response.body);
    return contents;
  }
}
