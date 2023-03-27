import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants.dart';

class CheckboxTypeQuestion extends StatefulWidget {
  final question;
  final int currentIndex;
  final answerGiven;
  final bool showAnswer;
  final ValueChanged<Map> parentAction;
  CheckboxTypeQuestion(this.question, this.currentIndex, this.answerGiven,
      this.showAnswer, this.parentAction);
  @override
  _CheckboxTypeQuestionState createState() => _CheckboxTypeQuestionState();
}

class _CheckboxTypeQuestionState extends State<CheckboxTypeQuestion> {
  Map<int, bool> isChecked = {
    1: false,
    2: false,
    3: false,
    4: false,
  };
  List selectedOptions = [];
  List<int> _correctAnswer = [2, 3];

  @override
  void initState() {
    super.initState();
    if (widget.question.answer != null) {
      selectedOptions = widget.question.answer;
      for (int i = 0; i < widget.question.options.length; i++) {
        if (selectedOptions.contains(widget.question.options[i]['value'])) {
          isChecked[i + 1] = true;
        }
      }
    }
    if (widget.answerGiven != null) {
      selectedOptions = widget.answerGiven;
      for (int i = 0; i < widget.question.options.length; i++) {
        if (selectedOptions.contains(widget.question.options[i]['value'])) {
          isChecked[i + 1] = true;
        }
      }
    }
  }

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
                    color: isChecked[index + 1] &&
                            _correctAnswer.contains(index) &&
                            widget.showAnswer
                        ? FeedbackColors.positiveLightBg
                        : isChecked[index + 1] &&
                                !_correctAnswer.contains(index) &&
                                widget.showAnswer
                            ? FeedbackColors.negativeLightBg
                            : _correctAnswer.contains(index) &&
                                    widget.showAnswer
                                ? FeedbackColors.positiveLightBg
                                : _correctAnswer.contains(index) &&
                                        widget.showAnswer
                                    ? FeedbackColors.negativeLightBg
                                    : isChecked[index + 1] &&
                                            _correctAnswer.contains(index) &&
                                            widget.showAnswer
                                        ? FeedbackColors.positiveLightBg
                                        : Colors.white,
                    borderRadius: BorderRadius.all(const Radius.circular(4.0)),
                    border: Border.all(
                      color: isChecked[index + 1] &&
                              _correctAnswer.contains(index) &&
                              widget.showAnswer
                          ? FeedbackColors.positiveLight
                          : isChecked[index + 1] &&
                                  !_correctAnswer.contains(index) &&
                                  widget.showAnswer
                              ? FeedbackColors.negativeLight
                              : _correctAnswer.contains(index) &&
                                      widget.showAnswer
                                  ? FeedbackColors.positiveLight
                                  : _correctAnswer.contains(index) &&
                                          widget.showAnswer
                                      ? FeedbackColors.negativeLight
                                      : isChecked[index + 1] &&
                                              _correctAnswer.contains(index) &&
                                              widget.showAnswer
                                          ? FeedbackColors.positiveLight
                                          : isChecked[index + 1]
                                              ? FeedbackColors.primaryBlue
                                              : FeedbackColors.black16,
                    ),
                  ),
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: _correctAnswer.contains(index) &&
                              widget.showAnswer
                          ? FeedbackColors.positiveLight
                          : !_correctAnswer.contains(index) && widget.showAnswer
                              ? FeedbackColors.negativeLight
                              : FeedbackColors.primaryBlue,
                      dense: true,
                      //font change
                      title: Text(
                        widget.question.options[index]['value'].toString(),
                        style: GoogleFonts.lato(
                          color: FeedbackColors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      value: isChecked[index + 1],
                      onChanged: (bool value) {
                        if (!widget.showAnswer) {
                          if (value) {
                            if (!selectedOptions.contains(
                                widget.question.options[index]['value'])) {
                              selectedOptions
                                  .add(widget.question.options[index]['value']);
                            }
                          } else {
                            if (selectedOptions.contains(
                                widget.question.options[index]['value'])) {
                              selectedOptions.remove(
                                  widget.question.options[index]['value']);
                            }
                          }
                          widget.parentAction({
                            'index': widget.question.id - 1,
                            'question': widget.question.question,
                            'value': selectedOptions
                          });
                          setState(() {
                            isChecked[index + 1] = value;
                          });
                        }
                      }),
                );
              },
            ),
          ],
        ));
  }
}
