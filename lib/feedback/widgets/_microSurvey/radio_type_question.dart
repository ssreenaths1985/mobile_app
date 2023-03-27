import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants.dart';

class RadioTypeQuestion extends StatefulWidget {
  final question;
  final int currentIndex;
  final answerGiven;
  final bool showAnswer;
  final ValueChanged<Map> parentAction;
  RadioTypeQuestion(this.question, this.currentIndex, this.answerGiven,
      this.showAnswer, this.parentAction);
  @override
  _RadioTypeQuestionState createState() => _RadioTypeQuestionState();
}

class _RadioTypeQuestionState extends State<RadioTypeQuestion> {
  String _radioValue = '';
  int _correctAnswer = 2;

  @override
  void initState() {
    super.initState();
    // print('qa: ' + widget.question.answer.toString());
    _radioValue = widget.answerGiven;
    // _radioValue = widget.question.answer != null
    //     ? widget.question.answer
    //     : widget.answerGiven;
  }

  @override
  Widget build(BuildContext context) {
    // _radioValue = widget.answerGiven;
    return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('${widget.currentIndex}, ${widget.answerGiven}, $_radioValue'),
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                widget.question.question,
                style: GoogleFonts.lato(
                  color: FeedbackColors.black87,
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
                      color: _radioValue ==
                                  widget.question.options[index]['value'] &&
                              _correctAnswer == index &&
                              widget.showAnswer
                          ? FeedbackColors.positiveLightBg
                          : _radioValue ==
                                      widget.question.options[index]['value'] &&
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
                                      widget.question.options[index]['value'] &&
                                  _correctAnswer == index &&
                                  widget.showAnswer
                              ? FeedbackColors.positiveLight
                              : _radioValue ==
                                          widget.question.options[index]
                                              ['value'] &&
                                      _correctAnswer != index &&
                                      widget.showAnswer
                                  ? FeedbackColors.negativeLight
                                  : _radioValue ==
                                          widget.question.options[index]
                                              ['value']
                                      ? FeedbackColors.primaryBlue
                                      : _correctAnswer == index &&
                                              widget.showAnswer
                                          ? FeedbackColors.positiveLight
                                          : FeedbackColors.black16),
                    ),
                    child: RadioListTile(
                      selected: true,
                      activeColor: FeedbackColors.primaryBlue,
                      groupValue: _radioValue,
                      title: Text(
                        widget.question.options[index]['value'].toString(),
                        style: GoogleFonts.lato(
                          color: FeedbackColors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      value: widget.question.options[index]['value'].toString(),
                      onChanged: (value) {
                        if (!widget.showAnswer) {
                          widget.parentAction({
                            'index': widget.question.id - 1,
                            'question': widget.question.question,
                            'value': value
                          });
                          setState(() {
                            _radioValue = value;
                          });
                        }
                      },
                    ));
              },
            ),
          ],
        ));
  }
}
