import 'package:flutter/foundation.dart';

class TelemetryEventModel {
  final String userId;
  final Map eventData;

  TelemetryEventModel({
    @required this.userId,
    @required this.eventData,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'telemetry_data': eventData,
    };
  }
}
