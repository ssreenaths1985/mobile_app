import 'dart:async';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:karmayogi_mobile/models/index.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../services/index.dart';
import './../../../../constants/index.dart';
import './../../../widgets/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class CoursePdfPlayer extends StatefulWidget {
  final course;
  final String identifier;
  final String fileUrl;
  final currentProgress;
  final status;
  final String batchId;
  final ValueChanged<bool> parentAction1;
  final ValueChanged<Map> parentAction2;
  final bool isFeaturedCourse;

  CoursePdfPlayer(
      {this.course,
      this.identifier,
      this.fileUrl,
      this.currentProgress,
      this.status,
      this.batchId,
      this.parentAction1,
      this.parentAction2,
      this.isFeaturedCourse});

  @override
  _CoursePdfPlayerState createState() => _CoursePdfPlayerState();
}

class _CoursePdfPlayerState extends State<CoursePdfPlayer> {
  final LearnService learnService = LearnService();
  final TelemetryService telemetryService = TelemetryService();
  bool _isLoading = true;
  PDFDocument document;
  PageController _pageController;
  int _currentProgress;
  List<String> current = [];
  bool _fullScreen = false;
  String _identifier;

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

  @override
  void initState() {
    super.initState();
    // print('currentProgress: ' +
    //     widget.currentProgress.toString() +
    //     ', status: ' +
    //     widget.status.toString());
    loadDocument();
    _identifier = widget.identifier;

    if (_start == 0) {
      pageIdentifier = TelemetryPageIdentifier.pdfPlayerPageId;
      telemetryType = TelemetryType.player;
      var batchId = widget.course['batches'] != null
          ? widget.course['batches'][0]['batchId']
          : '';
      pageUri =
          'viewer/pdf/${widget.identifier}?primaryCategory=Learning%20Resource&collectionId=${widget.course['identifier']}&collectionType=Course&batchId=$batchId';
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
        userId,
        deviceIdentifier,
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

  loadDocument() async {
    _currentProgress = int.parse(widget.currentProgress.toString());
    _pageController = PageController(
      initialPage: _currentProgress == 0
          ? _currentProgress
          : _currentProgress - 1, // first page number in the initializer
    );
    document = await PDFDocument.fromURL(
      widget.fileUrl,
    );
    _updateContentProgress(_pageController.initialPage, document.count);
    setState(() => _isLoading = false);
    // changePDF(2);
  }

  Future<void> _updateContentProgress(int currentPage, int totalPages) async {
    // print('_updateContentProgress: ${widget.batchId} $totalPages');
    if (widget.batchId != null && !widget.isFeaturedCourse) {
      if (currentPage == 0) {
        currentPage = 1;
      }
      currentPage = currentPage <= totalPages ? currentPage : totalPages;
      current.add(currentPage.toString());
      String courseId = widget.course['identifier'];
      String batchId = widget.batchId;
      String contentId = widget.identifier;
      int status = widget.status != 2
          ? currentPage == totalPages
              ? 2
              : 1
          : 2;
      String contentType = EMimeTypes.pdf;
      var maxSize = totalPages;
      double completionPercentage = currentPage / totalPages * 100;
      // print(
      //     'status = $status, page=$current, maxSize = $maxSize, completionPercentage = $completionPercentage');
      await learnService.updateContentProgress(courseId, batchId, contentId,
          status, contentType, current, maxSize, completionPercentage);
      // print(resp);
      Map data = {
        'identifier': widget.identifier,
        'mimeType': EMimeTypes.pdf,
        'current': currentPage.toString(),
        'completionPercentage': currentPage / totalPages * 100
      };
      widget.parentAction2(data);
      // print(rep.toString());
    }
  }

  // changePDF(value) async {
  //   setState(() => _isLoading = true);
  //   if (value == 1) {
  //     document = await PDFDocument.fromAsset('assets/pdf/sample.pdf');
  //   } else if (value == 2) {
  //     document = await PDFDocument.fromURL(
  //         // widget.fileUrl,
  //         'http://www.africau.edu/images/default/sample.pdf'
  //         /* cacheManager: CacheManager(
  //         Config(
  //           "customCacheKey",
  //           stalePeriod: const Duration(days: 2),
  //           maxNrOfCacheObjects: 10,
  //         ),
  //       ), */
  //         );
  //   } else {
  //     document = await PDFDocument.fromAsset('assets/pdf/sample2.pdf');
  //   }
  //   setState(() => _isLoading = false);
  //   return true;
  // }

  @override
  void dispose() async {
    super.dispose();
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
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_identifier != widget.identifier) {
      _identifier = widget.identifier;
      setState(() => _isLoading = true);
      loadDocument();
    }
    return Center(
      child: _isLoading
          ? PageLoader()
          : PDFViewer(
              document: document,
              controller: _pageController,
              zoomSteps: 1,
              showPicker: _fullScreen,
              //uncomment below line to preload all pages
              // lazyLoad: false,
              // uncomment below line to scroll vertically
              scrollDirection: Axis.vertical,

              //uncomment below code to replace bottom navigation with your own
              navigationBuilder:
                  (context, page, totalPages, jumpToPage, animateToPage) {
                return ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.first_page),
                      onPressed: () {
                        jumpToPage(page: totalPages - totalPages);
                        int currentPage = totalPages - totalPages + 1;
                        _generateInteractTelemetryData(widget.identifier,
                            subType: TelemetrySubType.firstPageButton);
                        if (!widget.isFeaturedCourse) {
                          _updateContentProgress(currentPage, totalPages);
                        }
                        // print('Page: $currentPage');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        animateToPage(page: page - 2);
                        int currentPage = page - 1;
                        _generateInteractTelemetryData(widget.identifier,
                            subType: TelemetrySubType.previousPageButton);
                        if (!widget.isFeaturedCourse) {
                          _updateContentProgress(currentPage, totalPages);
                        }
                        // print('Page: $currentPage');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        animateToPage(page: page);
                        int currentPage = page + 1;
                        _generateInteractTelemetryData(widget.identifier,
                            subType: TelemetrySubType.nextPageButton);
                        if (!widget.isFeaturedCourse) {
                          _updateContentProgress(currentPage, totalPages);
                        }
                        // print('Page: $currentPage');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.last_page),
                      onPressed: () {
                        jumpToPage(page: totalPages - 1);
                        int currentPage = totalPages;
                        _generateInteractTelemetryData(widget.identifier,
                            subType: TelemetrySubType.lastPageButton);
                        if (!widget.isFeaturedCourse) {
                          _updateContentProgress(currentPage, totalPages);
                        }
                        // print('Page: $currentPage');
                      },
                    ),
                    _fullScreen
                        ? IconButton(
                            icon: Icon(Icons.fullscreen_exit),
                            onPressed: () {
                              setState(() {
                                _fullScreen = false;
                              });
                              widget.parentAction1(_fullScreen);
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.fullscreen),
                            onPressed: () {
                              setState(() {
                                _fullScreen = true;
                              });
                              widget.parentAction1(_fullScreen);
                            },
                          ),
                  ],
                );
              },
            ),
    );
  }
}
