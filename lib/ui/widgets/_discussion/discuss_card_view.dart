import 'dart:io';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';
// import './../../../util/faderoute.dart';
import './../../../ui/widgets/index.dart';

class DiscussCardView extends StatefulWidget {
  final data;
  final bool filterEnabled;
  final bool showVideo;
  DiscussCardView(
      {this.data, this.filterEnabled = true, this.showVideo = false});
  @override
  _DiscussCardViewState createState() => new _DiscussCardViewState();
}

class _DiscussCardViewState extends State<DiscussCardView> {
  final dateNow = Moment.now();
  final service = HttpClient();
  String _name;

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
                  discussionTags[i]['value'],
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

  Future<String> _getUserName() async {
    if (widget.data.user['fullname'] != null &&
        widget.data.user['fullname'] != '') {
      _name = widget.data.user['fullname'];
    } else if (widget.data.user['displayname'] != null &&
        widget.data.user['displayname'] != '') {
      _name = widget.data.user['displayname'];
      // final _storage = FlutterSecureStorage();
      // String firstName = await _storage.read(key: 'firstName');
      // String lastName = await _storage.read(key: 'lastName');
      // _name = firstName + ' ' + lastName;
      // _name = 'Varsha Mahuli';
    } else {
      _name = 'Unknown user';
    }
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserName(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          // print(MediaQuery.of(context).size.height.toString());
          if (snapshot.data != null) {
            return Wrap(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  // margin: EdgeInsets.only(top: 8.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _name != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 24,
                                    width: 24,
                                    margin: const EdgeInsets.only(
                                      left: 16,
                                      // right: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.positiveLight,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(4.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        Helper.getInitialsNew(_name),
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      // alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(
                                        left: 12.0,
                                      ),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              _name + ' . ',
                                              style: GoogleFonts.lato(
                                                color: AppColors.greys87,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              (dateNow.from(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          widget
                                                              .data.timeStamp)))
                                                  .toString(),
                                              style: GoogleFonts.lato(
                                                color: AppColors.greys60,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ])),
                                ],
                              )
                            : Center(),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 12.0, left: 16, right: 16),
                          child: Text(
                            widget.data.title,
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 1.0,
                              textStyle: TextStyle(height: 1.5),
                            ),
                          ),
                        ),
                        InkWell(
                          // onTap: () => widget.filterEnabled
                          //     ? Navigator.push(
                          //         context,
                          //         FadeRoute(
                          //             page: DiscussionFilterPage(
                          //                 isCategory: true,
                          //                 id: widget.data.category['cid'],
                          //                 title: widget.data.category['name'])),
                          //       )
                          //     : false,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.0, left: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/img/category_image_1.svg',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: HtmlWidget(
                                    widget.data.category != null
                                        ? widget.data.category['name']
                                        : 'Category',
                                    textStyle: GoogleFonts.lato(
                                        color: AppColors.primaryThree,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        widget.data.tags != null
                            ? widget.data.tags.length > 0
                                ? Padding(
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
                                          children: _getTags(widget.data.tags)),
                                    ),
                                  )
                                : Center()
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
                          padding:
                              EdgeInsets.only(left: 16, right: 16, top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/swap_vert.svg',
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      (widget.data.upVotes != null &&
                                              widget.data.downVotes != null)
                                          ? (widget.data.upVotes +
                                                      widget.data.downVotes)
                                                  .toString() +
                                              ' votes'
                                          : '0 votes',
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
            );
          } else {
            return Center();
          }
        });
  }
}
