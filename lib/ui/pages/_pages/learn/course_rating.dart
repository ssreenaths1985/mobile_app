import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/feedback/constants.dart';
// import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:karmayogi_mobile/ui/pages/index.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';

import '../../../../services/_services/learn_service.dart';

class CourseRating extends StatefulWidget {
  final String title;
  final String id;
  final String primaryType;
  final yourReview;
  final parentAction;
  final bool isFromContentPlayer;
  CourseRating(this.title, this.id, this.primaryType, this.yourReview,
      {this.parentAction, this.isFromContentPlayer = false});
  @override
  _CourseRatingState createState() => _CourseRatingState();
}

class _CourseRatingState extends State<CourseRating> {
  final LearnService learnService = LearnService();
  final _textController = TextEditingController();
  double _rating;
  double _previousRating;
  String _comment;
  bool _hasChanged = false;

  FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _getYourRatingAndReview();
  }

  _getYourRatingAndReview() async {
    if (widget.yourReview != null) {
      setState(() {
        _rating = widget.yourReview['rating'];
        _previousRating = widget.yourReview['rating'];
        _comment = widget.yourReview['review'];
        _textController.text = widget.yourReview['review'];
      });
    }
  }

  _saveRatingAndReview(id, type, rating, comment, context) async {
    Response response =
        await learnService.postCourseReview(id, type, rating, comment);
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        FadeRoute(page: CourseRatingSubmitted(widget.title)),
      );
      if (!widget.isFromContentPlayer) {
        widget.parentAction(true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonDecode(response.body)['params']['errmsg']),
          backgroundColor: AppColors.negativeLight,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.clear, color: AppColors.greys60),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            color: AppColors.greys87,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        // centerTitle: true,
      ),
      // Tab controller

      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        color: AppColors.lightBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Rate and review',
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Your review and feedback is valuable in creating a robust learning experience',
                style: GoogleFonts.lato(
                  color: AppColors.greys60,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'Rate this ${widget.primaryType.toLowerCase()}',
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    RatingBar.builder(
                      unratedColor: AppColors.grey16,
                      initialRating: _rating != null ? _rating : 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 50,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: FeedbackColors.ratedColor,
                      ),
                      onRatingUpdate: (rating) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (rating != _previousRating) {
                            setState(() {
                              _hasChanged = true;
                              _rating = rating;
                            });
                          }
                          if (rating == _previousRating) {
                            setState(() {
                              _hasChanged = false;
                            });
                          }
                        });
                      },
                    ),
                  ],
                )),
            _rating != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          'Give a review',
                          style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        width: 360,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: TextField(
                          // autofocus: true,
                          focusNode: myFocusNode,
                          // keyboardType: TextInputType.multiline,
                          controller: _textController,
                          maxLength: 200,
                          maxLines: 5,
                          decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText:
                                'Add a review for this ${widget.primaryType.toLowerCase()} (optional)',
                          ),
                          onChanged: (value) {
                            if (_comment != _textController.text) {
                              setState(() {
                                _hasChanged = true;
                              });
                            } else {
                              setState(() {
                                _hasChanged = false;
                              });
                            }
                          },
                          // onTap: () {
                          // },
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.grey16)),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 5),
                      //   child: Text(
                      //     '${_textController.text.length}/200',
                      //     style: GoogleFonts.lato(
                      //       color: AppColors.greys60,
                      //       fontSize: 12.0,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                : Center()
          ],
        ),
      )),
      bottomSheet: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: AppColors.grey08,
              blurRadius: 6.0,
              spreadRadius: 0,
              offset: Offset(
                0,
                -3,
              ),
            ),
          ]),
          child: ScaffoldMessenger(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Opacity(
                  opacity: _hasChanged && _rating != null ? 1 : 0.35,
                  child: TextButton(
                    // onPressed: null,
                    onPressed: _hasChanged && _rating != null
                        // ((_textController.text != null &&
                        //         _comment != null) &&
                        //     _textController.text.trim().length !=
                        //         _comment.trim().length)
                        ? () {
                            _saveRatingAndReview(widget.id, widget.primaryType,
                                _rating, _textController.text, context);
                          }
                        : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      // primary: Colors.white,
                      backgroundColor: AppColors.primaryThree,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: AppColors.grey16)),
                      // onSurface: Colors.grey,
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
