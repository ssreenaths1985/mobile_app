import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../respositories/index.dart';
import './../../../../ui/pages/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../util/faderoute.dart';
import './../../../../constants/_constants/color_constants.dart';
import './../../../../localization/index.dart';

// ignore: must_be_immutable
class SavedPostsPage extends StatefulWidget {
  String currentPage;

  SavedPostsPage({this.currentPage});

  @override
  _SavedPostsPageState createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  final service = HttpClient();
  int pageNo = 1;
  int pageCount;
  int currentPage;

  List _data = [];
  RouteSettings settings;

  @override
  void initState() {
    super.initState();
    _getPageDetails();
  }

  /// Get recent discussions
  Future<void> _getSavedDiscussions() async {
    try {
      _data.addAll(await Provider.of<DiscussRepository>(context, listen: false)
          .getSavedDiscussions(pageNo));
      _data = _data.toSet().toList();
    } catch (err) {
      return err;
    }
  }

  /// Get pageDetails
  Future<void> _getPageDetails() async {
    var pageDetails;
    try {
      pageDetails = await Provider.of<DiscussRepository>(context, listen: false)
          .getSavedDiscussionPageCount(pageNo);
      setState(() {
        pageCount = pageDetails.pageCount;
      });
    } catch (err) {
      return err;
    }
  }

  /// Navigate to discussion detail
  _navigateToDetail(tid, userName, title, uid) {
    Navigator.push(
      context,
      FadeRoute(
        page: ChangeNotifierProvider<DiscussRepository>(
          create: (context) => DiscussRepository(),
          child: DiscussionPage(
              tid: tid, userName: userName, title: title, uid: uid),
        ),
      ),
    );
  }

  /// Load cards on scroll
  _loadMore() {
    if (pageNo < pageCount) {
      setState(() {
        pageNo = pageNo + 1;
      });
      // _getSavedDiscussions();
    }
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
      child: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: _getSavedDiscussions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData != null) {
              // print('Loading cards...');
            }
            return Wrap(
              alignment: WrapAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.all(15.0),
                //   child: Text(
                //     'Recent',
                //     style: GoogleFonts.lato(
                //       color: AppColors.greys87,
                //       fontSize: 14.0,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
                Container(
                  height: 5.0,
                ),
                Wrap(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 200.0),
                      child: Wrap(children: [
                        for (int i = 0; i < _data.length; i++)
                          InkWell(
                            onTap: () {
                              _navigateToDetail(
                                  _data[i].tid,
                                  _data[i].user['fullname'],
                                  _data[i].title,
                                  _data[i].user['uid']);
                            },
                            child: _data.length > 0
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    child: DiscussCardView(
                                      data: _data[i],
                                    ))
                                : Center(
                                    child: Text(''),
                                  ),
                          ),
                        _data.length == 0
                            ? Container(
                                padding: const EdgeInsets.only(top: 100),
                                child: Center(
                                    child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/img/discussion-empty.svg',
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                          EnglishLang.noPosts,
                                          style: GoogleFonts.lato(
                                            color: AppColors.greys60,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        )),
                                  ],
                                )))
                            : Center()
                      ]),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
