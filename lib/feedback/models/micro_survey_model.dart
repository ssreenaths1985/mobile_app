import 'package:flutter/material.dart';

class MicroSurvey {
  int id;
  final String fieldType;
  final bool isRequired;
  final String question;
  final List options;
  dynamic answer;

  MicroSurvey({
    @required this.id,
    @required this.fieldType,
    @required this.isRequired,
    @required this.question,
    @required this.options,
    @required this.answer,
  });

  factory MicroSurvey.fromJson(Map<String, dynamic> json) {
    return MicroSurvey(
      id: json['order'] as int,
      fieldType: json['fieldType'] as String,
      isRequired: json['isRequired'] as bool,
      question: json['name'] as String,
      options: json['values'] as List,
      answer: null,
    );
  }
}
