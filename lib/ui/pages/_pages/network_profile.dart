import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/index.dart';

class NetworkProfile extends StatelessWidget {
  final data;

  const NetworkProfile({Key key, this.data}) : super(key: key);

  static const route = '/networkProfile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.greys60),
      ),
      body: Column(
        children: [
          _opinion(),
        ],
      ),
    );
  }

  Widget _opinion() {
    return Container(
      width: double.infinity,
      height: 400.0,
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              data.discussTitle != null
                  ? data.discussTitle
                  : 'Sorry! No content found',
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              data.opinion != null ? data.opinion : 'Sorry! No content found',
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 5.0, left: 15.0),
              child: Row(
                children: [
                  Icon(Icons.category),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      data.categoryTitle != null
                          ? data.categoryTitle
                          : 'Sorry! No content found',
                      style: GoogleFonts.lato(
                          color: AppColors.primaryThree,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15.0),
              child: Text(
                data.userName != null
                    ? data.userName
                    : 'Sorry! No content found',
                style: GoogleFonts.lato(
                  color: AppColors.grey40,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.north,
                          color: AppColors.positiveLight,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            data.upvote != null ? data.upvote : '0',
                            style: GoogleFonts.lato(
                                color: AppColors.positiveLight,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Icon(Icons.south),
                        Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            data.downvote != null ? data.downvote : '0',
                            style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(
                            data.views != null ? data.views : '0 views',
                            style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15.0),
              child: Text(
                data.commentsCount != null ? data.commentsCount : '0 comments',
                style: GoogleFonts.lato(
                    color: AppColors.greys60,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }
}
