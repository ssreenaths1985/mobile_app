import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants.dart';

class FeedbackForm extends StatefulWidget {
  FeedbackForm();
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final textController = TextEditingController();
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 137,
            width: 360,
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              focusNode: myFocusNode,
              keyboardType: TextInputType.multiline,
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Share your thoughts here',
              ),
              onTap: () {
                // _saveComment(context, widget.tid);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: FeedbackColors.textFieldBorder)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            'You are contributing to making karmayogi a better place for everyone!',
            style: GoogleFonts.lato(
              color: FeedbackColors.textFieldDescText,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
