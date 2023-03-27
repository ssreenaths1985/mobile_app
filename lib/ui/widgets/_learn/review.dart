import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:simple_moment/simple_moment.dart';
import '../../../services/_services/learn_service.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';
// import 'dart:developer' as developer;

class Review extends StatefulWidget {
  final String name;
  final double rating;
  final String description;
  final int updatedOn;
  final String courseId;
  final String primaryCategory;
  final String userId;

  Review(
      {this.name,
      this.rating,
      this.description,
      this.updatedOn,
      this.courseId,
      this.primaryCategory,
      this.userId});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final LearnService learnService = LearnService();
  final dateNow = Moment.now();
  bool _isShowReply = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getReplyComments() async {
    final response = await learnService.getCourseReviewReply(
        widget.courseId, widget.primaryCategory, widget.userId);
    // developer.log(response['comment'].toString());
    return response['comment'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5.0, top: 4),
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // decoration: BoxDecoration(
            //   border: Border(
            //     bottom:
            //         BorderSide(color: AppColors.lightBackground, width: 2.0),
            //   ),
            // ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 10),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.positiveLight,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(4.0)),
                    ),
                    child: Center(
                      child: Text(Helper.getInitials(widget.name),
                          style: GoogleFonts.lato(color: Colors.white)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  widget.rating.toString(),
                                  style: GoogleFonts.lato(
                                    color: AppColors.primaryOne,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: widget.rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: AppColors.primaryOne,
                                ),
                                onRatingUpdate: (rating) {
                                  // print(rating);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  widget.updatedOn != null
                                      ? dateNow
                                          .from(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  widget.updatedOn))
                                          .toString()
                                      : 'Invalid date',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              widget.description,
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: _getReplyComments(),
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot) {
                              return (snapshot.data != null &&
                                      snapshot.data != '')
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isShowReply = !_isShowReply;
                                              });
                                            },
                                            child: Text(
                                              !_isShowReply
                                                  ? 'View reply'
                                                  : 'Hide reply',
                                              style: GoogleFonts.lato(
                                                color: AppColors.primaryThree,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                            visible: _isShowReply,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Text(snapshot.data),
                                              ),
                                            )),
                                      ],
                                    )
                                  : Center();
                            }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
