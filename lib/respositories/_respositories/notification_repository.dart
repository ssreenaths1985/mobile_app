import 'dart:convert';

import 'package:flutter/widgets.dart';
import './../../models/index.dart' as Modals;
import './../../services/index.dart';

class NotificationRespository with ChangeNotifier {
  List<Modals.Notification> _myNotifications = [];

  Future<dynamic> getNotifications(String nextPage) async {
    try {
      var response = await NotificationService.fetchNotifications(nextPage);
      response['data'][0]['nextPage'] = response['page'];
      _myNotifications = [
        for (final item in response['data']) Modals.Notification.fromJson(item)
      ];
    } catch (_) {
      return _;
    }
    return _myNotifications;
  }

  Future<dynamic> getUnSeenNotificationsCount() async {
    var response;
    try {
      response = await NotificationService.fetchUnSeenNotificationsCount();
    } catch (_) {
      return _;
    }
    return response;
  }

  Future<dynamic> markAllReadNotifications() async {
    var response;
    try {
      response = await NotificationService.markReadNotifications();
    } catch (_) {
      return _;
    }
    return response;
  }

  Future<dynamic> markReadNotification(String id) async {
    var response;
    try {
      response = await NotificationService.markReadNotification(id);
    } catch (_) {
      return _;
    }
    // print(response.toString());
    return response;
  }

  Future<dynamic> getNotificationPreferenceSettings() async {
    var response;
    try {
      response =
          await NotificationService.fetchNotificationPreferenceSettings();
    } catch (_) {
      return _;
    }
    return jsonDecode(
        response['result']['response']['value'])['notificationPreferenceList'];
  }

  Future<dynamic> getNotificationPreference() async {
    var response;
    try {
      response = await NotificationService.fetchNotificationPreference();
    } catch (_) {
      return _;
    }
    if (response['result'] != null &&
        response['result']['notification_preference'] != null) {
      return response['result']['notification_preference'];
    } else
      return null;
  }

  Future<dynamic> saveNotificationSettings(Map notificationPreference) async {
    var response;
    try {
      response = await NotificationService.updateNotificationSettings(
          notificationPreference);
    } catch (_) {
      return _;
    }
    return response;
  }
}
