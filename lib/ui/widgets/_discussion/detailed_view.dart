import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_common/page_loader.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import './../../../util/faderoute.dart';
import './../../../respositories/index.dart';
import './../../../util/faderouteBottomUp.dart';
import './../../../util/helper.dart';
import './../../../services/index.dart';
import '../../../constants/index.dart';
import './../../../ui/pages/index.dart';
import './../../../util/telemetry.dart';
import './../../../util/telemetry_db_helper.dart';
// import 'dart:developer' as developer;

class DetailedView extends StatefulWidget {
  final int tid;
  final String backToTitle;
  DetailedView({this.tid, this.backToTitle = ''});
  _DetailedViewState createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView>
    with TickerProviderStateMixin {
  final dateNow = Moment.now();
  final TelemetryService telemetryService = TelemetryService();
  final VoteService voteService = VoteService();
  final textController = TextEditingController();
  var _discussionDetails;
  int _key;
  int _currentPage = 1;
  List _comments = [];
  bool isBookmarked;
  String dropdownValue = 'Recent';
  String sort = '';
  List<String> dropdownItems = ['Recent', 'Most Upvoted'];
  ScrollController _controller = ScrollController();
  String deviceIdentifier;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String pageUri;
  String pageUrl;
  int _start = 0;
  Map rollup = {};
  List allEventsData = [];
  var telemetryEventData;

  AnimationController _iconAnimationController;
  AnimationController _upvoteAnimationController;
  AnimationController _downvoteAnimationController;
  AnimationController _upvotecommentAnimationController;
  AnimationController _upvoteDiscussionAnimationController;
  AnimationController _downvotecommentAnimationController;
  AnimationController _downvoteDiscussionAnimationController;

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    super.initState();
    _collapse();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _upvoteAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _downvoteAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _upvotecommentAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _downvotecommentAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _upvoteDiscussionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _downvoteDiscussionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
  }

  void _manageSort(value) {
    setState(() {
      dropdownValue = value;
      sort = sort == '' ? '&sort=voted' : '';
      _currentPage = 1;
    });
    _discussionByTid(context, widget.tid);
  }

