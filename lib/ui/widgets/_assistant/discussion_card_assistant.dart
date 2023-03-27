import 'dart:io';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';
import './../../../util/faderoute.dart';
import './../../../ui/pages/_pages/discussion/discussion_filter_page.dart';

class DiscussCardAssistantView extends StatefulWidget {
  final data;
  final bool filterEnabled;
  DiscussCardAssistantView({this.data, this.filterEnabled = true});
  @override
  _DiscussCardAssistantViewState createState() =>
      new _DiscussCardAssistantViewState();
}

class _DiscussCardAssistantViewState extends State<DiscussCardAssistantView> {
  final dateNow = Moment.now();
  final service = HttpClient();
  String name;

  @override
  void initState() {
    super.initState();
    // _getUserName();
  }

  List<Widget> _getTags(List discussionTags) {
    List<Widget> tags = [];
    for (int i = 0; i < discussionTags.length; i++) {
      tags.add(InkWell(
        onTap: () => Navigator.push(
          context,
          FadeRoute(
              page: DiscussionFilterPage(
                  isCategory: false,
                  id: discussionTags[i]['score'],
                  title: discussionTags[i]['value'])),
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: 15.0,
            bottom: 5.0,
            right: 10,
          ),
          padding: EdgeInsets.fromLTRB(20, 5, 20, 6),
          decoration: BoxDecoration(
            color: AppColors.grey04,
            border: Border.all(color: AppColors.grey08),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(05),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(05)),
          ),
          child: Text(
            discussionTags[i]['value'],
            style: GoogleFonts.lato(
              color: AppColors.greys87,
              wordSpacing: 1.0,
              fontSize: 12.0,
            ),
          ),
        ),
      ));
    }
    return tags;
  }

  Future<String> _getUserName() async {
    if (widget.data.user['fullname'] != null) {
      name = widget.data.user['fullname'];
    } else {
      final _storage = FlutterSecureStorage();
      String firstName = await _storage.read(key: Storage.firstName);
      String lastName = await _storage.read(key: Storage.lastName);
      name = firstName + ' ' + lastName;
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserName(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          // print(MediaQuery.of(context).size.height.toString());
          if (snapshot.hasData && snapshot.data != null) {
            return Wrap(
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20),
                  child: Container(
                    width: 300,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 5.0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.data.user['fullname'] != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.positiveLight,
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(4.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Helper.getInitials(name),
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
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                name + ' . ',
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys87,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                (dateNow.from(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            widget.data
                                                                .timeStamp)))
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
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              widget.data.title != null
                                  ? widget.data.title
                                  : 'Question ?',
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
                            onTap: () => widget.filterEnabled
                                ? Navigator.push(
                                    context,
                                    FadeRoute(
                                        page: DiscussionFilterPage(
                                            isCategory: true,
                                            id: widget.data.category['cid'],
                                            title:
                                                widget.data.category['name'])),
                                  )
                                : false,
                            child: Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/category_image_1.svg',
                                    width: 25.0,
                                    height: 25.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      widget.data.category != null
                                          ? widget.data.category['name']
                                          : 'Category',
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
                          widget.data.tags != null
                              ? Container(
                                  height: 50,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      // physics: NeverScrollableScrollPhysics(),
                                      // shrinkWrap: true,
                                      children: _getTags(widget.data.tags)),
                                )
                              : Center(),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
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
                                        (widget.data.upVotes != null &&
                                                widget.data.downVotes != null)
                                            ? (widget.data.upVotes +
                                                        widget.data.downVotes)
                                                    .toString() +
                                                ' votes'
                                            : '0 votes',
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
                ),
              ],
            );
          } else {
            return Center();
          }
        });
  }
}
