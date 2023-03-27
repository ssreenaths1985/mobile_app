import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:provider/provider.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import './../../../respositories/index.dart';
import './../../../ui/pages/index.dart';
import './../../../ui/widgets/index.dart';
import './../../../util/faderoute.dart';
import './../../../constants/index.dart';
import './../../../localization/index.dart';
import './../../../services/index.dart';
import './../../../util/telemetry.dart';
import './../../../util/telemetry_db_helper.dart';

// ignore: must_be_immutable
class DiscussionCard extends StatefulWidget {
  final int tabIndex;
  final parentAction;
  final bool popularPosts;
  DiscussionCard({Key key, this.tabIndex, this.popularPosts, this.parentAction})
      : super(key: key);

  @override
  _DiscussionCardState createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  final TelemetryService telemetryService = TelemetryService();
  final service = HttpClient();
  int pageNo = 1;
  int pageCount;
  int currentPage;
  String dropdownValue;
  List<String> dropdownItems = [EnglishLang.recent, EnglishLang.popular];

  List _data = [];
  List _trendingTagsData = [];
  RouteSettings settings;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  int _start = 0;
  List allEventsData;
  String deviceIdentifier;
  List typesOfDiscussions = [EnglishLang.popular, EnglishLang.recent];
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _trendingTags();
    if (widget.popularPosts) {
      setState(() {
        dropdownValue = EnglishLang.popular;
      });
    } else {
      setState(() {
        dropdownValue = EnglishLang.recent;
      });
    }
    _getDiscussions();
    _getPageDetails();
    if (_start == 0) {
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
      TelemetryPageIdentifier.discussionsPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.discussionsPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  /// Get recent discussions
  Future<dynamic> _getDiscussions() async {
    try {
      if (dropdownValue == EnglishLang.recent) {
        if (pageNo == 1) {
          _data = await Provider.of<DiscussRepository>(context, listen: false)
              .getRecentDiscussions(pageNo);
        } else {
          _data.addAll(
              await Provider.of<DiscussRepository>(context, listen: false)
                  .getRecentDiscussions(pageNo));
        }
      } else {
        if (pageNo == 1) {
          _data = await Provider.of<DiscussRepository>(context, listen: false)
              .getPopularDiscussions(pageNo);
        } else {
          _data.addAll(
              await Provider.of<DiscussRepository>(context, listen: false)
                  .getPopularDiscussions(pageNo));
        }
      }
      _data = _data.toSet().toList();
      _data.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      return _data;
    } catch (err) {
      return err;
    }
  }

  /// Get recent page details
  Future<void> _getPageDetails() async {
    var pageDetails;
    try {
      if (dropdownValue == EnglishLang.recent) {
        pageDetails =
            await Provider.of<DiscussRepository>(context, listen: false)
                .getDiscussionPageCount(pageNo);
      } else {
        pageDetails =
            await Provider.of<DiscussRepository>(context, listen: false)
                .getPopularDiscussionPageCount(pageNo);
      }
    } catch (err) {
      return err;
    }

    setState(() {
      pageCount = pageDetails.pageCount;
    });
  }

  /// Get trending tags
  Future<void> _trendingTags() async {
    try {
      _trendingTagsData =
          await Provider.of<DiscussRepository>(context, listen: false)
              .getTrendingTags();
    } catch (err) {
      return err;
    }

    return _trendingTagsData;
  }

  void _generateInteractTelemetryData(String contentId) async {
    // print('Added click');
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.discussionsPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.courseCard);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    allEventsData.add(eventData);
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
              tid: tid, userName: userName, title: title, uid: uid),
        ),
      ),
    );
  }

  /// Load cards on scroll
  _loadMore() {
    setState(() {
      if (pageNo < pageCount) {
        pageNo = pageNo + 1;
      }
    });
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
      child: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: _getDiscussions(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return PageLoader(
                bottom: 175,
              );
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
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 200, top: 2),
                  child: DropdownButton<String>(
                    value: dropdownValue.isNotEmpty ? dropdownValue : null,
                    icon: Icon(Icons.arrow_drop_down_outlined),
                    iconSize: 26,
                    elevation: 16,
                    style: TextStyle(color: AppColors.greys87),
                    underline: Container(
                      // height: 2,
                      color: AppColors.lightGrey,
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return dropdownItems.map<Widget>((String item) {
                        return Row(
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 15.0, 0, 15.0),
                                child: Text(
                                  item,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ))
                          ],
                        );
                      }).toList();
                    },
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        pageNo = 1;
                        widget.parentAction();
                      });
                    },
                    items: dropdownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                // Container(
                //   height: 5.0,
                // ),
                Wrap(
                  children: [
                    for (int i = 0; i <= 1; i++)
                      InkWell(
                        onTap: () {
                          _navigateToDetail(
                              _data[i].tid,
                              (_data[i].user['fullname'] != null &&
                                      _data[i].user['fullname'] != '')
                                  ? _data[i].user['fullname']
                                  : _data[i].user['username'],
                              _data[i].title,
                              _data[i].user['uid']);
                        },
                        child: _data.length > 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: DiscussCardView(
                                  data: _data[i],
                                ),
                              )
                            : Center(
                                child: Text(''),
                              ),
                      ),
                    FutureBuilder(
                      future: _trendingTags(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return TrendingTags(data: snapshot.data);
                        } else {
                          return Center();
                        }
                      },
                    ),
                    for (int i = 2; i <= 3; i++)
                      InkWell(
                        onTap: () {
                          _navigateToDetail(
                              _data[i].tid,
                              (_data[i].user['fullname'] != null &&
                                      _data[i].user['fullname'] != '')
                                  ? _data[i].user['fullname']
                                  : _data[i].user['username'],
                              _data[i].title,
                              _data[i].user['uid']);
                        },
                        child: _data.length > 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: DiscussCardView(
                                  data: _data[i],
                                ),
                              )
                            : Center(
                                child: Text(''),
                              ),
                      ),
                    // FutureBuilder(
                    //   future: _trendingTags(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       return LeaderMonth();
                    //     } else {
                    //       return Center();
                    //     }
                    //   },
                    // ),
                    Container(
                      padding: EdgeInsets.only(bottom: 200.0),
                      child: Wrap(
                        children: [
                          for (int i = 4; i < _data.length; i++)
                            InkWell(
                              onTap: () {
                                _navigateToDetail(
                                    _data[i].tid,
                                    (_data[i].user['fullname'] != null &&
                                            _data[i].user['fullname'] != '')
                                        ? _data[i].user['fullname']
                                        : _data[i].user['username'],
                                    _data[i].title,
                                    _data[i].user['uid']);
                              },
                              child: _data.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: DiscussCardView(
                                        data: _data[i],
                                      ),
                                    )
                                  : Center(
                                      child: Text(''),
                                    ),
                            ),
                        ],
                      ),
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
