import 'package:flutter/material.dart';

class Batch {
  final String id;
  final String batchId;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String enrollmentEndDate;
  final int status;

  const Batch({
    @required this.id,
    @required this.batchId,
    @required this.name,
    @required this.description,
    @required this.startDate,
    @required this.endDate,
    @required this.enrollmentEndDate,
    @required this.status,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'] as String,
      batchId: json['batch_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      enrollmentEndDate: json['enrollmentEndDate'] as String,
      status: json['status'] as int,
    );
  }
}
