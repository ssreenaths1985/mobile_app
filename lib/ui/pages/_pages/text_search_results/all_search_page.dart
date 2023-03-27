// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../respositories/_respositories/network_respository.dart';
import '../../../../respositories/_respositories/profile_repository.dart';
import './../../../../util/faderoute.dart';
// import './../../../../respositories/index.dart';
import './../../../widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';
import './../../../pages/index.dart';
import './../../../../localization/_langs/english_lang.dart';
import './../../../../util/telemetry_db_helper.dart';

class AllSearchPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;
  final String searchText;
  final int tabNumber;
  final networks;
  final courses;

  AllSearchPage(this.searchText, this.tabNumber, this.networks, this.courses);
  @override
  _AllSearchPageState createState() => _AllSearchPageState();
}

class _AllSearchPageState extends State<AllSearchPage> {
  final LearnService learnService = LearnService();
  final CareerOpeningService careerOpeningService = CareerOpeningService();
  final SuggestionService suggestionService = SuggestionService();
  List _discussions = [];
  dynamic _response;
  dynamic _data;
  // List<Suggestion> _suggestions = [];
  List<dynamic> _requestedConnections = [];

  int pageNo = 1;
  int totalCount = 1;
  String _searchText = '';

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  final TelemetryService telemetryService = TelemetryService();

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchText = widget.searchText;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      FocusManager.instance.primaryFocus.unfocus();
    });
    _getRequestedConnections();
    // _getSuggestions();
    // _trendingDiscussion();
  }

  void _generateInteractTelemetryData(String contentId,
      {String subType = ''}) async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.homePageId,
        userSessionId,
        messageIdentifier,
        contentId,
        subType);
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    // await telemetryService.triggerEvent(allEventsData);
    allEventsData = [];
  }

  void selectDiscussion(BuildContext context, data) {
    Navigator.push(
        context,
        FadeRoute(
          page: DiscussionPage(
            tid: data,
          ),
        ));
  }

  /// Post connection request
  _createConnectionRequest(id) async {
    try {
      List<Profile> profileDetailsFrom;
      profileDetailsFrom =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById('');
      List<Profile> profileDetailsTo;
      profileDetailsTo =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById(id);
      _response = await NetworkService.postConnectionRequest(
          id, profileDetailsFrom, profileDetailsTo);

      if (_response['result']['status'] == 'CREATED') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.connectionRequestSent),
            backgroundColor: AppColors.positiveLight,
          ),
        );
        await _getRequestedConnections();

        try {
          final dataNode =
              await Provider.of<NetworkRespository>(context, listen: false)
                  .getAllUsersFromMDO();

          setState(() {
            _data = dataNode.data;
          });
        } catch (err) {
          return err;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.errorMessage),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } catch (err) {
      return err;
    }

    return _response;
  }

  _getRequestedConnections() async {
    final response =
        await Provider.of<NetworkRespository>(context, listen: false)
            .getRequestedConnections();
    setState(() {
      _requestedConnections = response;
    });
    // print(_requestedConnections.toString());
  }

  // Future<void> _trendingDiscussion() async {
  //   var discussions;
  //   if (widget.tabNumber == 1 || widget.tabNumber == 3) {
  //     try {
  //       discussions =
  //           await Provider.of<DiscussRepository>(context, listen: false)
  //               .getTrendingDiscussions(pageNo);
  //       if (pageNo == 1) {
  //         _discussions = [];
  //       }
  //       setState(() {
  //         pageNo = pageNo + 1;
  //         totalCount =
  //             (discussions[0].topicCount / discussions[0].nextStart).ceil();
  //       });
  //       if (widget.searchText != '') {
  //         // print('Hello: ' +
  //         //     pageNo.toString() +
  //         //     ', ' +
  //         //     discussions[0].title.toString());
  //         if (discussions.length == 0) {
  //           setState(() {});
  //           _loadMore();
  //         }
  //         _discussions.addAll(discussions
  //             .where((discussion) =>
  //                 discussion.title != null &&
  //                 discussion.title.toLowerCase().contains(widget.searchText))
  //             .toList());
  //       } else {
  //         _discussions.addAll(discussions);
  //       }
  //       _discussions = _discussions.toSet().toList();
  //       // print('Length: ' + _discussions.length.toString());
  //     } catch (err) {
  //       return err;
  //     }
  //   }
  // }

  _loadMore() {
    if (pageNo <= totalCount) {
      // _trendingDiscussion();
    }
  }

  // _navigateToDetail(tid) {
  //   Navigator.push(
  //     context,
  //     FadeRoute(
  //       page: ChangeNotifierProvider<DiscussRepository>(
  //         create: (context) => DiscussRepository(),
  //         child: DiscussionPage(tid: tid),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _createConnectionRequest(id) async {
  //   var _response;
  //   try {
  //     _response = await NetworkService.postConnectionRequest(id);

  //     if (_response['result']['status'] == 'CREATED') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(EnglishLang.connectionRequestSent),
  //           backgroundColor: AppColors.positiveLight,
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(EnglishLang.errorMessage),
  //           backgroundColor: Theme.of(context).errorColor,
  //         ),
  //       );
  //     }
  //     setState(() {});
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  // void _dummyAction(String param) {
  //   // print(param);
  // }

  @override
  Widget build(BuildContext context) {
    // print('Search: ${widget.searchText}');
    if (_searchText != widget.searchText) {
      // Future.delayed(Duration(milliseconds: 500), () {
      //   FocusManager.instance.primaryFocus.unfocus();
      // });
      setState(() {
        _searchText = widget.searchText;
      });
    }
    return NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
          // _loadMore();
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMore();
          }
        },
        child: SingleChildScrollView(
            child: (widget.courses.length > 0 || widget.networks.length > 0)
                ? Container(
                    child: Column(
                    children: <Widget>[
                      // _suggestions.length > 0
                      //     ? Container(
                      //         alignment: Alignment.topLeft,
                      //         child: SectionHeading(EnglishLang.fromNetwork),
                      //       )
                      //     : Center(),
                      // Container(
                      //   height: _suggestions.length > 0 ? 260 : 0,
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.only(top: 5, bottom: 10),
                      //   child: FutureBuilder(
                      //     future: _getSuggestions(),
                      //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //       if (snapshot.hasData) {
                      //         // List<Suggestion> suggestions = snapshot.data;
                      //         return ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: _suggestions.length,
                      //           itemBuilder: (context, index) {
                      //             return PeopleItem(
                      //                 suggestion: _suggestions[index],
                      //                 parentAction: _createConnectionRequest);
                      //             // return Center();
                      //           },
                      //         );
                      //       } else {
                      //         // return Center(child: CircularProgressIndicator());
                      //         return Center();
                      //       }
                      //     },
                      //   ),
                      // ),
                      // Container(
                      //     height: _suggestions.length > 0 ? 260 : 0,
                      //     width: double.infinity,
                      //     padding: const EdgeInsets.only(top: 5, bottom: 10),
                      //     child: ListView.builder(
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: _suggestions.length,
                      //       itemBuilder: (context, index) {
                      //         return PeopleItem(
                      //           suggestion: _suggestions[index],
                      //           parentAction1: _createConnectionRequest,
                      //           parentAction2: _dummyAction,
                      //         );
                      //       },
                      //     )),
                      widget.courses.length > 0
                          ? Container(
                              alignment: Alignment.topLeft,
                              child: SectionHeading(EnglishLang.fromCourses),
                            )
                          : Center(),
                      // Container(
                      //   height: _courses.length > 0 ? 355 : 0,
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.only(top: 5, bottom: 20),
                      //   child: FutureBuilder(
                      //     future: _getCourses(),
                      //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //       if (snapshot.hasData) {
                      //         // List<Course> courses = snapshot.data;
                      //         return ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: _courses.length,
                      //           itemBuilder: (context, index) {
                      //             return CourseItem(course: _courses[index]);
                      //           },
                      //         );
                      //       } else {
                      //         // return Center(child: CircularProgressIndicator());
                      //         return Center();
                      //       }
                      //     },
                      //   ),
                      // ),
                      Container(
                          height: widget.courses.length > 0 ? 348 : 0,
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.courses.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    _generateInteractTelemetryData(
                                        widget.courses[index].id.toString(),
                                        subType: TelemetrySubType.learnSearch);
                                    Navigator.push(
                                      context,
                                      FadeRoute(
                                          page: CourseDetailsPage(
                                              id: widget.courses[index].id)),
                                    );
                                  },
                                  child: CourseItem(
                                      course: widget.courses[index]));
                            },
                          )),
                      _discussions.length > 0
                          ? Container(
                              alignment: Alignment.topLeft,
                              child: SectionHeading(
                                  EnglishLang.trendingDiscussions),
                            )
                          : Center(),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 5, bottom: 10),
                      //   child: Column(
                      //     children: <Widget>[
                      //       ListView.builder(
                      //         physics: NeverScrollableScrollPhysics(),
                      //         shrinkWrap: true,
                      //         itemCount: _discussions.length,
                      //         itemBuilder: (context, index) {
                      //           return InkWell(
                      //               onTap: () =>
                      //                   _navigateToDetail(_discussions[index].tid),
                      //               child:
                      //                   (DiscussCardView(data: _discussions[index])));
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      widget.networks.length > 0
                          ? Container(
                              alignment: Alignment.topLeft,
                              child: SectionHeading('From networks'),
                            )
                          : Center(),
                      Container(
                          height: 282,
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.networks.length,
                            itemBuilder: (context, index) {
                              return PeopleItem(
                                // suggestion: widget.networks[index],
                                networkFromSearch: widget.networks[index],
                                parentAction1: _createConnectionRequest,
                                parentAction2: _generateInteractTelemetryData,
                                requestedConnections: _requestedConnections,
                              );
                              // return Center();
                            },
                          )),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ))
                : Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 125),
                                child: SvgPicture.asset(
                                  'assets/img/empty_search.svg',
                                  alignment: Alignment.center,
                                  // color: AppColors.grey16,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              EnglishLang.noResultsFound,
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1.5,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )));
  }
}
