import 'package:flutter/material.dart';

class CourseTopics {
  final String identifier;
  final String name;
  final int noOfHoursConsumed;
  final raw;

  CourseTopics({
    @required this.identifier,
    @required this.name,
    @required this.noOfHoursConsumed,
    this.raw,
  });

  factory CourseTopics.fromJson(Map<String, dynamic> json) {
    return CourseTopics(
        identifier: json['identifier'] as String,
        name: json['name'] as String,
        noOfHoursConsumed: json['noOfHoursConsumed'] as int,
        raw: json);
  }
}
