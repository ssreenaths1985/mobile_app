// import 'dart:io';
import 'package:flutter/foundation.dart';

class DeleteNotification {
  final String userId;
  final String notificationId;

  DeleteNotification({
    @required this.userId,
    @required this.notificationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'notification_id': notificationId,
    };
  }
}
