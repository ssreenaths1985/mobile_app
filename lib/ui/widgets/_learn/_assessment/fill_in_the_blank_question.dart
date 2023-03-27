import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import './../../../../constants/index.dart';
import './../../../../feedback/constants.dart';

class FillInTheBlankQuestion extends StatefulWidget {
  final question;
  final int currentIndex;
  final answerGiven;
  final bool showAnswer;
  final ValueChanged<Map> parentAction;
  FillInTheBlankQuestion(this.question, this.currentIndex, this.answerGiven,
      this.showAnswer, this.parentAction);
  @override
  _FillInTheBlankQuestionState createState() => _FillInTheBlankQuestionState();
}

class _FillInTheBlankQuestionState extends State<FillInTheBlankQuestion> {
  final TextEditingController _optionController = TextEditingController();
  List<String> _questionText = [];
  String _questionId;

  @override
  void initState() {
    // _optionController.addListener(() {
    //   widget.parentAction({
    //     'index': widget.question['questionId'],
    //     'isCorrect': widget.question['options'][0]['isCorrect'],
    //     'value': _optionController.text,
    //     'optionId': widget.question['options'][0]['optionId'],
    //     'text': widget.question['options'][0]['text'],
    //   });
    // });
    _questionText =
        widget.question['question'].split(ASSESSMENT_FITB_QUESTION_INPUT);
    _questionId = widget.question['questionId'];
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _optionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questionId != widget.question['questionId']) {
      _optionController.text = widget.answerGiven;
      _questionId = widget.question['questionId'];
    }
    return Container(
        height: MediaQuery.of(context).size.height - 30,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: HtmlWidget(
                _questionText[0],
                textStyle: GoogleFonts.lato(
                  color: FeedbackColors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Focus(
                  child: TextFormField(
                    onEditingComplete: () {
                      widget.parentAction({
                        'index': widget.question['questionId'],
                        'isCorrect': widget.question['options'][0]['isCorrect'],
                        'value': _optionController.text,
                        'optionId': widget.question['options'][0]['optionId'],
                        'text': widget.question['options'][0]['text'],
                      });
                      return true;
                    },
                    enabled:
                        (widget.answerGiven != null && widget.answerGiven != '')
                            ? false
                            : true,
                    textInputAction: TextInputAction.done,
                    controller: _optionController,
                    style: GoogleFonts.lato(fontSize: 14.0),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      // border: OutlineInputBorder(
                      //     borderSide: BorderSide(color: AppColors.grey16)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey16),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryThree),
                      ),
                      hintText: '',
                      hintStyle: GoogleFonts.lato(
                          color: AppColors.grey40,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: const BorderSide(
                      //       color: AppColors.primaryThree, width: 1.0),
                      // ),
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: HtmlWidget(
                _questionText[1],
                textStyle: GoogleFonts.lato(
                  color: FeedbackColors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
            widget.showAnswer
                ? Container(
                    child: Text(
                      widget.question['options'][0]['text'],
                      style: GoogleFonts.lato(
                        color: FeedbackColors.positiveLight,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Center()
          ],
        ));
  }
}
