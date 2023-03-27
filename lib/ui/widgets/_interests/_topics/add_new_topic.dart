import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/_constants/color_constants.dart';

class AddNewTopic extends StatefulWidget {
  final addToDesiredTopics;
  final List desiredTopics;
  const AddNewTopic({Key key, this.addToDesiredTopics, this.desiredTopics})
      : super(key: key);

  @override
  State<AddNewTopic> createState() => _AddNewTopicState();
}

class _AddNewTopicState extends State<AddNewTopic> {
  final TextEditingController _topicController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _topicController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: AlertDialog(
        // insetPadding: EdgeInsets.symmetric(vertical: 265),
        contentPadding: EdgeInsets.all(16),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create the topic',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontSize: 14.0,
                      letterSpacing: 0.25,
                      height: 1.429,
                      fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Focus(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        // focusNode: _firstNameFocus,
                        // onFieldSubmitted: (term) {
                        //   _fieldFocusChange(
                        //       context, _firstNameFocus, _middleNameFocus);
                        // },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (widget.desiredTopics.contains(value.trim())) {
                            return 'Topic already exist';
                          } else {
                            return null;
                          }
                        },

                        controller: _topicController,
                        style: GoogleFonts.lato(fontSize: 14.0),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          // labelText: "Add a role",
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey16)),
                          hintText: 'Type here',
                          hintStyle: GoogleFonts.lato(
                              color: AppColors.grey40,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.primaryThree, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.23,
                      margin: EdgeInsets.only(right: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: AppColors.primaryThree,
                          primary: Colors.white,
                          minimumSize: const Size.fromHeight(40), // NEW
                          side: BorderSide(
                              width: 1, color: AppColors.primaryThree),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.lato(
                              height: 1.429,
                              letterSpacing: 0.5,
                              fontSize: 14,
                              color: AppColors.primaryThree,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryThree,
                          minimumSize: const Size.fromHeight(40), // NEW
                          side: BorderSide(
                              width: 1, color: AppColors.primaryThree),
                        ),
                        onPressed: () {
                          if ((_topicController.text.isNotEmpty &&
                                  _topicController.text.trim().length > 0) &&
                              !widget.desiredTopics
                                  .contains(_topicController.text.trim())) {
                            widget.addToDesiredTopics(_topicController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Add topic',
                          style: GoogleFonts.lato(
                              height: 1.429,
                              letterSpacing: 0.5,
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
