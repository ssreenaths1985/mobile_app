import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants.dart';

class BooleanTypeQuestion extends StatefulWidget {
  final question;
  final int currentIndex;
  final answerGiven;
  final bool showAnswer;
  final ValueChanged<Map> parentAction;
  BooleanTypeQuestion(this.question, this.currentIndex, this.answerGiven,
      this.showAnswer, this.parentAction);
  @override
  _BooleanTypeQuestionState createState() => _BooleanTypeQuestionState();
}

class _BooleanTypeQuestionState extends State<BooleanTypeQuestion> {
  String _radioValue = '';
  int _correctAnswer = 2;
  List _options = [
    {'value': 'True', 'key': 'true'},
    {'value': 'False', 'key': 'false'}
  ];

  @override
  void initState() {
    super.initState();
    // _radioValue =  widget.answerGiven;
    _radioValue = widget.question.answer != null
        ? widget.question.answer
        : widget.answerGiven;
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
              itemCount: _options.length,
              itemBuilder: (context, index) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    // padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: _radioValue == _options[index]['value'] &&
                              _correctAnswer == index &&
                              widget.showAnswer
                          ? FeedbackColors.positiveLightBg
                          : _radioValue == _options[index]['value'] &&
                                  _correctAnswer != index &&
                                  widget.showAnswer
                              ? FeedbackColors.negativeLightBg
                              : _correctAnswer == index && widget.showAnswer
                                  ? FeedbackColors.positiveLightBg
                                  : Colors.white,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(4.0)),
                      border: Border.all(
                          color: _radioValue == _options[index]['value'] &&
                                  _correctAnswer == index &&
                                  widget.showAnswer
                              ? FeedbackColors.positiveLight
                              : _radioValue == _options[index]['value'] &&
                                      _correctAnswer != index &&
                                      widget.showAnswer
                                  ? FeedbackColors.negativeLight
                                  : _radioValue == _options[index]['value']
                                      ? FeedbackColors.primaryBlue
                                      : _correctAnswer == index &&
                                              widget.showAnswer
                                          ? FeedbackColors.positiveLight
                                          : FeedbackColors.black16),
                    ),
                    child: RadioListTile(
                      activeColor: FeedbackColors.primaryBlue,
                      groupValue: _radioValue,
                      title: Text(
                        _options[index]['value'],
                        style: GoogleFonts.lato(
                          color: FeedbackColors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      value: _options[index]['value'],
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
