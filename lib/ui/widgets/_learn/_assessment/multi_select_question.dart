import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import './../../../../feedback/constants.dart';

class MultiSelectQuestion extends StatefulWidget {
  final question;
  final int currentIndex;
  final answerGiven;
  final bool showAnswer;
  final ValueChanged<Map> parentAction;
  MultiSelectQuestion(this.question, this.currentIndex, this.answerGiven,
      this.showAnswer, this.parentAction);
  @override
  _MultiSelectQuestionQuestionState createState() =>
      _MultiSelectQuestionQuestionState();
}

class _MultiSelectQuestionQuestionState extends State<MultiSelectQuestion> {
  Map<int, bool> isChecked = {
    1: false,
    2: false,
    3: false,
    4: false,
  };
  List selectedOptions = [];
  List<int> _correctAnswer = [];

  @override
  void initState() {
    super.initState();
    if (widget.question['options'].length > 4) {
      for (var i = 5; i < widget.question['options'].length + 1; i++) {
        final entry = <int, bool>{i: false};
        isChecked.addEntries(entry.entries);
      }
    }
    if (widget.answerGiven != null) {
      selectedOptions = widget.answerGiven;
      for (int i = 0; i < widget.question['options'].length; i++) {
        if (selectedOptions
            .contains(widget.question['options'][i]['optionId'])) {
          isChecked[i + 1] = true;
        }
        if (widget.question['options'][i]['isCorrect']) {
          _correctAnswer.add(i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height + 100,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: HtmlWidget(
                widget.question['question'],
                textStyle: GoogleFonts.lato(
                  color: FeedbackColors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
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
                        widget.question['options'][index]['text'],
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
                            if (!selectedOptions.contains(widget
                                .question['options'][index]['optionId'])) {
                              selectedOptions.add(widget.question['options']
                                  [index]['optionId']);
                            }
                          } else {
                            if (selectedOptions.contains(widget
                                .question['options'][index]['optionId'])) {
                              selectedOptions.remove(widget.question['options']
                                  [index]['optionId']);
                            }
                          }
                          widget.parentAction({
                            'index': widget.question['questionId'],
                            'isCorrect': widget.question['options'][index]
                                ['isCorrect'],
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
