import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import './../../../util/helper.dart';
import '../../../constants/index.dart';

class RecentDiscussions extends StatelessWidget {
  final data;

  final dateNow = Moment.now();

  RecentDiscussions({this.data});

  @override
  Widget build(BuildContext context) {
    return data.posts.length > 1
        ? Wrap(
            children: [
              for (int i = 1; i < data.posts.length; i++)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 5.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: CircleAvatar(
                                backgroundColor: AppColors.positiveLight,
                                child: Center(
                                  child: Text(
                                    data.posts[i] != null
                                        ? Helper.getInitials(
                                            data.posts[i]['user']['fullname'])
                                        : 'UN',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    data.posts[i] != null
                                        ? data.posts[i]['user']['fullname']
                                        : 'Username',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      (dateNow.from(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  data.posts[i]['timestamp'])))
                                          .toString(),
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                          child: HtmlWidget(data.posts[i]['content'],
                              textStyle: TextStyle(
                                fontFamily: 'lato',
                                // padding: EdgeInsets.all(0),
                                // margin: EdgeInsets.only(left: 0),
                                wordSpacing: 1.0,
                                color: AppColors.greys87,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/img/up_vote.svg',
                                              width: 25.0,
                                              height: 25.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.0),
                                              child: Text(
                                                data.posts[i] != null
                                                    ? (data.posts[i]['upvotes'])
                                                        .toString()
                                                    : '0',
                                                style: GoogleFonts.lato(
                                                    color:
                                                        // AppColors.positiveLight,
                                                        AppColors.greys60,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 25.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/img/down_vote.svg',
                                              width: 25.0,
                                              height: 25.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.0),
                                              child: Text(
                                                data.posts[i] != null
                                                    ? (data.posts[i]
                                                            ['downvotes'])
                                                        .toString()
                                                    : '0',
                                                style: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          )
        : Center(
            child: Text(''),
          );
  }
}
