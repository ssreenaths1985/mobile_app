import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:video_player/video_player.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../widgets/index.dart';
// import './../../../../util/faderoute.dart';
import './../../../../constants/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class CourseVideoPlayer extends StatefulWidget {
  final course;
  final String identifier;
  final String fileUrl;
  final String mimeType;
  final bool updateProgress;
  final currentProgress;
  final int status;
  final String batchId;
  final ValueChanged<Map> parentAction;
  final bool isPlatformWalkThrough;
  final bool isFeatured;

  CourseVideoPlayer(
      {this.course,
      this.identifier,
      this.fileUrl,
      this.mimeType,
      this.updateProgress = false,
      this.currentProgress,
      this.status,
      this.batchId,
      this.parentAction,
      this.isPlatformWalkThrough = false,
      this.isFeatured = false});
  @override
  _CourseVideoPlayerState createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  VideoPlayerController _videoPlayerController1;
  // VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  final LearnService learnService = LearnService();
  final TelemetryService telemetryService = TelemetryService();
  bool showVideo = false;
  bool showLoader = true;
  int _currentProgress;
  String _identifier;
  int _progressStatus;

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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => CourseVideoAssessment()),
        // );
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
          pageIdentifier = TelemetryPageIdentifier.videoPlayerPageId;
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
    userId = await Telemetry.getUserId(isPublic: widget.isFeatured);
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId(isPublic: widget.isFeatured);

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
        isPublic: widget.isFeatured);
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
        isPublic: widget.isFeatured);
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
    _videoPlayerController1.dispose();
    // _videoPlayerController2.dispose();
    if (widget.updateProgress && !widget.isFeatured) {
      _updateContentProgress(_identifier, _progressStatus);
    }
    if (_chewieController != null) {
      _chewieController.pause();
      _chewieController.dispose();
    }
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
          isPublic: widget.isFeatured);
      // telemetryService.triggerEvent(allEventsData);
      _timer.cancel();
    }
  }

  Future<void> initializePlayer() async {
    // log('Progress: ${widget.currentProgress}');
    if (widget.identifier != '' && widget.currentProgress != 0) {
      setState(() {
        // double.parse(widget.currentProgress.toString())
        _currentProgress = int.parse((widget.currentProgress).split('.').first);
      });
    } else {
      setState(() {
        _currentProgress = 0;
      });
    }
    // log('Current Progress ' + _currentProgress.toString());

    _videoPlayerController1 = VideoPlayerController.network(widget.fileUrl);
    // _videoPlayerController2 = VideoPlayerController.network(
    //     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      _videoPlayerController1.initialize(),
      // _videoPlayerController2.initialize()
    ]);
    _chewieController = ChewieController(
      deviceOrientationsOnEnterFullScreen: widget.isPlatformWalkThrough
          ? ([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
          : null,
      // aspectRatio: 9 / 16,
      videoPlayerController: _videoPlayerController1,
      autoPlay: widget.identifier == '' && !showVideo ? false : true,
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
    _videoPlayerController1.seekTo(Duration(seconds: _currentProgress));
    setState(() {
      showLoader = false;
    });
  }

  Future<void> _updateContentProgress(
      String contentIdentifier, int progressStatus) async {
    if (widget.batchId != null && !widget.isFeatured) {
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
      String contentType = widget.fileUrl.split('.').last == 'mp3'
          ? EMimeTypes.mp3
          : EMimeTypes.mp4;
      var maxSize = duration;
      double completionPercentage = (currentPosition / duration) * 100;
      if (completionPercentage >= 99) {
        completionPercentage = 100;
        status = 2;
      }
      // if (status == 2) {
      //   completionPercentage = 100;
      // }
      // print(completionPercentage);
      await learnService.updateContentProgress(courseId, batchId, contentId,
          status, contentType, current, maxSize, completionPercentage);
      // print('currentPosition: $currentPosition');
      // log("Status $status, completionPercentage $completionPercentage ");
      Map data = {
        'identifier': contentId,
        'mimeType': EMimeTypes.mp4,
        'current': currentPosition.toString(),
        'completionPercentage': completionPercentage
      };
      widget.parentAction(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    // log(_videoPlayerController1.value.duration.toString());
    if (_identifier != widget.identifier && widget.identifier != '') {
      _updateContentProgress(_identifier, _progressStatus);
      // print('Video changed...');

      if (_chewieController != null) _chewieController.pause();
      if (_videoPlayerController1 != null) _videoPlayerController1.pause();

      setState(() {
        showLoader = true;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        initializePlayer();
      });
      _identifier = widget.identifier;
      _progressStatus = widget.status;
    }
    return !showLoader
        ? Column(children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : PageLoader(),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     _chewieController.enterFullScreen();
            //   },
            //   child: const Text('Fullscreen'),
            // ),
            Row(
              children: <Widget>[
                // Expanded(
                //   child: TextButton(
                //     onPressed: () {
                //       setState(() {
                //         _chewieController.dispose();
                //         _videoPlayerController1.pause();
                //         _videoPlayerController1.seekTo(const Duration());
                //         _chewieController = ChewieController(
                //           videoPlayerController: _videoPlayerController1,
                //           autoPlay: true,
                //           looping: true,
                //         );
                //       });
                //     },
                //     child: const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 16.0),
                //       child: Text("Landscape Video"),
                //     ),
                //   ),
                // ),
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () {
                //           setState(() {
                //             _chewieController.dispose();
                //             _videoPlayerController2.pause();
                //             _videoPlayerController2.seekTo(const Duration());
                //             _chewieController = ChewieController(
                //               videoPlayerController: _videoPlayerController2,
                //               autoPlay: true,
                //               looping: true,
                //             );
                //           });
                //         },
                //         child: const Padding(
                //           padding: EdgeInsets.symmetric(vertical: 16.0),
                //           child: Text("Portrait Video"),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () {
                //           setState(() {
                //             _platform = TargetPlatform.android;
                //           });
                //         },
                //         child: const Padding(
                //           padding: EdgeInsets.symmetric(vertical: 16.0),
                //           child: Text("Android controls"),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () {
                //           setState(() {
                //             _platform = TargetPlatform.iOS;
                //           });
                //         },
                //         child: const Padding(
                //           padding: EdgeInsets.symmetric(vertical: 16.0),
                //           child: Text("iOS controls"),
                //         ),
                //       ),
                //     )
                //   ],
                // )
              ],
            ),
          ])
        : PageLoader();
  }
}
