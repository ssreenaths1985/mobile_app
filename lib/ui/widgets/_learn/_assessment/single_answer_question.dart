import 'package:flutter/material.dart';
import './../../../../models/_models/assessment_question_model.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';

class SingleAnswerQuestion extends StatefulWidget {
  final AssessmentQuestion question;
  SingleAnswerQuestion(this.question);
  @override
  _SingleAnswerQuestionState createState() => _SingleAnswerQuestionState();
}

class _SingleAnswerQuestionState extends State<SingleAnswerQuestion> {
  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Q' + widget.question.id.toString() + ' of 3',
                style: GoogleFonts.lato(
                  color: AppColors.greys60,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                widget.question.question,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.question.options.length,
              itemBuilder: (context, index) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    // padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: _radioValue == index + 1
                          ? Color.fromRGBO(0, 116, 182, 0.05)
                          : Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(4.0)),
                      border: Border.all(
                          color: _radioValue == index + 1
                              ? AppColors.primaryThree
                              : AppColors.grey16),
                    ),
                    child: RadioListTile(
                      groupValue: _radioValue,
                      title: Text(
                        widget.question.options[index],
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      value: index + 1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue = value;
                        });
                      },
                    ));
              },
            ),
          ],
        ));
  }
}
