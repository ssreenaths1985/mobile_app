import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/constants/_constants/app_constants.dart';
import 'package:karmayogi_mobile/env/env.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../constants/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CourseHtmlPlayer extends StatefulWidget {
  final course;
  final String identifier;
  final String url;
  final String batchId;
  final ValueChanged<bool> parentAction1;
  final ValueChanged<Map> parentAction2;
  final ValueChanged<bool> parentAction3;
  final bool isLearningResource;
  final bool isFeaturedCourse;

  CourseHtmlPlayer(this.course, this.identifier, this.url, this.batchId,
      this.parentAction1, this.parentAction2,
      {this.isLearningResource = false,
      this.parentAction3,
      this.isFeaturedCourse = false});

  _CourseHtmlPlayerState createState() => _CourseHtmlPlayerState();
}

class _CourseHtmlPlayerState extends State<CourseHtmlPlayer> {
  final LearnService learnService = LearnService();
  final TelemetryService telemetryService = TelemetryService();
  WebViewController controller;
  // bool _fullScreen = false;
  String _identifier;
  List _identifiers = [];

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

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  void initState() {
    super.initState();
    _identifier = widget.identifier;

    if (_start == 0) {
      pageIdentifier = TelemetryPageIdentifier.htmlPlayerPageId;
      telemetryType = TelemetryType.player;
      var batchId = widget.course['batches'] != null
          ? (widget.course['batches'].runtimeType == String
              ? jsonDecode(widget.course['batches'])
              : widget.course['batches'])[0]['batchId']
          : '';
      pageUri =
          'viewer/html/${widget.identifier}?primaryCategory=Learning%20Resource&collectionId=${widget.course['identifier']}&collectionType=Course&batchId=$batchId';
      _generateTelemetryData();
    }
    _startTimer();
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

  String _getContentEntryPage(url, identifier) {
    // print("ID: " + widget.identifier.toString());
    // print("Streaming URL: " + widget.course['streamingUrl'].toString());
    // List segments = url.split('/');
    String entryPage;
    if (widget.course['streamingUrl'] != null &&
        widget.course['streamingUrl'] != '') {
      entryPage = widget.isLearningResource
          ? (widget.course['streamingUrl'] +
              '/story.html?timestamp=\'' +
              DateTime.now().millisecondsSinceEpoch.toString())
          : widget.course['streamingUrl'];
      // print('Qaz: ' + entryPage);
    } else {
      entryPage = Env.host +
          Env.bucket +
          // '/' +
          // segments[4] +
          '/html/' +
          identifier +
          Env.entryPageFileName +
          '?timestamp=\'' +
          DateTime.now().millisecondsSinceEpoch.toString();
      // print('Entry page: ' + entryPage.toString());
    }
    if (!widget.isFeaturedCourse) {
      _updateContentProgress();
    }
    return entryPage;
  }

  @override
  void dispose() async {
    super.dispose();
    if (!widget.isFeaturedCourse) {
      _updateContentProgress();
    }
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

  Future<void> _updateContentProgress() async {
    List<String> current = [];

    current.add(10.toString());
    String courseId = widget.course['identifier'];
    String batchId = widget.batchId;
    String contentId = widget.identifier;
    int status = 2;
    String contentType = EMimeTypes.externalLink;
    var maxSize = widget.course['duration'];
    // double completionPercentage =
    //     status == 2 ? 100.0 : (_start / maxSize) * 100;
    double completionPercentage = 100.0;
    await learnService.updateContentProgress(courseId, batchId, contentId,
        status, contentType, current, maxSize, completionPercentage);
    // print('response: ' + response.toString());
  }

  Widget showUrlButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              await controller.data.currentUrl();
              // print('CURRENT URL: $url');
            },
            child: Icon(Icons.link),
          );
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_identifier != widget.identifier) {
      // setState(() {
      //   _identifier = widget.identifier;
      // });
      controller.loadUrl(_getContentEntryPage(widget.url, widget.identifier));
      if (!_identifiers.contains(_identifier)) {
        Map data = {
          'identifier': _identifier,
          'surveyCompleted': 100.0,
          'completionPercentage': 100.0
        };
        if (!widget.isFeaturedCourse) {
          widget.parentAction2(data);
        }
      }
      _identifiers.add(_identifier);
    }
    return widget.identifier != null && widget.identifier != ''
        ? Stack(children: [
            Center(
                // child: HtmlWidget(
                //   '''<iframe allow="fullscreen; accelerometer; autoplay; encrypted-media; gyroscope; microphone; camera;" src="''' +
                //       _getContentEntryPage(widget.url, widget.identifier) +
                //       '''" title=" HTML Content Viewer" allowfullscreen></iframe>''',
                //   webView: true,
                // ),
                child: WebView(
              initialUrl: _getContentEntryPage(widget.url, widget.identifier),
              javascriptMode: JavascriptMode.unrestricted,
              // initialUrl: url,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // onPageStarted: (String url) {
              //   // print('Page started loading: $url');
              // },
              onPageFinished: (String url) {
                // print('FINISHED: $url');
              },
              gestureNavigationEnabled: true,
              navigationDelegate: (NavigationRequest request) {
                // print('ALLOWING navigation to $request');
                return NavigationDecision.navigate;
              },
            )),
            // Positioned(
            //     bottom: 5,
            //     right: 5,
            //     child: Container(
            //         // height: 15,
            //         // color: Colors.red,
            //         child: Row(
            //       children: [
            //         showUrlButton(),
            //         // _fullScreen
            //         //     ? IconButton(
            //         //         icon: Icon(
            //         //           Icons.fullscreen_exit,
            //         //           color: Colors.white,
            //         //         ),
            //         //         onPressed: () {
            //         //           // setState(() {
            //         //           _fullScreen = false;
            //         //           // });
            //         //           widget.parentAction1(_fullScreen);
            //         //         },
            //         //       )
            //         //     :
            //         //     IconButton(
            //         //         icon: Icon(
            //         //           Icons.fullscreen,
            //         //           color: Colors.white,
            //         //         ),
            //         //         onPressed: () {
            //         //           // setState(() {
            //         //           _fullScreen = true;
            //         //           // });
            //         //           widget.parentAction1(_fullScreen);
            //         //         },
            //         //       ),
            //       ],
            //     )))
          ])
        : Center();
  }
}
