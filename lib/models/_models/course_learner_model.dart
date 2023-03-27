import 'package:flutter/material.dart';

class CourseLearner {
  final String id;
  final String firstName;
  final String lastName;
  final String department;
  final String email;
  final String activeStatus;
  final String fullName;

  CourseLearner({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.department,
    @required this.email,
    @required this.activeStatus,
    this.fullName,
  });

  factory CourseLearner.fromJson(Map<String, dynamic> json) {
    return CourseLearner(
      id: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      department: json['department'] as String,
      email: json['email'] as String,
      activeStatus: json['desc'] as String,
      fullName: json['first_name'] + json['last_name'],
    );
  }
}
