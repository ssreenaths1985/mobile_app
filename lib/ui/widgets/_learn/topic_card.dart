import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/ui/pages/index.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import './../../../constants/index.dart';

// ignore: must_be_immutable
class TopicCard extends StatelessWidget {
  final CourseTopics courseTopics;
  final String name;
  final int count;
  final Color cardColor;
  final double paddingLeft;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String deviceIdentifier;
  var telemetryEventData;

  TopicCard(
      {this.name = '',
      this.count = 0,
      this.cardColor,
      this.courseTopics,
      this.paddingLeft = 16.0});

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
        contentId + '-menu',
        TelemetrySubType.sideMenu);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _generateInteractTelemetryData(courseTopics.name);
          Navigator.push(
            context,
            FadeRoute(
                page: TopicCourses(courseTopics.identifier, courseTopics.name,
                    courseTopics.raw)),
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: paddingLeft, bottom: 16),
          child: Container(
            height: 150,
            width: (MediaQuery.of(context).size.width) / 2 - 25,
            // width: 172,s
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(const Radius.circular(8.0)),
              border: Border.all(color: AppColors.grey16),
              color: Colors.white,
            ),
            child: Stack(children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/img/topics_bg.svg',
                  alignment: Alignment.topRight,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          courseTopics.name,
                          maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 16, top: 8),
                    //   child: Text(
                    //     '${courseTopics.noOfHoursConsumed} hours in last week',
                    //     style: GoogleFonts.lato(
                    //         color: AppColors.greys60,
                    //         fontSize: 12.0,
                    //         fontWeight: FontWeight.w400),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
