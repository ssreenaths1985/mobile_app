import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';
import './../../../../ui/widgets/index.dart';

class CourseVideoAssessment extends StatefulWidget {
  @override
  _CourseVideoAssessmentState createState() {
    return _CourseVideoAssessmentState();
  }
}

class _CourseVideoAssessmentState extends State<CourseVideoAssessment> {
  int questionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: AppColors.greys60),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Agile methodology',
            style: GoogleFonts.montserrat(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        body: questionIndex > 2
            ? HomepageAssessmentCompleted()
            : ASSESSMENT_QUESTIONS[questionIndex].questionType ==
                    QuestionTypes.singleAnswer
                ? SingleAnswerQuestion(ASSESSMENT_QUESTIONS[questionIndex])
                // : MultipleAnswerQuestion(ASSESSMENT_QUESTIONS[questionIndex]),
                : Center(),
        bottomSheet: Container(
          height: questionIndex > 2 ? 0 : 58,
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: AppColors.grey08,
              blurRadius: 6.0,
              spreadRadius: 0,
              offset: Offset(
                0,
                -3,
              ),
            ),
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      questionIndex++;
                    });
                  },
                  style: TextButton.styleFrom(
                    // primary: Colors.white,
                    backgroundColor: AppColors.customBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: AppColors.grey16)),
                    // onSurface: Colors.grey,
                  ),
                  child: Text(
                    questionIndex < 2 ? 'Next' : 'Finish',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
