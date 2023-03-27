import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:karmayogi_mobile/feedback/constants.dart';
// import './../../constants.dart';

class RadioQuestion extends StatefulWidget {
  final question;
  final int currentIndex;
  final answerGiven;
  final bool showAnswer;
  final int correctAnswer;
  final ValueChanged<Map> parentAction;
  RadioQuestion(this.question, this.currentIndex, this.answerGiven,
      this.showAnswer, this.correctAnswer, this.parentAction);
  @override
  _RadioQuestionState createState() => _RadioQuestionState();
}

class _RadioQuestionState extends State<RadioQuestion> {
  String _radioValue = '';
  int _correctAnswer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _radioValue = widget.answerGiven;
      _correctAnswer = widget.correctAnswer;
    });
    return Container(
        height: MediaQuery.of(context).size.height + 100,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('${widget.currentIndex}, ${widget.answerGiven}, $_radioValue'),
            Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: HtmlWidget(
                  widget.question['question'],
                  textStyle: GoogleFonts.lato(
                    color: FeedbackColors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                )),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.question['options'].length,
              itemBuilder: (context, index) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    // padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: _radioValue ==
                                  widget.question['options'][index]['value'] &&
                              _correctAnswer == index &&
                              widget.showAnswer
                          ? FeedbackColors.positiveLightBg
                          : _radioValue ==
                                      widget.question['options'][index]
                                          ['text'] &&
                                  _correctAnswer != index &&
                                  widget.showAnswer
                              ? FeedbackColors.negativeLightBg
                              : _correctAnswer == index && widget.showAnswer
                                  ? FeedbackColors.positiveLightBg
                                  : Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(4.0)),
                      border: Border.all(
                          color: _radioValue ==
                                      widget.question['options'][index]
                                          ['text'] &&
                                  _correctAnswer == index &&
                                  widget.showAnswer
                              ? FeedbackColors.positiveLight
                              : _radioValue ==
                                          widget.question['options'][index]
                                              ['text'] &&
                                      _correctAnswer != index &&
                                      widget.showAnswer
                                  ? FeedbackColors.negativeLight
                                  : _radioValue ==
                                          widget.question['options'][index]
                                              ['text']
                                      ? FeedbackColors.primaryBlue
                                      : _correctAnswer == index &&
                                              widget.showAnswer
                                          ? FeedbackColors.positiveLight
                                          : FeedbackColors.black16),
                    ),
                    child: RadioListTile(
                      activeColor: _radioValue ==
                                  widget.question['options'][index]['text'] &&
                              _correctAnswer == index &&
                              widget.showAnswer
                          ? FeedbackColors.positiveLight
                          : _radioValue ==
                                      widget.question['options'][index]
                                          ['text'] &&
                                  _correctAnswer != index &&
                                  widget.showAnswer
                              ? FeedbackColors.negativeLight
                              : _radioValue ==
                                      widget.question['options'][index]['text']
                                  ? FeedbackColors.primaryBlue
                                  : _correctAnswer == index && widget.showAnswer
                                      ? FeedbackColors.positiveLight
                                      : FeedbackColors.black16,
                      groupValue: _radioValue,
                      title: HtmlWidget(
                        widget.question['options'][index]['text'],
                        textStyle: GoogleFonts.lato(
                          color: FeedbackColors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      value: widget.question['options'][index]['text'],
                      onChanged: (value) {
                        if (!widget.showAnswer) {
                          widget.parentAction({
                            'index': widget.question['questionId'],
                            // 'question': widget.question['question'],
                            'value': value,
                            'isCorrect': widget.question['options'][index]
                                ['isCorrect']
                          });
                          setState(() {
                            _radioValue = value;
                          });
                        }
                        // if (!widget.showAnswer && widget.answerGiven == '') {
                        // }
                      },
                      selected:
                          (_radioValue == widget.question['options'][index]),
                    ));
              },
            ),
          ],
        ));
  }
}
