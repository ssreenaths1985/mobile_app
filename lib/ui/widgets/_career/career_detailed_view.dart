import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:simple_moment/simple_moment.dart';

class CareerDetailedView extends StatelessWidget {
  // final careerOpening;
  final title;
  final description;
  final viewCount;
  final tags;
  final postedTime;
  // tid: tid, userName: userName, title: title, uid: uid
  CareerDetailedView(
      {Key key,
      this.title,
      this.description,
      this.viewCount,
      this.tags,
      this.postedTime})
      : super(key: key);

  final dateNow = Moment.now();
  // List<Map> _careerTags = [
  //   {'value': 'tag1'},
  //   {'value': 'tag2'}
  // ];

  List<Widget> _getTags(List careerTags) {
    List<Widget> tags = [];
    if (careerTags != null)
      for (int i = 0; i < careerTags.length; i++) {
        tags.add(InkWell(
          // onTap: () => Navigator.push(
          //   context,
          //   FadeRoute(
          //       page: DiscussionFilterPage(
          //           isCategory: false,
          //           id: discussionTags[i]['score'],
          //           title: discussionTags[i]['value'])),
          // ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              height: 24,
              // margin: EdgeInsets.only(
              //   top: 15.0,
              //   bottom: 5.0,
              //   right: 10,
              // ),
              // padding: EdgeInsets.fromLTRB(20, 5, 20, 6),
              decoration: BoxDecoration(
                color: AppColors.grey04,
                border: Border.all(color: AppColors.grey08),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(04),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(04)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
                child: Text(
                  careerTags[i]['value'],
                  style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 1.0,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
          // child: Container(
          //   margin: EdgeInsets.only(
          //     top: 15.0,
          //     bottom: 5.0,
          //     right: 10,
          //   ),
          //   padding: EdgeInsets.fromLTRB(20, 5, 20, 6),
          //   decoration: BoxDecoration(
          //     color: AppColors.grey04,
          //     border: Border.all(color: AppColors.grey08),
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(05),
          //         bottomLeft: Radius.circular(20),
          //         bottomRight: Radius.circular(05)),
          //   ),
          //   child: Text(
          //     discussionTags[i]['value'],
          //     style: GoogleFonts.lato(
          //       color: AppColors.greys87,
          //       wordSpacing: 1.0,
          //       fontSize: 12.0,
          //     ),
          //   ),
          // ),
        ));
      }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar,
      appBar: AppBar(
        title: Text(
          'Back to \'Careers\'',
          style: GoogleFonts.montserrat(
            color: AppColors.greys60,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        // actions: [
        //   Container(
        //     child: IconButton(
        //         icon: Icon(
        //           Icons.search,
        //           color: AppColors.greys87,
        //         ),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         }),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              width: double.infinity,
              color: Colors.white,
              // margin: EdgeInsets.only(top: 8.0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        title,
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 1.0,
                          textStyle: TextStyle(height: 1.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
                      child: Text(
                        (dateNow.from(DateTime.fromMillisecondsSinceEpoch(
                                postedTime)))
                            .toString(),
                        style: GoogleFonts.lato(
                          color: AppColors.greys60,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 1.0,
                          textStyle: TextStyle(height: 1.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Text(
                        description,
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          wordSpacing: 1.0,
                          textStyle: TextStyle(height: 1.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        height: 24,
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            // physics: NeverScrollableScrollPhysics(),
                            // shrinkWrap: true,
                            children: _getTags(tags)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.trending_up),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  viewCount.toString() + ' views',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   '0 Comments',
                          //   style: GoogleFonts.lato(
                          //     color: AppColors.greys60,
                          //     fontWeight: FontWeight.w400,
                          //     fontSize: 14.0,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
