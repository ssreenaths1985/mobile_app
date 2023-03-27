import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import './../../../../feedback/constants.dart';

class AssessmentCompleted extends StatefulWidget {
  final int totalQuestions;
  final int questionsAnswered;
  final int wrongAnswers;
  final String timeSpent;
  final Map apiResponse;
  final ValueChanged<int> parentAction;
  AssessmentCompleted(this.totalQuestions, this.questionsAnswered,
      this.wrongAnswers, this.timeSpent, this.apiResponse, this.parentAction);
  @override
  _AssessmentCompletedState createState() => _AssessmentCompletedState();
}

class _AssessmentCompletedState extends State<AssessmentCompleted> {
  @override
  Widget build(BuildContext context) {
    // print(widget.apiResponse);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: double.infinity,
        // height: 220,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/img/passed_score_b.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        size: 25, color: FeedbackColors.avatarGreen),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Text(
                        widget.apiResponse['result'] >=
                                widget.apiResponse['passPercent']
                            ? 'Good work!'
                            : 'Need improvement!',
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
                padding: const EdgeInsets.only(top: 25),
                child: Container(
                  // height: 52,
                  // width: 88,
                  child: Center(
                    child: Text(
                      // (widget.questionsAnswered / widget.totalQuestions * 100)
                      //         .ceil()
                      //         .toString() +
                      //     " %",
                      widget.apiResponse['result'].ceil().toString() + ' %',
                      style: GoogleFonts.lato(
                        color: FeedbackColors.primaryBlue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 25),
                child: Text(
                  'Your score',
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
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'We do not record these scores in our system. \n Retake as many times as you want',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            color: FeedbackColors.black60,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      SingleChildScrollView(
        child: Container(
          // height: widget.apiResponse['inCorrect'] > 0 ? 300 : 244,
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
                        child: Icon(Icons.summarize,
                            size: 20, color: FeedbackColors.avatarGreen),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: Text(
                          // '${widget.apiResponse['total'] - widget.apiResponse['blank']} questions answered',
                          'Total ${widget.apiResponse['total']} questions',
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
              widget.apiResponse['blank'] > 0
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 24, top: 8, right: 24),
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
                                '${widget.apiResponse['blank']} questions not answered',
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
              widget.apiResponse['correct'] > 0
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 24, top: 8, right: 24),
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
                                '${widget.apiResponse['correct']} questions correct answered',
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
              widget.apiResponse['inCorrect'] > 0
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 24, top: 8, right: 24),
                      child: Container(
                        height: 48,
                        color: FeedbackColors.black04,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 19),
                              child: SvgPicture.asset(
                                'assets/img/close_black.svg',
                                color: AppColors.negativeLight,
                                // width: 40.0,
                                // height: 56.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 11),
                              child: Text(
                                '${widget.apiResponse['inCorrect']} questions wrong answered',
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
      ),
    ]);
  }
}
