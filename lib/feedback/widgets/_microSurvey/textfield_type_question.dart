import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants.dart';

class TextFieldTypeQuestion extends StatefulWidget {
  final question;
  final int currentIndex;
  final answerGiven;
  final ValueChanged<Map> parentAction;

  TextFieldTypeQuestion(
      this.question, this.currentIndex, this.answerGiven, this.parentAction);
  @override
  _TextFieldTypeQuestionState createState() => _TextFieldTypeQuestionState();
}

class _TextFieldTypeQuestionState extends State<TextFieldTypeQuestion> {
  final textController = TextEditingController();
  int _currentIndex;
  Color borderColor = FeedbackColors.textFieldBorder;

  @override
  void initState() {
    super.initState();
    // if (widget.question.answer != null) {
    //   textController.text = widget.question.answer;
    // }
  }

  _reloadData() {
    textController.text = '';
    if (widget.question.answer != null) {
      textController.text = widget.question.answer;
    }
    if (widget.answerGiven != null) {
      textController.text = widget.answerGiven;
    }
    _currentIndex = widget.currentIndex;
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex != widget.currentIndex) {
      _reloadData();
      // widget.parentAction({
      //   'index': widget.question.id - 1,
      //   'question': widget.question.question,
      //   'value': textController.text
      // });
    }

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
            Container(
              height:
                  widget.question.fieldType == QuestionType.textarea ? 137 : 50,
              width: 360,
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                // autofocus: true,
                keyboardType: widget.question.fieldType == QuestionType.textarea
                    ? TextInputType.multiline
                    : widget.question.fieldType == QuestionType.email
                        ? TextInputType.emailAddress
                        : (widget.question.fieldType == QuestionType.numeric ||
                                widget.question.fieldType == QuestionType.date)
                            ? TextInputType.number
                            : TextInputType.text,
                textInputAction: TextInputAction.done,
                textCapitalization:
                    widget.question.fieldType == QuestionType.textarea
                        ? TextCapitalization.sentences
                        : TextCapitalization.none,
                controller: textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // hintText: 'Share your thoughts here',
                ),
                onTap: () => setState(() {
                  borderColor = FeedbackColors.primaryBlue;
                }),
                onEditingComplete: () {
                  setState(() {
                    borderColor = FeedbackColors.textFieldBorder;
                  });
                  FocusScope.of(context).unfocus();
                },
                onChanged: (text) {
                  // textController.text = text.split('').reversed.join('');
                  widget.parentAction({
                    'index': widget.question.id - 1,
                    'question': widget.question.question,
                    'value': text
                  });
                },
              ),
              decoration: BoxDecoration(
                  color: Colors.white, border: Border.all(color: borderColor)),
            ),
          ],
        ));
  }
}
