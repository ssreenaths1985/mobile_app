import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import './../../../../respositories/index.dart';
import './../../../../util/faderoute.dart';
import './../../../../ui/pages/index.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class DiscussionFilterPage extends StatefulWidget {
  final bool isCategory;
  final int id;
  final String title;
  DiscussionFilterPage({this.isCategory, this.id, this.title});

  @override
  _DiscussionFilterPageState createState() {
    return _DiscussionFilterPageState();
  }
}

class _DiscussionFilterPageState extends State<DiscussionFilterPage> {
  int pageNo = 1;
  int pageCount = 1;
  int currentPage;
  List<dynamic> _discussions = [];
  @override
  void initState() {
    super.initState();
    _getFilteredDiscussions();
    _getPageDetails();
  }

  Future<dynamic> _getFilteredDiscussions() async {
    try {
      if (widget.isCategory) {
        if (pageNo == 1) {
          _discussions =
              await Provider.of<DiscussRepository>(context, listen: false)
                  .getFilteredDiscussionsByCategory(widget.id, pageNo);
        } else {
          _discussions.addAll(
              await Provider.of<DiscussRepository>(context, listen: false)
                  .getFilteredDiscussionsByCategory(widget.id, pageNo));
        }
      } else {
        if (pageNo == 1) {
          _discussions =
              await Provider.of<DiscussRepository>(context, listen: false)
                  .getFilteredDiscussionsByTag(widget.title, pageNo);
        } else {
          _discussions.addAll(
              await Provider.of<DiscussRepository>(context, listen: false)
                  .getFilteredDiscussionsByTag(widget.title, pageNo));
        }
      }
    } catch (err) {
      return err;
    }
    return _discussions;
  }

  /// Get recent page details
  Future<void> _getPageDetails() async {
    var pageDetails;
    try {
      if (widget.isCategory) {
        pageDetails =
            await Provider.of<DiscussRepository>(context, listen: false)
                .getDiscussionByCategoryPageCount(widget.id, pageNo);
      } else {
        pageDetails =
            await Provider.of<DiscussRepository>(context, listen: false)
                .getDiscussionByTagPageCount(widget.title, pageNo);
      }
    } catch (err) {
      return err;
    }
    setState(() {
      pageCount = pageDetails.pageCount;
    });
  }

  /// Navigate to discussion detail
  _navigateToDetail(tid, userName, title, uid) {
    Navigator.push(
      context,
      FadeRoute(
        page: ChangeNotifierProvider<DiscussRepository>(
          create: (context) => DiscussRepository(),
          child: DiscussionPage(
            tid: tid,
            userName: userName,
            title: title,
            uid: uid,
          ),
        ),
      ),
    );
  }

  /// Load cards on scroll
  _loadMore() {
    if (pageNo <= pageCount + 1) {
      setState(() {
        pageNo = pageNo + 1;
      });
      _getFilteredDiscussions();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMore();
          }
        },
        child: Scaffold(
            appBar: AppBar(
                titleSpacing: 0,
                // leading: IconButton(
                //   icon: Icon(Icons.clear, color: AppColors.greys60),
                //   onPressed: () => Navigator.of(context).pop(),
                // ),
                title: Row(children: [
                  Text(
                    'Discussions',
                    style: GoogleFonts.montserrat(
                      color: AppColors.greys87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // centerTitle: true,
                  Spacer(),
                  widget.isCategory
                      ? Row(children: [
                          SvgPicture.asset(
                            'assets/img/category_image_1.svg',
                            width: 35.0,
                            height: 35.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              widget.title,
                              style: GoogleFonts.montserrat(
                                color: AppColors.greys87,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ])
                      : Container(
                          margin: EdgeInsets.only(
                            // top: 10.0,
                            right: 15.0,
                          ),
                          padding: EdgeInsets.fromLTRB(20, 5, 15, 6),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            border: Border.all(color: AppColors.grey08),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(05),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(05)),
                          ),
                          child: Wrap(
                            children: [
                              Text(
                                widget.title,
                                style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 1, 4, 2),
                                  child: Text(
                                    widget.id.toString(),
                                    style: GoogleFonts.lato(
                                      color: AppColors.primaryThree,
                                      // wordSpacing: 1.0,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ))
                            ],
                          ),
                        )
                ])),
            // Tab controller

            body: FutureBuilder(
                future: _getFilteredDiscussions(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.only(bottom: 200.0),
                            child: Wrap(
                              children: [
                                for (int i = 0; i < _discussions.length; i++)
                                  InkWell(
                                    onTap: () {
                                      _navigateToDetail(
                                          _discussions[i].tid,
                                          _discussions[i].user['fullname'],
                                          _discussions[i].title,
                                          _discussions[i].user['uid']);
                                    },
                                    child: DiscussCardView(
                                      data: _discussions[i],
                                      filterEnabled: true,
                                    ),
                                  ),
                              ],
                            )));
                  } else {
                    return Center();
                  }
                })));
  }
}
