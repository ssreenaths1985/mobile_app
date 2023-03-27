import 'package:flutter/material.dart';

class AssessmentQuestion {
  final int id;
  final String question;
  final List options;
  final String questionType;

  const AssessmentQuestion({
    @required this.id,
    @required this.question,
    @required this.options,
    @required this.questionType,
  });
}
