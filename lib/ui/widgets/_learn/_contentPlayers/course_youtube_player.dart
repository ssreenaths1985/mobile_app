import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/app_constants.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../constants/_constants/color_constants.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
// import './../../../../constants/index.dart';
import '../../../../localization/_langs/english_lang.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:developer' as developer;

class CourseYoutubePlayer extends StatefulWidget {
  final course;
  final String identifier;
  final String url;
  final currentProgress;
  final int status;
  final String batchId;
  final String contentType;
  final bool isFeaturedCourse;

  CourseYoutubePlayer(this.course, this.identifier, this.url,
      this.currentProgress, this.status, this.batchId, this.contentType,
      {this.isFeaturedCourse = false});

  @override
  _CourseYoutubePlayerState createState() => _CourseYoutubePlayerState();
}

class _CourseYoutubePlayerState extends State<CourseYoutubePlayer> {
  YoutubePlayerController _controller;

  final LearnService learnService = LearnService();
  final TelemetryService telemetryService = TelemetryService();
  String identifier;
  String _contentId;
  double _currentProgressInSeconds = 0;
  double _currentProgressPercentage = 0;

  bool _fullScreen = false;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  Timer _timer;
  int _start = 0;
  String pageIdentifier;
  String telemetryType;
  String pageUri;
  List allEventsData = [];
  String deviceIdentifier;
  var telemetryEventData;

  void initState() {
    super.initState();
    List urlSegments = widget.url.split('/');
    if (urlSegments.last.contains('?')) {
      identifier = urlSegments.last.split('?')[0];
    } else {
      identifier = urlSegments.last;
    }
    _contentId = widget.identifier;
    // if (widget.currentProgress != 0) {
    //   _currentProgress = int.parse(widget.currentProgress.split('.').last);
    // }
    if (_start == 0) {
      pageIdentifier = TelemetryPageIdentifier.youtubePlayerPageId;
      telemetryType = TelemetryType.player;
      var batchId = widget.course['batches'] != null
          ? widget.course['batches'][0]['batchId']
          : '';
      pageUri =
          'viewer/youtube/${widget.course['identifier']}?primaryCategory=Learning%20Resource&collectionId=${widget.course['identifier']}&collectionType=Course&batchId=$batchId';
      _generateTelemetryData();
    }
    // If the requirement is just to play a single video.
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.url.split('/').last,
      autoPlay: true,
      startSeconds:
          (widget.currentProgress != null && widget.currentProgress != '')
              ? double.parse(widget.currentProgress.toString())
              : 0,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );

    _controller.listen(
      (event) async {
        if (event.fullScreenOption.enabled) {
          // developer.log("Entered full screen....");
          await _setLandscape();
        } else if (event.fullScreenOption.locked) {
          await _setAllOrientation();
        }
      },
    );
    _startTimer();
  }

  _setLandscape() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    setState(() {
      _fullScreen = true;
    });
  }

  _setAllOrientation({bool isFromDisposeFunction = false}) async {
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
    //     overlays: []);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    if (!isFromDisposeFunction) {
      setState(() {
        _fullScreen = true;
      });
    }
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        // setState(() {
        _start++;
        // });
      },
    );
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId(isPublic: widget.isFeaturedCourse);
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId =
        await Telemetry.getUserDeptId(isPublic: widget.isFeaturedCourse);

    Map eventData1 = Telemetry.getStartTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        telemetryType,
        pageUri);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
        isPublic: widget.isFeaturedCourse);
    Map eventData2 = Telemetry.getImpressionTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        telemetryType,
        pageUri);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData2);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
        isPublic: widget.isFeaturedCourse);
    allEventsData.add(eventData1);
    allEventsData.add(eventData2);
    // await telemetryService.triggerEvent(allEventsData);
  }

  @override
  void dispose() async {
    super.dispose();
    await _setAllOrientation(isFromDisposeFunction: true);
    try {
      if (!widget.isFeaturedCourse) {
        _updateContentProgress();
      }
      _controller.close();
      Map eventData = Telemetry.getEndTelemetryEvent(
          deviceIdentifier,
          userId,
          departmentId,
          pageIdentifier,
          userSessionId,
          messageIdentifier,
          _start * 1000,
          telemetryType,
          pageUri, {});
      telemetryEventData =
          TelemetryEventModel(userId: userId, eventData: eventData);
      await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
          isPublic: widget.isFeaturedCourse);
      allEventsData.add(eventData);
      telemetryService.triggerEvent(allEventsData);
      _timer?.cancel();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateContentProgress() async {
    // print("Current time: " + _currentProgressInSeconds.toString());
    // print("Video progress %: " + _currentProgressPercentage.toString());
    List<String> current = [];
    current.add((_currentProgressInSeconds.toString()));
    String courseId = widget.course['identifier'];
    String batchId = widget.batchId;
    String contentId = widget.identifier;
    int status = widget.status != 2
        ? _currentProgressPercentage >= 99
            ? 2
            : 1
        : 2;
    String contentType = EMimeTypes.youtube;
    var maxSize = widget.course['duration'];
    double completionPercentage =
        status == 2 ? 100.0 : _currentProgressPercentage;

    // developer.log(
    //     "Status $status, current: $current, completion%: $completionPercentage");
    await learnService.updateContentProgress(courseId, batchId, contentId,
        status, contentType, current, maxSize, completionPercentage);
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.identifier != _contentId) {
    //   print('Content changes...');
    //   _controller = YoutubePlayerController.fromVideoId(
    //     videoId: widget.url.split('/').last,
    //     autoPlay: true,
    //     startSeconds:
    //         (widget.currentProgress != null && widget.currentProgress != '')
    //             ? double.parse(widget.currentProgress.toString())
    //             : 0,
    //     params: const YoutubePlayerParams(showFullscreenButton: true),
    //   );
    // }
    return WillPopScope(
      onWillPop: () async {
        double time = await _controller.currentTime;
        double duration = await _controller.duration;
        setState(() {
          _currentProgressInSeconds = time;
          _currentProgressPercentage = (time / duration) * 100;
        });
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      backgroundColor: Colors.transparent,
                      pinned: false,
                      automaticallyImplyLeading: false,
                      // expandedHeight: 112,
                      flexibleSpace: InkWell(
                        onTap: () async {
                          double time = await _controller.currentTime;
                          double duration = await _controller.duration;
                          setState(() {
                            _currentProgressInSeconds = time;
                            _currentProgressPercentage =
                                (time / duration) * 100;
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.white70,
                                ),
                              ),
                              Text(
                                EnglishLang.back,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                  color: AppColors.white70,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ];
              },
              body: Center(
                child: Center(
                    child: Container(
                  width: double.infinity,
                  child: YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 9 / 16,
                  ),
                )),
              ),
            ),
          )),
    );
    // Center(
    //   child: Center(
    //       child: Container(
    //     width: double.infinity,
    //     child: YoutubePlayer(
    //       controller: _controller,
    //       aspectRatio: 9 / 16,
    //     ),
    //   )),
    // );
  }
}
