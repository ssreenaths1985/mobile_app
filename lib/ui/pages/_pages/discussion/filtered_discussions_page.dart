import 'dart:async';
import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/models/index.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../constants/index.dart';
import './../../../../respositories/index.dart';
import './../../../../ui/pages/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../util/faderoute.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class FilteredDiscussionsPage extends StatefulWidget {
  final bool isCategory;
  final int id;
  final String title;
  final String backToTitle;

  FilteredDiscussionsPage(
      {this.isCategory, this.id, this.title, this.backToTitle = ''});
  @override
  _FilteredDiscussionsPageState createState() =>
      _FilteredDiscussionsPageState();
}

class _FilteredDiscussionsPageState extends State<FilteredDiscussionsPage> {
  final TelemetryService telemetryService = TelemetryService();

  int pageNo = 1;
  int pageCount = 1;
  int currentPage;
  List<dynamic> _discussions = [];

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String pageIdentifier;
  String pageUrl;
  int _start = 0;
  List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _getFilteredDiscussions();
    _getPageDetails();

    if (_start == 0) {
      if (widget.isCategory) {
        pageIdentifier = TelemetryPageIdentifier.filterByCategoryPageId;
        pageUrl = TelemetryPageIdentifier.filterByCategoryPageUri
            .replaceAll(':categoryId', widget.id.toString());
        pageUrl = pageIdentifier;
      } else {
        pageIdentifier = TelemetryPageIdentifier.filterByTagsPageId;
        pageUrl = TelemetryPageIdentifier.filterByTagsPageUri
            .replaceAll(':tagName', widget.title);
      }
      allEventsData = [];
      _generateTelemetryData();
    }
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData1 = Telemetry.getImpressionTelemetryEvent(
      deviceIdentifier,
      userId,
      departmentId,
      pageIdentifier,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      pageUrl,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
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

  void _generateInteractTelemetryData(String contentId) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.discussionCard);
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  /// Navigate to discussion detail
  _navigateToDetail(tid, userName, title, uid) {
    _generateInteractTelemetryData(tid.toString());
    Navigator.push(
      context,
      FadeRoute(
        page: ChangeNotifierProvider<DiscussRepository>(
          create: (context) => DiscussRepository(),
          child: DiscussionPage(
              tid: tid,
              userName: userName,
              title: title,
              backToTitle: widget.backToTitle,
              uid: uid),
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
  void dispose() async {
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
            elevation: 0,
            titleSpacing: 0,
            // automaticallyImplyLeading: false,
            // leading: Row(children: [
            //   IconButton(
            //       icon: Icon(
            //         Icons.close,
            //         color: AppColors.greys87,
            //       ),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       }),
            //   Text(widget.backToTitle)
            // ]),
            title: Text(
              widget.backToTitle,
              style: GoogleFonts.lato(
                  color: AppColors.greys60,
                  wordSpacing: 1.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white70,
                      image: DecorationImage(
                          image: AssetImage('assets/img/tags_bg.png'),
                          fit: BoxFit.cover),
                    ),
                    height: 128,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              widget.title,
                              style: GoogleFonts.montserrat(
                                  color: AppColors.greys87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            'Discussions',
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(left: 16.0, top: 14, bottom: 10),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Recent',
                //         style: GoogleFonts.lato(
                //             color: AppColors.greys87,
                //             fontSize: 14.0,
                //             fontWeight: FontWeight.w400),
                //       ),
                //       Icon(
                //         Icons.arrow_drop_down,
                //         color: AppColors.greys60,
                //       )
                //     ],
                //   ),
                // ),
                FutureBuilder(
                    future: _getFilteredDiscussions(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                            child: Container(
                                padding: EdgeInsets.only(bottom: 200.0),
                                child: Wrap(
                                  children: [
                                    for (int i = 0;
                                        i < _discussions.length;
                                        i++)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context, true);
                                            _navigateToDetail(
                                                _discussions[i].tid,
                                                _discussions[i]
                                                    .user['fullname'],
                                                _discussions[i].title,
                                                _discussions[i].user['uid']);
                                          },
                                          child: DiscussCardView(
                                            data: _discussions[i],
                                            filterEnabled: true,
                                          ),
                                        ),
                                      ),
                                  ],
                                )));
                      } else {
                        return Center();
                      }
                    })
              ],
            ),
          ),
        ));
  }
}
