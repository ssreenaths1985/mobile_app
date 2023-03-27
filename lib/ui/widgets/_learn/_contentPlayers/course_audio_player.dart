import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:video_player/video_player.dart';
import '../../../../constants/_constants/app_constants.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../models/_models/telemetry_event_model.dart';
import '../../../../services/_services/learn_service.dart';
import '../../../pages/_pages/learn/course_video_assessment.dart';
import './../../../widgets/index.dart';

class CourseAudioPlayer extends StatefulWidget {
  final String identifier;
  final String fileUrl;
  final String batchId;
  final int status;
  final bool updateProgress;
  final course;
  final ValueChanged<Map> parentAction;
  final bool isFeaturedCourse;
  CourseAudioPlayer(
      {this.identifier,
      this.fileUrl,
      this.batchId,
      this.course,
      this.status,
      this.updateProgress,
      this.parentAction,
      this.isFeaturedCourse = false});
  @override
  _CourseAudioPlayerState createState() => _CourseAudioPlayerState();
}

class _CourseAudioPlayerState extends State<CourseAudioPlayer> {
  VideoPlayerController _videoPlayerController1;
  // VideoPlayerController _videoPlayerController2;
  final LearnService learnService = LearnService();
  ChewieController _chewieController;
  String _identifier;
  int _progressStatus;

  bool showVideo = false;

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
  bool _playerStatus = false;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _identifier = widget.identifier;
    _progressStatus = widget.status;

    initializePlayer();
    _videoPlayerController1.addListener(() {
      if (_videoPlayerController1.value.position ==
              _videoPlayerController1.value.duration &&
          widget.identifier == '' &&
          !showVideo) {
        setState(() {
          showVideo = true;
        });
        // print('*** Video Ended ***');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseVideoAssessment()),
        );
        // FadeRoute(page: ComingSoonScreen());
      } else {
        if (_playerStatus != _videoPlayerController1.value.isPlaying) {
          if (_videoPlayerController1.value.isPlaying) {
            _generateInteractTelemetryData(widget.identifier,
                subType: TelemetrySubType.playButton);
          } else {
            _generateInteractTelemetryData(widget.identifier,
                subType: TelemetrySubType.pauseButton);
          }
        }
        _playerStatus = _videoPlayerController1.value.isPlaying;
        if ((_start == 0 && widget.course['batches'] != null)) {
          allEventsData = [];
          pageIdentifier = TelemetryPageIdentifier.audioPlayerPageId;
          telemetryType = TelemetryType.player;
          String assetFile =
              widget.fileUrl.contains(EMimeTypes.mp4) ? 'video' : 'audio';
          var batchId = widget.course['batches'] != null
              ? widget.course['batches'][0]['batchId']
              : '';
          pageUri =
              'viewer/$assetFile/${widget.identifier}?primaryCategory=Learning%20Resource&collectionId=${widget.course['identifier']}&collectionType=Course&batchId=$batchId';
          _generateTelemetryData();
        }
        _startTimer();
      }
    });
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        _start++;
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

  void _generateInteractTelemetryData(String contentId,
      {String subType = ''}) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        contentId,
        subType);
    allEventsData.add(eventData);
  }

  @override
  void dispose() async {
    super.dispose();
    if (widget.updateProgress && !widget.isFeaturedCourse) {
      _updateContentProgress(_identifier, _progressStatus);
    }
    _videoPlayerController1.dispose();
    // _videoPlayerController2.dispose();
    _chewieController.dispose();
    if (widget.identifier != '' && widget.course['batches'] != null) {
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
      allEventsData.add(eventData);
      telemetryEventData =
          TelemetryEventModel(userId: userId, eventData: eventData);
      await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
          isPublic: widget.isFeaturedCourse);
      // telemetryService.triggerEvent(allEventsData);
      _timer.cancel();
    }
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.fileUrl);
    // _videoPlayerController2 = VideoPlayerController.network(
    //     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      _videoPlayerController1.initialize(),
      // _videoPlayerController2.initialize()
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      // Try playing around with some of these other options:

      // showControls: false,
      showOptions: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  Future<void> _updateContentProgress(
      String contentIdentifier, int progressStatus) async {
    // print('_updateContentProgress...');
    if (widget.batchId != null && !widget.isFeaturedCourse) {
      List<String> current = [];
      double currentPosition = 0.0;
      double duration = 0.0;
      List position =
          _videoPlayerController1.value.position.toString().split(':');
      List totalTime =
          _videoPlayerController1.value.duration.toString().split(':');
      // print(totalTime);
      currentPosition = double.parse(position[0]) * 60 * 60 +
          double.parse(position[1]) * 60 +
          double.parse(position[2]);
      duration = double.parse(totalTime[0]) * 60 * 60 +
          double.parse(totalTime[1]) * 60 +
          double.parse(totalTime[2]);
      current.add(currentPosition.toString());
      String courseId = widget.course['identifier'];
      String batchId = widget.batchId;
      String contentId = contentIdentifier;
      int status = progressStatus != 2
          ? currentPosition == duration
              ? 2
              : 1
          : 2;
      String contentType = EMimeTypes.mp3;
      var maxSize = duration;
      double completionPercentage = (currentPosition / duration) * 100;
      if (completionPercentage >= 99) {
        completionPercentage = 100;
        status = 2;
      }
      // if (completionPercentage == 100) {
      //   status = 2;
      // }
      // if (status == 2) {
      //   completionPercentage = 100;
      // }
      await learnService.updateContentProgress(courseId, batchId, contentId,
          status, contentType, current, maxSize, completionPercentage);
      // print('currentPosition: $currentPosition');
      Map data = {
        'identifier': contentId,
        'mimeType': EMimeTypes.mp3,
        'current': currentPosition.toString(),
        'completionPercentage': completionPercentage
      };
      widget.parentAction(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_identifier != widget.identifier && widget.identifier != '') {
      _updateContentProgress(_identifier, _progressStatus);
      // print('Video changed...');

      if (_chewieController != null) _chewieController.pause();
      if (_videoPlayerController1 != null) _videoPlayerController1.pause();

      Future.delayed(const Duration(milliseconds: 500), () {
        initializePlayer();
      });
      _identifier = widget.identifier;
      _progressStatus = widget.status;
    }
    return Column(children: <Widget>[
      Expanded(
        child: Center(
          child: _chewieController != null
              ? Chewie(
                  controller: _chewieController,
                )
              : PageLoader(),
        ),
      ),
    ]);
  }
}
