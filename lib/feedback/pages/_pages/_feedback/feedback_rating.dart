// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import './../../../../feedback/feedback_db_helper.dart';
import './../../../../feedback/rating_modal.dart';
import './../../../../feedback/constants.dart';

class FeedbackRating extends StatefulWidget {
  final ValueChanged<int> parentAction;
  FeedbackRating({Key key, this.parentAction}) : super(key: key);
  @override
  _FeedbackRatingState createState() => _FeedbackRatingState();
}

class _FeedbackRatingState extends State<FeedbackRating> {
  int _rating = 1;
  String _userId;
  double _userRecentRating = 0.0;
  @override
  void initState() {
    super.initState();
    getUserId();
    // getUserRecentRating();
  }

  Future<dynamic> getUserRecentRating() async {
    List _userRatings =
        await FeedbackDbHelper.getData(FeedbackDatabase.userFeedbackTable);
    // print(_userRatings);
    if (_userRatings.length > 0) {
      var rating = _userRatings[_userRatings.length - 1]['user_rating'];
      _userRecentRating = double.parse('$rating');
    }
    return _userRecentRating;
  }

  Future<void> getUserId() async {
    final _storage = FlutterSecureStorage();
    _userId = await _storage.read(key: Storage.wid);
  }

  _setRating(double rating) {
    var data = Rating(userId: _userId, rating: rating);
    FeedbackDbHelper.insert(FeedbackDatabase.userFeedbackTable, data.toMap());
    setState(() {
      _rating = rating.ceil();
    });
    if (_rating > 3) {
      return showDialog(
          context: context,
          builder: (context) => Stack(
                children: [
                  Positioned(
                      child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        height: 185.0,
                        color: Colors.white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  child: Text(
                                    'Would you like to rate us on PlayStore?',
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 15),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(false),
                                  child: roundedButton('No, may be later',
                                      Colors.white, FeedbackColors.primaryBlue),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(false),
                                  child: roundedButton('Yes, why not!',
                                      FeedbackColors.primaryBlue, Colors.white),
                                ),
                              ),
                            ])),
                  ))
                ],
              ));
    } else {
      widget.parentAction(1);
    }
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        border: bgColor == Colors.white
            ? Border.all(color: FeedbackColors.black40)
            : Border.all(color: bgColor),
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.montserrat(
            decoration: TextDecoration.none,
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
    return loginBtn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getUserRecentRating(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    children: [
                      _rating == 1
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 130.0, bottom: 20.0),
                              child: SvgPicture.asset(
                                FeedbackSmileys.oneStar,
                                height: 94,
                                width: 94,
                              ),
                            )
                          : Center(),
                      _rating == 2
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 130.0, bottom: 20.0),
                              child: SvgPicture.asset(
                                FeedbackSmileys.twoStar,
                                height: 94,
                                width: 94,
                              ),
                            )
                          : Center(),
                      _rating == 3
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 130.0, bottom: 20.0),
                              child: SvgPicture.asset(
                                FeedbackSmileys.threeStar,
                                height: 94,
                                width: 94,
                              ),
                            )
                          : Center(),
                      _rating == 4
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 130.0, bottom: 20.0),
                              child: SvgPicture.asset(
                                FeedbackSmileys.fourStar,
                                height: 94,
                                width: 94,
                              ),
                            )
                          : Center(),
                      _rating == 5
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 130.0, bottom: 20.0),
                              child: SvgPicture.asset(
                                FeedbackSmileys.fiveStar,
                                height: 94,
                                width: 94,
                              ),
                            )
                          : Center(),
                      Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 16),
                          child: Text(
                            'Rate your experience',
                            style: GoogleFonts.montserrat(
                              color: FeedbackColors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      RatingBar.builder(
                        unratedColor: FeedbackColors.unRatedColor,
                        initialRating: _userRecentRating,
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
                            _setRating(rating);
                          });
                        },
                      ),
                    ],
                  ),
                );
                // StarRating()
              } else {
                return Center();
              }
            }));
  }
}