  Future<dynamic> _discussionByTid(context, value) async {
    // print('CP: ' + _currentPage.toString());
    try {
      if (_currentPage == 1 ||
          _currentPage < _discussionDetails.pagination['pageCount']) {
        var response =
            await Provider.of<DiscussRepository>(context, listen: false)
                .getDiscussionById(value, _currentPage, sort);
        // print(response.posts);
        // developer.log(response.title);
        if (_currentPage == 1) {
          _discussionDetails = response;
          _comments = response.posts.reversed.toList();
          _comments.removeWhere((element) =>
              element['pid'] == _discussionDetails.posts[0]['pid']);
        } else {
          _comments.addAll(response.posts.reversed.toList());
          _comments.removeWhere((element) =>
              element['pid'] == _discussionDetails.posts[0]['pid']);
        }

        if (_start == 0) {
          String title = response.title.replaceAll(' ', '-');
          title = response.title.replaceAll('?', '');
          pageUri = TelemetryPageIdentifier.discussionDetailsPageUri
              .replaceAll(':discussionId', widget.tid.toString());
          pageUri = pageUri.replaceAll(':discussionName', title);
          allEventsData = [];
          rollup['l1'] = widget.tid.toString();
          _generateTelemetryData();
        }
        // _startTimer();
      }
      return _discussionDetails;
    } catch (err) {
      return err;
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
        TelemetryPageIdentifier.discussionDetailsPageId,
        userSessionId,
        messageIdentifier,
        TelemetryType.page,
        pageUri);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _generateInteractTelemetryData(String contentId,
      {String subType = ''}) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.discussionDetailsPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        subType);
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<void> _postUpVote(
      context, mainPid, tid, index, displayDeleteTools) async {
    if (displayDeleteTools) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Can\'t vote on your own post.',
          // style: GoogleFonts.lato(
          //   // color: AppColors.greys87,
          //   fontSize: 14.0,
          //   letterSpacing: 0.5,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Theme.of(context).errorColor,
      ));
      _upvoteAnimationController
          .forward()
          .then((value) => _upvoteAnimationController.reverse());
      _upvotecommentAnimationController
          .forward()
          .then((value) => _upvotecommentAnimationController.reverse());
      _upvoteDiscussionAnimationController
          .forward()
          .then((value) => _upvoteDiscussionAnimationController.reverse());
    } else {
      var response;
      try {
        _generateInteractTelemetryData(mainPid.toString(),
            subType: TelemetrySubType.upVoteIcon);
        response = await voteService.postVote(mainPid, 'upVote');
        if (response == 'ok') {
          setState(() {});
          if (index > 0) {
            _comments[index]['upvoted'] = true;
            _comments[index]['upvotes'] = _comments[index]['upvotes'] + 1;
            if (_comments[index]['downvoted']) {
              _comments[index]['downvoted'] = false;
              _comments[index]['downvotes'] = _comments[index]['downvotes'] - 1;
            }
          }
        }
      } catch (err) {
        return err;
      }
      _upvoteAnimationController
          .forward()
          .then((value) => _upvoteAnimationController.reverse());
      _upvotecommentAnimationController
          .forward()
          .then((value) => _upvotecommentAnimationController.reverse());
      _upvoteDiscussionAnimationController
          .forward()
          .then((value) => _upvoteDiscussionAnimationController.reverse());
    }
  }

  Future<void> _deleteUpVote(
      context, mainPid, tid, index, displayDeleteTools) async {
    if (displayDeleteTools) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Can\'t vote on your own post.',
          // textAlign: TextAlign.center,
          // style: GoogleFonts.lato(
          //   // color: AppColors.greys87,
          //   fontSize: 14.0,
          //   letterSpacing: 0.4,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Theme.of(context).errorColor,
      ));
      _upvoteAnimationController
          .forward()
          .then((value) => _upvoteAnimationController.reverse());
      _upvotecommentAnimationController
          .forward()
          .then((value) => _upvotecommentAnimationController.reverse());
      _upvoteDiscussionAnimationController
          .forward()
          .then((value) => _upvoteDiscussionAnimationController.reverse());
    } else {
      var response;
      try {
        _generateInteractTelemetryData(mainPid.toString(),
            subType: TelemetrySubType.upVoteIcon);
        // print('deleteUpVote ' + mainPid.toString());
        response = await voteService.deleteVote(mainPid);
        if (response == 'ok') {
          // print('_discussionByTid');
          setState(() {});
          if (index > 0) {
            _comments[index]['upvotes'] = _comments[index]['upvotes'] - 1;
            _comments[index]['upvoted'] = false;
          }
        }
      } catch (err) {
        return err;
      }
      _upvoteAnimationController
          .forward()
          .then((value) => _upvoteAnimationController.reverse());
      _upvotecommentAnimationController
          .forward()
          .then((value) => _upvotecommentAnimationController.reverse());
      _upvoteDiscussionAnimationController
          .forward()
          .then((value) => _upvoteDiscussionAnimationController.reverse());
    }
  }

  Future<void> _postDownVote(
      context, mainPid, tid, index, displayDeleteTools) async {
    if (displayDeleteTools) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Can\'t vote on your own post.',
          // style: GoogleFonts.lato(
          //   // color: AppColors.greys87,
          //   fontSize: 14.0,
          //   letterSpacing: 0.5,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Theme.of(context).errorColor,
      ));
      _downvoteAnimationController
          .forward()
          .then((value) => _downvoteAnimationController.reverse());
      _downvotecommentAnimationController
          .forward()
          .then((value) => _downvotecommentAnimationController.reverse());
      _downvoteDiscussionAnimationController
          .forward()
          .then((value) => _downvoteDiscussionAnimationController.reverse());
    } else {
      var response;
      try {
        _generateInteractTelemetryData(mainPid.toString(),
            subType: TelemetrySubType.downVoteIcon);
        // print('postUpVote ' + mainPid.toString());
        response = await voteService.postVote(mainPid, 'downVote');
        if (response == 'ok') {
          // print('_discussionByTid');
          setState(() {});
          if (index > 0) {
            _comments[index]['downvoted'] = true;
            _comments[index]['downvotes'] = _comments[index]['downvotes'] + 1;
            if (_comments[index]['upvoted']) {
              _comments[index]['upvoted'] = false;
              _comments[index]['upvotes'] = _comments[index]['upvotes'] - 1;
            }
          }
        }
      } catch (err) {
        return err;
      }
      _downvoteAnimationController
          .forward()
          .then((value) => _downvoteAnimationController.reverse());
      _downvotecommentAnimationController
          .forward()
          .then((value) => _downvotecommentAnimationController.reverse());
      _downvoteDiscussionAnimationController
          .forward()
          .then((value) => _downvoteDiscussionAnimationController.reverse());
    }
  }

  Future<void> _deleteDownVote(
      context, mainPid, tid, index, displayDeleteTools) async {
    if (displayDeleteTools) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Can\'t vote on your own post.',
          // textAlign: TextAlign.center,
          // style: GoogleFonts.lato(
          //   // color: AppColors.greys87,
          //   fontSize: 14.0,
          //   letterSpacing: 0.5,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blue,
      ));
      _downvoteAnimationController
          .forward()
          .then((value) => _downvoteAnimationController.reverse());
      _downvotecommentAnimationController
          .forward()
          .then((value) => _downvotecommentAnimationController.reverse());
      _downvoteDiscussionAnimationController
          .forward()
          .then((value) => _downvoteDiscussionAnimationController.reverse());
    } else {
      var response;
      try {
        _generateInteractTelemetryData(mainPid.toString(),
            subType: TelemetrySubType.downVoteIcon);
        // print('deleteUpVote ' + mainPid.toString());
        response = await voteService.deleteVote(mainPid);
        if (response == 'ok') {
          // print('_discussionByTid');
          setState(() {});
          if (index > 0) {
            _comments[index]['downvotes'] = _comments[index]['downvotes'] - 1;
            _comments[index]['downvoted'] = false;
          }
        }
      } catch (err) {
        return err;
      }
    }
    _downvoteAnimationController
        .forward()
        .then((value) => _downvoteAnimationController.reverse());
    _downvotecommentAnimationController
        .forward()
        .then((value) => _downvotecommentAnimationController.reverse());
    _downvoteDiscussionAnimationController
        .forward()
        .then((value) => _downvoteDiscussionAnimationController.reverse());
  }

  Future<void> _bookmarkDiscussion(context, mainPid, add) async {
    try {
      _generateInteractTelemetryData(mainPid.toString(),
          subType: TelemetrySubType.bookmarkIcon);
      // print(mainPid.toString() + ', ' + add.toString());
      var response =
          await Provider.of<DiscussRepository>(context, listen: false)
              .bookmarkDiscussion(mainPid, add);
      if (response == 'ok') {
        if (!add) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Bookmark added successfully!',
            ),
            duration: Duration(seconds: 3),
            backgroundColor: AppColors.positiveLight,
          ));
          _iconAnimationController
              .forward()
              .then((value) => _iconAnimationController.reverse());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Bookmark removed successfully!',
            ),
            duration: Duration(seconds: 3),
            backgroundColor: AppColors.positiveLight,
          ));
        }
        setState(() {
          _currentPage = _currentPage + 1;
          _discussionDetails.posts[0]['bookmarked'] = !add;
        });
      }
    } catch (err) {
      return err;
    }
    _iconAnimationController
        .forward()
        .then((value) => _iconAnimationController.reverse());
  }

  // Load cards on scroll
  _loadMore() {
    setState(() {
      _currentPage = _currentPage + 1;
    });
    _discussionByTid(context, widget.tid);
  }

  List<Widget> _getTags(List discussionTags) {
    List<Widget> tags = [];
    for (int i = 0; i < discussionTags.length; i++) {
      tags.add(
        InkWell(
          onTap: () {
            // if (widget.backToTitle != '') {
            Navigator.pop(context);
            // }
            Navigator.push(
              context,
              //   FadeRoute(
              //       page: DiscussionFilterPage(
              //           isCategory: false,
              //           id: discussionTags[i]['score'],
              //           title: discussionTags[i]['value'])),
              // ),
              FadeRoute(
                  page: FilteredDiscussionsPage(
                isCategory: false,
                id: discussionTags[i]['score'],
                title: discussionTags[i]['value'],
                backToTitle: widget.backToTitle,
              )),
            );
          },
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
        ),
      );
    }
    return tags;
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
          child: FutureBuilder(
            future: _discussionByTid(context, widget.tid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data);
                return Container(
                    padding: const EdgeInsets.only(bottom: 120),
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(), // new
                      controller: _controller,
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          // margin: EdgeInsets.only(top: 5.0),
                          child: Padding(
                            padding: EdgeInsets.only(top: 16, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                          snapshot.data.posts[0] != null
                                              ? (snapshot.data.posts[0]['user']
                                                              ['fullname'] !=
                                                          null &&
                                                      snapshot.data.posts[0]
                                                                  ['user']
                                                              ['fullname'] !=
                                                          '')
                                                  ? Helper.getInitialsNew(
                                                      snapshot.data.posts[0]
                                                          ['user']['fullname'])
                                                  : Helper.getInitialsNew(
                                                      snapshot.data.posts[0]
                                                          ['user']['username'])
                                              : 'UN',
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
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data.posts[0] != null
                                                    ? (snapshot.data.posts[0]
                                                                        ['user'][
                                                                    'fullname'] !=
                                                                null &&
                                                            snapshot.data.posts[0]
                                                                        ['user'][
                                                                    'fullname'] !=
                                                                '')
                                                        ? snapshot.data.posts[0]
                                                                    ['user']
                                                                ['fullname'] +
                                                            ' . '
                                                        : snapshot.data.posts[0]
                                                                    ['user']
                                                                ['username'] +
                                                            ' . '
                                                    : 'Name' + ' . ',
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                (dateNow.from(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            _discussionDetails
                                                                    .posts[0]
                                                                ['timestamp'])))
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ])),
                                    Spacer(),
                                    ScaleTransition(
                                      scale: _iconAnimationController,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.bookmark,
                                            color: _discussionDetails.posts[0]
                                                    ['bookmarked']
                                                ? AppColors.primaryThree
                                                : AppColors.grey16,
                                          ),
                                          onPressed: () {
                                            _bookmarkDiscussion(
                                                context,
                                                _discussionDetails.mainPid,
                                                _discussionDetails.posts[0]
                                                    ['bookmarked']);
                                          }),
                                    ),
                                  ],
                                ),
                                Text(
                                  snapshot.data != null
                                      ? snapshot.data.title
                                      : 'Question ?',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    wordSpacing: 1.0,
                                    textStyle: TextStyle(height: 1.5),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // if (widget.backToTitle != '') {
                                    Navigator.pop(context);
                                    // }
                                    Navigator.push(
                                      context,
                                      // FadeRoute(
                                      //     page: DiscussionFilterPage(
                                      //         isCategory: true,
                                      //         id: snapshot.data.category['cid'],
                                      //         title: snapshot
                                      //             .data.category['name'])),
                                      FadeRoute(
                                          page: FilteredDiscussionsPage(
                                        isCategory: true,
                                        id: snapshot.data.category['cid'],
                                        title: snapshot.data.category['name'],
                                        backToTitle: widget.backToTitle,
                                      )),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/img/category_image_1.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 12.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            snapshot.data.category != null
                                                ? snapshot.data.category['name']
                                                : 'Category',
                                            style: GoogleFonts.lato(
                                                color: AppColors.primaryThree,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                snapshot.data.tags.length > 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Container(
                                          height: 24,
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              // physics: NeverScrollableScrollPhysics(),
                                              // shrinkWrap: true,
                                              children:
                                                  _getTags(snapshot.data.tags)),
                                        ),
                                      )
                                    : Center(),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: HtmlWidget(
                                      _discussionDetails.posts[0]['content']
                                          .replaceAll('src="',
                                              'src="' + ApiUrl.baseUrl + ''),
                                      textStyle: TextStyle(
                                          fontFamily: 'lato',
                                          fontWeight: FontWeight.w400,
                                          wordSpacing: 1.0,
                                          color: AppColors.greys87,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async => _discussionDetails
                                                            .posts[0]['upvoted']
                                                        ? _deleteUpVote(
                                                            context,
                                                            _discussionDetails
                                                                .mainPid,
                                                            _discussionDetails
                                                                .tid,
                                                            0,
                                                            _comments[0][
                                                                'display_delete_tools'])
                                                        : _postUpVote(
                                                            context,
                                                            _discussionDetails
                                                                .mainPid,
                                                            _discussionDetails
                                                                .tid,
                                                            0,
                                                            _comments[0][
                                                                'display_delete_tools']),
                                                    child: ScaleTransition(
                                                      scale:
                                                          _upvoteAnimationController,
                                                      child: SvgPicture.asset(
                                                        'assets/img/up_vote.svg',
                                                        color: _discussionDetails
                                                                    .posts[0]
                                                                ['upvoted']
                                                            ? Colors.green
                                                            : AppColors.greys87,
                                                        width: 24.0,
                                                        height: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                      _discussionDetails
                                                                      .posts[0]
                                                                  ['upvotes'] !=
                                                              null
                                                          ? (_discussionDetails
                                                                      .posts[0]
                                                                  ['upvotes'])
                                                              .toString()
                                                          : '0',
                                                      style: GoogleFonts.lato(
                                                          color: _discussionDetails
                                                                      .posts[0]
                                                                  ['upvoted']
                                                              ? Colors.green
                                                              : AppColors
                                                                  .greys60,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 25.0),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async => _discussionDetails
                                                                  .posts[0][
                                                              'downvoted']
                                                          ? _deleteDownVote(
                                                              context,
                                                              _discussionDetails
                                                                  .mainPid,
                                                              _discussionDetails
                                                                  .tid,
                                                              0,
                                                              _comments[0][
                                                                  'display_delete_tools'])
                                                          : _postDownVote(
                                                              context,
                                                              _discussionDetails
                                                                  .mainPid,
                                                              _discussionDetails
                                                                  .tid,
                                                              0,
                                                              _comments[0][
                                                                  'display_delete_tools']),
                                                      child: ScaleTransition(
                                                        scale:
                                                            _downvoteAnimationController,
                                                        child: SvgPicture.asset(
                                                          'assets/img/down_vote.svg',
                                                          color: _discussionDetails
                                                                      .posts[0]
                                                                  ['downvoted']
                                                              ? Colors.red
                                                              : AppColors
                                                                  .greys87,
                                                          width: 24.0,
                                                          height: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        _discussionDetails
                                                                        .posts[0]
                                                                    [
                                                                    'downvotes'] !=
                                                                null
                                                            ? (_discussionDetails
                                                                        .posts[0]
                                                                    [
                                                                    'downvotes'])
                                                                .toString()
                                                            : '0',
                                                        style: GoogleFonts.lato(
                                                            color: _discussionDetails
                                                                        .posts[0]
                                                                    [
                                                                    'downvoted']
                                                                ? Colors.red
                                                                : AppColors
                                                                    .greys87,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 32.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.trending_up,
                                                      color: AppColors.greys60,
                                                      size: 20,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Text(
                                                        snapshot.data != null
                                                            ? (_discussionDetails
                                                                        .viewCount)
                                                                    .toString() +
                                                                ' views'
                                                            : '0 views',
                                                        style: GoogleFonts.lato(
                                                            color: AppColors
                                                                .greys60,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 16),
                                  child: Text(
                                    (_discussionDetails.postCount - 1)
                                            .toString() +
                                        '  Comments',
                                    style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _comments.length > 1
                            ? Container(
                                margin: const EdgeInsets.only(right: 200),
                                child: _recentBar(context))
                            : Center(),
                        _discussionDetails.posts.length > 1
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 50),
                                child: Wrap(
                                  children: [
                                    for (int i = 0; i < _comments.length; i++)
                                      Container(
                                        width: double.infinity,
                                        // color: Colors.white,
                                        margin: EdgeInsets.only(top: 5.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  color: Colors.white,
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Column(children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 24,
                                                          width: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .positiveLight,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    const Radius
                                                                            .circular(
                                                                        4.0)),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              _comments[i] !=
                                                                      null
                                                                  ? ((_comments[i]['user']['fullname'] !=
                                                                              null &&
                                                                          _comments[i]['user']['fullname'] !=
                                                                              '')
                                                                      ? Helper.getInitialsNew(_comments[i]
                                                                              ['user']
                                                                          [
                                                                          'fullname'])
                                                                      : Helper.getInitialsNew(
                                                                          _comments[i]['user']
                                                                              [
                                                                              'username']))
                                                                  : 'UN',
                                                              style: GoogleFonts
                                                                  .lato(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          // alignment: Alignment.topLeft,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                (_comments[i]['user']['fullname'] !=
                                                                            null &&
                                                                        _comments[i]['user']['fullname'] !=
                                                                            '')
                                                                    ? _comments[i]['user']
                                                                            [
                                                                            'fullname'] +
                                                                        ' . '
                                                                    : _comments[i]['user']
                                                                            [
                                                                            'username'] +
                                                                        ' . ',
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  color: AppColors
                                                                      .greys87,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              Text(
                                                                (dateNow.from(DateTime.fromMillisecondsSinceEpoch(
                                                                        _comments[i]
                                                                            [
                                                                            'timestamp'])))
                                                                    .toString(),
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  color: AppColors
                                                                      .greys60,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8),
                                                      child: HtmlWidget(
                                                          _comments[i]
                                                              ['content'],
                                                          textStyle: TextStyle(
                                                              fontFamily:
                                                                  'lato',
                                                              // padding: EdgeInsets.all(0),
                                                              // margin: EdgeInsets.only(left: 0),
                                                              wordSpacing: 1.0,
                                                              color: AppColors
                                                                  .greys87,
                                                              letterSpacing:
                                                                  0.25)),
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () async => _comments[i]['upvoted']
                                                                              ? _deleteUpVote(context, _comments[i]['pid'], _comments[i]['tid'], i, _comments[i]['display_delete_tools'])
                                                                              : _postUpVote(context, _comments[i]['pid'], _comments[i]['tid'], i, _comments[i]['display_delete_tools']),
                                                                          child:
                                                                              ScaleTransition(
                                                                            scale:
                                                                                _upvoteDiscussionAnimationController,
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              'assets/img/up_vote.svg',
                                                                              color: _comments[i]['upvoted'] ? Colors.green : AppColors.greys87,
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 2.0),
                                                                          child:
                                                                              Text(
                                                                            _comments[i] != null
                                                                                ? (_comments[i]['upvotes']).toString()
                                                                                : '0',
                                                                            style: GoogleFonts.lato(
                                                                                color: _comments[i]['upvoted'] ? Colors.green : AppColors.greys87,
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              32.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap: () async => _comments[i]['downvoted']
                                                                                ? _deleteDownVote(context, _comments[i]['pid'], _comments[i]['tid'], i, _comments[i]['display_delete_tools'])
                                                                                : _postDownVote(context, _comments[i]['pid'], _comments[i]['tid'], i, _comments[i]['display_delete_tools']),
                                                                            child:
                                                                                ScaleTransition(
                                                                              scale: _downvoteDiscussionAnimationController,
                                                                              child: SvgPicture.asset(
                                                                                'assets/img/down_vote.svg',
                                                                                color: _comments[i]['downvoted'] ? Colors.red : AppColors.greys87,
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 2.0),
                                                                            child:
                                                                                Text(
                                                                              _comments[i] != null ? (_comments[i]['downvotes']).toString() : '0',
                                                                              style: GoogleFonts.lato(color: _comments[i]['downvoted'] ? Colors.red : AppColors.greys87, fontSize: 14.0, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    InkWell(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          FadeRouteBottomUp(
                                                                              page: ReplyToCommentPage(
                                                                            tid:
                                                                                _comments[i]['tid'],
                                                                            pid:
                                                                                _comments[i]['pid'],
                                                                            userName:
                                                                                _comments[i]['user']['username'],
                                                                            title:
                                                                                _comments[i]['content'],
                                                                          )),
                                                                        )
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Reply',
                                                                        style: GoogleFonts.lato(
                                                                            color: AppColors
                                                                                .greys60,
                                                                            fontSize:
                                                                                14.0,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    ),
                                                                    // Padding(
                                                                    //   padding: const EdgeInsets
                                                                    //           .only(
                                                                    //       left:
                                                                    //           16),
                                                                    //   child:
                                                                    //       Icon(
                                                                    //     Icons
                                                                    //         .more_vert,
                                                                    //     size:
                                                                    //         16,
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ))
                                                  ])),
                                              _comments[i]['replies']['count'] >
                                                      0
                                                  ? _getCommentReplies(
                                                      context, _comments, i)
                                                  : Center(),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ))
                            : Center(
                                child: Text(''),
                              )
                      ],
                    ));
              } else {
                return PageLoader(
                  bottom: 150,
                );
              }
            },
          ),
        ));
  }

  Widget _recentBar(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: (dropdownValue != null && dropdownValue.isNotEmpty)
            ? dropdownValue
            : null,
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
                    padding: EdgeInsets.fromLTRB(16.0, 15.0, 0, 15.0),
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
        onChanged: null,
        // (String newValue) {
        //   _manageSort(newValue);
        // },
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _getCommentReplies(BuildContext context, posts, j) {
    return ListTileTheme(
      contentPadding: EdgeInsets.only(right: 290, left: 16),
      dense: true,
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          posts[j]['replies']['count'].toString() +
              (posts[j]['replies']['count'] == 1 ? ' reply' : ' replies'),
          style: GoogleFonts.lato(
            color: AppColors.greys87,
            fontSize: 14.0,
            letterSpacing: 0.25,
          ),
        ),
        children: <Widget>[
          Wrap(
            children: [
              for (int i = 0; i < _comments.length; i++)
                posts[i]['toPid'] == _comments[j]['pid']
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 4, left: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border(
                          //   left: BorderSide(
                          //     color: Colors.black,
                          //     width: 3.0,
                          //   ),
                          //   top: BorderSide(
                          //     color: Colors.black,
                          //     width: 3.0,
                          //   ),
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
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
                                        posts[i] != null
                                            ? posts[i]['user']['displayname'] !=
                                                        null &&
                                                    posts[i]['user']
                                                            ['displayname'] !=
                                                        ''
                                                ? Helper.getInitialsNew(posts[i]
                                                    ['user']['displayname'])
                                                : Helper.getInitialsNew(posts[i]
                                                    ['user']['username'])
                                            : 'UN',
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
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          posts[i] != null
                                              ? posts[i]['user']
                                                              ['displayname'] !=
                                                          null &&
                                                      posts[i]['user']
                                                              ['displayname'] !=
                                                          ''
                                                  ? posts[i]['user']
                                                      ['displayname']
                                                  : posts[i]['user']['username']
                                              : 'Username',
                                          style: GoogleFonts.lato(
                                              color: AppColors.greys60,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.25),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, right: 4, bottom: 6),
                                          child: Text(
                                            '.',
                                            style: GoogleFonts.lato(
                                                color: AppColors.greys60,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.25),
                                          ),
                                        ),
                                        Text(
                                          (dateNow.from(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      posts[i]['timestamp'])))
                                              .toString(),
                                          style: GoogleFonts.lato(
                                              color: AppColors.greys60,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.25),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: HtmlWidget(posts[i]['content'],
                                    textStyle: TextStyle(
                                        fontFamily: 'lato',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        // padding: EdgeInsets.all(0),
                                        // margin: EdgeInsets.only(left: 0),
                                        wordSpacing: 0.25,
                                        color: AppColors.greys87,
                                        letterSpacing: 0.25)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async => posts[i]
                                                          ['upvoted']
                                                      ? _deleteUpVote(
                                                          context,
                                                          posts[i]['pid'],
                                                          posts[i]['tid'],
                                                          i,
                                                          posts[i][
                                                              'display_delete_tools'])
                                                      : _postUpVote(
                                                          context,
                                                          posts[i]['pid'],
                                                          posts[i]['tid'],
                                                          i,
                                                          posts[i][
                                                              'display_delete_tools']),
                                                  child: ScaleTransition(
                                                    scale:
                                                        _upvotecommentAnimationController,
                                                    child: SvgPicture.asset(
                                                      'assets/img/up_vote.svg',
                                                      color: posts[i]['upvoted']
                                                          ? Colors.green
                                                          : AppColors.greys87,
                                                      width: 24.0,
                                                      height: 24.0,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.0),
                                                  child: Text(
                                                    posts[i] != null
                                                        ? (posts[i]['upvotes'])
                                                            .toString()
                                                        : '0',
                                                    style: GoogleFonts.lato(
                                                        color: posts[i]
                                                                ['upvoted']
                                                            ? Colors.green
                                                            : AppColors.greys60,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.25),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 25.0),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async => posts[i]
                                                            ['downvoted']
                                                        ? _deleteDownVote(
                                                            context,
                                                            posts[i]['pid'],
                                                            posts[i]['tid'],
                                                            i,
                                                            posts[i][
                                                                'display_delete_tools'])
                                                        : _postDownVote(
                                                            context,
                                                            posts[i]['pid'],
                                                            posts[i]['tid'],
                                                            i,
                                                            posts[i][
                                                                'display_delete_tools']),
                                                    child: ScaleTransition(
                                                      scale:
                                                          _downvotecommentAnimationController,
                                                      child: SvgPicture.asset(
                                                        'assets/img/down_vote.svg',
                                                        color: posts[i]
                                                                ['downvoted']
                                                            ? Colors.red
                                                            : AppColors.greys87,
                                                        width: 24.0,
                                                        height: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 2.0),
                                                    child: Text(
                                                      posts[i] != null
                                                          ? (posts[i]
                                                                  ['downvotes'])
                                                              .toString()
                                                          : '0',
                                                      style: GoogleFonts.lato(
                                                          color: posts[i]
                                                                  ['downvoted']
                                                              ? Colors.red
                                                              : AppColors
                                                                  .greys60,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 0.25),
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
                      )
                    : Center(),
            ],
          )
        ],
      ),
    );
  }
}
