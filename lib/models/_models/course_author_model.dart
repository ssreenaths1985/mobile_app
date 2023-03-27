import 'package:flutter/material.dart';

class CourseAuthor {
  final String firstName;
  final String lastName;
  final String department;
  final String email;
  final String userType;

  CourseAuthor({
    @required this.firstName,
    @required this.lastName,
    @required this.department,
    @required this.email,
    @required this.userType,
  });

  factory CourseAuthor.fromJson(Map<String, dynamic> json) {
    return CourseAuthor(
      firstName: json['first_name'] as String,
      // lastName: json['last_name'] as String,
      lastName: '',
      department: json['department'] as String,
      email: json['email'] as String,
      userType: json['desc'] as String,
    );
  }
}
