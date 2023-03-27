import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './../../constants.dart';

class SurveyCompleted extends StatefulWidget {
  final int totalQuestions;
  final int questionsAnswered;
  final String timeSpent;
  final ValueChanged<int> parentAction;
  SurveyCompleted(this.totalQuestions, this.questionsAnswered, this.timeSpent,
      this.parentAction);
  @override
  _SurveyCompletedState createState() => _SurveyCompletedState();
}

class _SurveyCompletedState extends State<SurveyCompleted> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 231,
        width: double.infinity,
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        size: 20, color: FeedbackColors.avatarGreen),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Text(
                        'Good work!',
                        style: GoogleFonts.lato(
                          color: FeedbackColors.black87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Your score is',
                  style: GoogleFonts.lato(
                    color: FeedbackColors.black60,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Container(
                  height: 52,
                  width: 88,
                  color: FeedbackColors.ghostWhite,
                  child: Center(
                    child: Text(
                      (widget.questionsAnswered / widget.totalQuestions * 100)
                              .ceil()
                              .toString() +
                          " %",
                      style: GoogleFonts.lato(
                        color: FeedbackColors.black87,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'We do not record these scores in our system. \n Retake as many times as you want',
                  style: GoogleFonts.lato(
                    color: FeedbackColors.black60,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: 244,
        width: double.infinity,
        margin: EdgeInsets.only(top: 8.0, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24),
              child: Text(
                'Insights',
                style: GoogleFonts.lato(
                  color: FeedbackColors.black60,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
              child: Container(
                height: 48,
                color: FeedbackColors.black04,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 19),
                      child: Icon(Icons.done,
                          size: 20, color: FeedbackColors.avatarGreen),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Text(
                        '${widget.questionsAnswered} questions answered',
                        style: GoogleFonts.lato(
                          color: FeedbackColors.black87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.totalQuestions - widget.questionsAnswered > 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
                    child: Container(
                      height: 48,
                      color: FeedbackColors.black04,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 19),
                            child: SvgPicture.asset(
                              'assets/img/skip_next.svg',
                              // width: 40.0,
                              // height: 56.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Text(
                              '${widget.totalQuestions - widget.questionsAnswered} questions not answered',
                              style: GoogleFonts.lato(
                                color: FeedbackColors.black87,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
              child: Container(
                height: 48,
                color: FeedbackColors.black04,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 19),
                      child: Icon(Icons.timer,
                          size: 20, color: FeedbackColors.blueCard),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Text(
                        'Time spent: ${widget.timeSpent}',
                        style: GoogleFonts.lato(
                          color: FeedbackColors.black87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
