import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants.dart';

class SurveyHeader extends StatefulWidget {
  final int questionIndex;
  final int totalQuestions;
  SurveyHeader({this.questionIndex, this.totalQuestions});
  @override
  _SurveyCompletedState createState() => _SurveyCompletedState();
}

class _SurveyCompletedState extends State<SurveyHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Text(
        'Question ${widget.questionIndex + 1} of ${widget.totalQuestions}',
        style: GoogleFonts.lato(
          color: FeedbackColors.black60,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
