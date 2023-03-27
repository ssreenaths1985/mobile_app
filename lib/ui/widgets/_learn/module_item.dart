// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import '../../../constants/_constants/telemetry_constants.dart';
// import '../../../feedback/pages/_pages/_cbpSurvey/content_feedback.dart';
import './../../../constants/index.dart';
import './../../../services/index.dart';
import './../../../ui/widgets/index.dart';
// import './../../../ui/pages/index.dart';
// import './../../../util/faderoute.dart';
import './../../../util/telemetry.dart';
import './../../../util/telemetry_db_helper.dart';
// import 'dart:developer' as developer;

class ModuleItem extends StatefulWidget {
  final course;
  final int moduleIndex;
  final String moduleName;
  final List glanceListItems;
  final contentProgressResponse;
  final navigation;
  final bool initiallyExpanded;
  final String batchId;
  final ValueChanged<bool> parentAction;
  final isCourse;
  final bool isFeatured;
  final dynamic duration;

  const ModuleItem(
      {Key key,
      this.course,
      this.moduleIndex,
      this.moduleName,
      this.glanceListItems,
      this.contentProgressResponse,
      this.navigation,
      this.initiallyExpanded = false,
      this.batchId,
      this.parentAction,
      this.isCourse = false,
      this.isFeatured = false,
      this.duration})
      : super(key: key);

  @override
  _ModuleItemState createState() => _ModuleItemState();
}

