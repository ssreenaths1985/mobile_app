import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';

import '../../../../constants/_constants/color_constants.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../models/_models/telemetry_event_model.dart';
import '../../../../util/telemetry.dart';
import '../../../../util/telemetry_db_helper.dart';
import '../../../widgets/_learn/_contentPlayers/course_video_player.dart';

class PlatformWalkThrough extends StatefulWidget {
  const PlatformWalkThrough({Key key}) : super(key: key);

  @override
  State<PlatformWalkThrough> createState() => _PlatformWalkThroughState();
}

class _PlatformWalkThroughState extends State<PlatformWalkThrough> {
  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _generateTelemetryData();
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
      TelemetryPageIdentifier.platformWalkThroughPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.platformWalkThroughPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            EnglishLang.platformWalkthrough.split('.').last,
            style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
              height: 240,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 15.0),
              child: CourseVideoPlayer(
                course: {},
                identifier: '',
                fileUrl:
                    'https://igot.blob.core.windows.net/public/mobile-video-guide.mp4',
                mimeType: '',
                isPlatformWalkThrough: true,
              ))
        ],
      ),
    );
  }
}
