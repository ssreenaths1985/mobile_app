import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
// import './../../../util/faderoute.dart';
import './../../../ui/widgets/index.dart';

class DiscussCarouselCard extends StatefulWidget {
  final String userName;
  final String initials;
  final String time;
  final String discussionName;
  final int votes;
  final int comments;
  final List tags;
  final bool showVideo;
  final bool showCarousel;

  DiscussCarouselCard(
      {this.userName,
      this.initials,
      this.time,
      this.discussionName,
      this.votes,
      this.comments,
      this.tags,
      this.showVideo,
      this.showCarousel});
  @override
  _DiscussCarouselCardState createState() => new _DiscussCarouselCardState();
}

class _DiscussCarouselCardState extends State<DiscussCarouselCard> {
  @override
  void initState() {
    super.initState();
    // print(widget.data.tags.toString());
    // _getUserName();
  }

  List<Widget> _getTags(List discussionTags) {
    List<Widget> tags = [];
    if (discussionTags != null)
      for (int i = 0; i < discussionTags.length; i++) {
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
                  discussionTags[i],
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
        ));
      }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          margin: EdgeInsets.only(top: 5.0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    // alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: 16.0,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: AppColors.positiveLight,
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(4.0)),
                              ),
                              child: Center(
                                child: Text(widget.initials,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ),
                          ),
                          Text(
                            widget.userName + ' . ',
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.time,
                            style: GoogleFonts.lato(
                              color: AppColors.greys60,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ])),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    widget.discussionName,
                    style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1.0,
                      textStyle: TextStyle(height: 1.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        // physics: NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        children: _getTags(widget.tags)),
                  ),
                ),
                widget.showCarousel
                    ? Container(height: 279, child: CarouselList())
                    : Center(),
                widget.showVideo
                    ? Container(
                        height: 240,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 15.0),
                        child: CourseVideoPlayer(
                            course: {},
                            identifier: '',
                            fileUrl:
                                'https://igot.blob.core.windows.net/content/content/do_1132664124849192961213/artifact/do_1132664124849192961213_1619435180040_agile1619435179072.mp4',
                            mimeType: ''))
                    : Center(),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/img/swap_vert.svg',
                            width: 25.0,
                            height: 25.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              (widget.votes.toString() + ' votes'),
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w400,
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
    );
  }
}
