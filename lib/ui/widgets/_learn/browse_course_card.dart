import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/_models/course_model.dart';
import 'package:karmayogi_mobile/models/_models/telemetry_event_model.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/learn/course_details_page.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/learn/learning_resource_details_page.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';

import '../../../constants/_constants/telemetry_constants.dart';

// ignore: must_be_immutable
class BrowseCourseCard extends StatelessWidget {
  final Course course;
  final bool isProgram;

  BrowseCourseCard({this.course, this.isProgram = false});

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String deviceIdentifier;
  var telemetryEventData;

  void _generateInteractTelemetryData(String contentId) async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.topicCoursesPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.courseCard);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  @override
  Widget build(BuildContext context) {
    // print("Name: ${browseCompetencyCardModel.name}");
    var imageExtension;
    if (course.appIcon != null) {
      imageExtension = course.appIcon.substring(course.appIcon.length - 3);
    }
    return InkWell(
        onTap: () {
          _generateInteractTelemetryData(course.id);
          if (course.contentType == 'Learning Resource') {
            Navigator.push(
              context,
              FadeRoute(
                  page: LearningResourceDetailsPage(
                resource: course.raw,
              )),
            );
          } else {
            Navigator.push(
              context,
              FadeRoute(
                  page: CourseDetailsPage(
                id: course.id,
                isContinueLearning: false,
              )),
            );
          }
        },
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              image: course.appIcon != null
                                  ? DecorationImage(
                                      onError: (exception, stackTrace) =>
                                          AssetImage(
                                            'assets/img/image_placeholder.jpg',
                                          ),
                                      image: imageExtension != 'svg'
                                          ? NetworkImage(course.appIcon)
                                          : AssetImage(
                                              'assets/img/image_placeholder.jpg',
                                            ),
                                      fit: BoxFit.scaleDown)
                                  : DecorationImage(
                                      image: AssetImage(
                                        'assets/img/image_placeholder.jpg',
                                      ),
                                      fit: BoxFit.scaleDown),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(4.0)),
                              // shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.grey08,
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                  offset: Offset(
                                    3,
                                    3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.only(top: 100),
                          //   child: Row(
                          //     children: [
                          //       SvgPicture.asset(
                          //         'assets/img/Learn.svg',
                          //         width: 24.0,
                          //         height: 24.0,
                          //       ),
                          //       // Padding(
                          //       //   padding: const EdgeInsets.only(left: 4),
                          //       //   child: Text(
                          //       //     "4 CBP\'s",
                          //       //     style: GoogleFonts.lato(
                          //       //       color: AppColors.greys60,
                          //       //       fontWeight: FontWeight.w400,
                          //       //       fontSize: 10,
                          //       //     ),
                          //       //   ),
                          //       // ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  course.name != null ? course.name : '',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  course.source != null ? course.source : '',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          onError: (exception, stackTrace) =>
                                              AssetImage(
                                                  'assets/img/igot_creator_icon.png'),
                                          image: course.raw['creatorLogo'] !=
                                                  null
                                              ? NetworkImage(
                                                  Helper.convertToPortalUrl(
                                                      course
                                                          .raw['creatorLogo']))
                                              : AssetImage(
                                                  'assets/img/igot_creator_icon.png'),
                                          fit: BoxFit.scaleDown),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(4.0)),
                                      // shape: BoxShape.circle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Container(
                                      height: 24,
                                      // width: 90,
                                      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: AppColors.grey08),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(4.0)),
                                        // shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // assets/img/course_icon.svg
                                            SvgPicture.asset(
                                              'assets/img/course_icon.svg',
                                              width: 16.0,
                                              height: 16.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Text(
                                                course.contentType != null
                                                    ? course.contentType
                                                        .toUpperCase()
                                                    : 'UNKNOWN',
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  // Text(
                                  //   '4.5',
                                  //   style: GoogleFonts.lato(
                                  //     color: AppColors.primaryOne,
                                  //     fontWeight: FontWeight.w700,
                                  //     fontSize: 14,
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 4),
                                  //   child: Icon(
                                  //     Icons.star_sharp,
                                  //     size: 16,
                                  //     color: AppColors.primaryOne,
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 4, bottom: 5),
                                  //   child: Text(
                                  //     '.',
                                  //     style: GoogleFonts.lato(
                                  //       color: AppColors.greys60,
                                  //       fontWeight: FontWeight.w700,
                                  //       fontSize: 14,
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: course.duration != null
                                        ? Text(
                                            Helper.getTimeFormat(
                                                course.duration),
                                            style: GoogleFonts.lato(
                                              color: AppColors.greys60,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                            ),
                                          )
                                        : Text(''),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