class _ModuleItemState extends State<ModuleItem> {
  final TelemetryService telemetryService = TelemetryService();
  double _moduleProgress = 0;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String pageIdentifier;
  List _glanceListItems;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _glanceListItems = widget.glanceListItems;
    if (!widget.isFeatured) {
      _generateTelemetryData();
    }
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
  }

  void _generateInteractTelemetryData(String contentId, String mimeType) async {
    // String pageIdentifier = TelemetryPageIdentifier.courseDetailsPageUri
    //     .replaceAll(':do_ID', widget.course['identifier']);

    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.courseDetailsPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.contentCard);
    List allEventsData = [];
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    // telemetryService.triggerEvent(allEventsData);
  }

  void _calculateModuleProgress() {
    double _moduleProgressSum = 0.0;
    for (int i = 0; i < _glanceListItems.length; i++) {
      if (_glanceListItems[i]['status'] == 2) {
        _moduleProgressSum = _moduleProgressSum + 1;
      } else if (_glanceListItems[i]['completionPercentage'] != '0' &&
          _glanceListItems[i]['completionPercentage'] != null) {
        _moduleProgressSum =
            _moduleProgressSum + _glanceListItems[i]['completionPercentage'];
      }
    }
    _moduleProgress = _moduleProgressSum / _glanceListItems.length;
  }

  void updateProgress(Map data) {
    for (int i = 0; i < _glanceListItems.length; i++) {
      if (_glanceListItems[i]['identifier'] == data['identifier']) {
        _glanceListItems[i]['completionPercentage'] =
            data['completionPercentage'];

        if (data['completionPercentage'] == 100.0) {
          _glanceListItems[i]['status'] = 2;
        }
      }
    }
    _calculateModuleProgress();
  }

  updateContentProgress(bool status) {
    widget.parentAction(status);
  }

  @override
  void dispose() {
    if (widget.batchId != null) {
      widget.parentAction(true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isFeatured) {
      _calculateModuleProgress();
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(4.0)),
          color: Colors.white),
      child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {});
          },
          initiallyExpanded: widget.initiallyExpanded,
          backgroundColor: Colors.white,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: SvgPicture.asset(
                  widget.isCourse
                      ? 'assets/img/course_icon.svg'
                      : 'assets/img/icons-file-types-module.svg',
                  color: AppColors.greys87,
                  // alignment: Alignment.topLeft,
                ),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.moduleName,
                      style: GoogleFonts.lato(
                          height: 1.5,
                          decoration: TextDecoration.none,
                          color: AppColors.greys87,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    (widget.duration != null && widget.duration != '')
                        ? Text(widget.duration,
                            style: GoogleFonts.lato(
                                height: 1.5,
                                decoration: TextDecoration.none,
                                color: AppColors.greys87,
                                fontSize: 14,
                                fontWeight: FontWeight.w400))
                        : Center()
                  ],
                ),
              )),
              !widget.isFeatured
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4, right: 0),
                      child: Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            backgroundColor: AppColors.grey16,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.positiveLight,
                            ),
                            strokeWidth: 3,
                            value: _moduleProgress),
                      ),
                    )
                  : Center()
            ],
          ),
          children: [
            for (int i = 0; i < _glanceListItems.length; i++)
              InkWell(
                onTap: widget.course['primaryCategory'] != EnglishLang.program
                    ? () {
                        if (!widget.isFeatured) {
                          _generateInteractTelemetryData(
                              _glanceListItems[i]['identifier'],
                              _glanceListItems[i]['mimeType']);
                          // if (_glanceListItems[i]['mimeType'] ==
                          //     EMimeTypes.assessment) {
                          //   Navigator.push(
                          //       context,
                          //       FadeRoute(
                          //           page: CourseAssessmentPlayer(
                          //               widget.course,
                          //               _glanceListItems[i]['name'],
                          //               _glanceListItems[i]['identifier'],
                          //               _glanceListItems[i]['artifactUrl'],
                          //               updateProgress,
                          //               widget.batchId,
                          //               _glanceListItems[i]['duration'])));
                          // } else if (_glanceListItems[i]['mimeType'] ==
                          //     EMimeTypes.survey) {
                          //   if (_glanceListItems[i]['status'] != 2) {
                          //     Navigator.push(
                          //         context,
                          //         FadeRoute(
                          //             page: ContentFeedback(
                          //                 _glanceListItems[i]['artifactUrl'],
                          //                 _glanceListItems[i]['name'],
                          //                 widget.course,
                          //                 _glanceListItems[i]['identifier'],
                          //                 widget.batchId)));
                          //   } else {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         content:
                          //             Text(EnglishLang.surveyAlreadySubmitted,
                          //                 style: GoogleFonts.lato(
                          //                   color: Colors.white,
                          //                 )),
                          //         backgroundColor: AppColors.positiveLight,
                          //       ),
                          //     );
                          //   }
                          // } else {
                          //   Navigator.push(
                          //       context,
                          //       FadeRoute(
                          //           page: CourseNavigationPage(
                          //         course: widget.course,
                          //         identifier: _glanceListItems[i]['identifier'],
                          //         contentProgress:
                          //             widget.contentProgressResponse,
                          //         navigation: widget.navigation,
                          //         moduleName: widget.moduleName,
                          //         batchId: widget.batchId,
                          //         parentAction: updateContentProgress,
                          //       )));
                          // }
                        }
                      }
                    : null,
                child: _glanceListItems[i]['mimeType'] != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GlanceItem3(
                          icon: (_glanceListItems[i]['mimeType'] ==
                                      EMimeTypes.mp4 ||
                                  _glanceListItems[i]['mimeType'] ==
                                      EMimeTypes.m3u8 ||
                                  _glanceListItems[i]['mimeType'] ==
                                      EMimeTypes.mp3)
                              ? 'assets/img/icons-av-play.svg'
                              : (_glanceListItems[i]['mimeType'] ==
                                          EMimeTypes.externalLink ||
                                      _glanceListItems[i]['mimeType'] ==
                                          EMimeTypes.youtubeLink)
                                  ? 'assets/img/link.svg'
                                  : _glanceListItems[i]['mimeType'] ==
                                          EMimeTypes.pdf
                                      ? 'assets/img/icons-file-types-pdf-alternate.svg'
                                      : (_glanceListItems[i]['mimeType'] ==
                                                  EMimeTypes.assessment ||
                                              _glanceListItems[i]['mimeType'] ==
                                                  EMimeTypes.newAssessment)
                                          ? 'assets/img/assessment_icon.svg'
                                          : 'assets/img/resource.svg',
                          text: _glanceListItems[i]['name'],
                          status: _glanceListItems[i]['status'],
                          duration: _glanceListItems[i]['duration'],
                          isFeaturedCourse: widget.isFeatured,
                          currentProgress: _glanceListItems[i]
                              ['completionPercentage'],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(8),
                        child: Text('No contents available')),
              ),
          ]),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import './../../../constants/index.dart';
// import './../../../ui/widgets/index.dart';
// import './../../../ui/pages/index.dart';
// import './../../../util/faderoute.dart';

// class ModuleItem extends StatefulWidget {
//   final course;
//   final int moduleIndex;
//   final String moduleName;
//   final List glanceListItems;
//   final contentProgressResponse;
//   final navigation;
//   final bool initiallyExpanded;

//   const ModuleItem(
//       {Key key,
//       this.course,
//       this.moduleIndex,
//       this.moduleName,
//       this.glanceListItems,
//       this.contentProgressResponse,
//       this.navigation,
//       this.initiallyExpanded = false})
//       : super(key: key);

//   @override
//   _ModuleItemState createState() => _ModuleItemState();
// }

// class _ModuleItemState extends State<ModuleItem> {
//   double _moduleProgress = 0;

//   @override
//   void initState() {
//     super.initState();
//     calculate_moduleProgress();
//   }

//   void calculate_moduleProgress() {
//     double _moduleProgressSum = 0;
//     for (int i = 0; i < _glanceListItems.length; i++)
//       _moduleProgressSum = _moduleProgressSum +
//           double.parse(_glanceListItems[i]['currentProgress']);
//     _moduleProgress = _moduleProgressSum / _glanceListItems.length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(const Radius.circular(4.0)),
//             color: Colors.white),
//         child: ExpansionTile(
//             onExpansionChanged: (value) {},
//             initiallyExpanded: widget.initiallyExpanded,
//             backgroundColor: Colors.white,
//             title: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5, left: 15),
//                   child: SvgPicture.asset(
//                     'assets/img/icons-file-types-module.svg',
//                     // color: AppColors.greys87,
//                     // alignment: Alignment.topLeft,
//                   ),
//                 ),
//                 Expanded(
//                     child: Container(
//                   padding: const EdgeInsets.only(left: 16),
//                   child: Text(
//                     widget.moduleName,
//                     style: GoogleFonts.lato(
//                         height: 1.5,
//                         decoration: TextDecoration.none,
//                         color: AppColors.greys87,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 )),
//                 Container(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                       backgroundColor: AppColors.grey16,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         AppColors.positiveLight,
//                       ),
//                       strokeWidth: 3,
//                       value: 0.5),
//                 )
//               ],
//             ),
//             children: [
//               for (int i = 0; i < _glanceListItems.length; i++)
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         FadeRoute(
//                             page: CourseNavigationPage(
//                           course: widget.course,
//                           identifier: _glanceListItems[i]['identifier'],
//                           contentProgress: widget.contentProgressResponse,
//                           navigation: widget.navigation,
//                           moduleName: widget.moduleName,
//                         )));
//                   },
//                   child: GlanceItem3(
//                       icon: (_glanceListItems[i]['mimeType'] ==
//                                   EMimeTypes.mp4 ||
//                               _glanceListItems[i]['mimeType'] ==
//                                   EMimeTypes.m3u8 ||
//                               _glanceListItems[i]['mimeType'] ==
//                                   EMimeTypes.mp3)
//                           ? 'assets/img/icons-av-play.svg'
//                           : _glanceListItems[i]['mimeType'] ==
//                                   EMimeTypes.externalLink
//                               ? 'assets/img/link.svg'
//                               : _glanceListItems[i]['mimeType'] ==
//                                       EMimeTypes.pdf
//                                   ? 'assets/img/icons-file-types-pdf-alternate.svg'
//                                   : _glanceListItems[i]['mimeType'] ==
//                                           EMimeTypes.assessment
//                                       ? 'assets/img/assessment_icon.svg'
//                                       : 'assets/img/resource.svg',
//                       text: _glanceListItems[i]['name'],
//                       status: _glanceListItems[i]['status'],
//                       duration: _glanceListItems[i]['duration']),
//                 ),
//             ]),
//       ),
//     );
//   }
// }
