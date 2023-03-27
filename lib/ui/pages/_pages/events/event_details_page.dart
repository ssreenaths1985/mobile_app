import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/feedback/widgets/_microSurvey/page_loader.dart';
import 'package:karmayogi_mobile/models/_models/event_detail_model.dart';
import 'package:karmayogi_mobile/respositories/_respositories/event_repository.dart';
import 'package:karmayogi_mobile/ui/widgets/_events/event_overview.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../models/_models/telemetry_event_model.dart';
import '../../../../util/telemetry.dart';
import '../../../../util/telemetry_db_helper.dart';

class EventDetailsPage extends StatefulWidget {
  final eventId;
  EventDetailsPage({Key key, this.eventId}) : super(key: key);

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  EventDetail _event;

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
        TelemetryPageIdentifier.eventDetailsPageId,
        userSessionId,
        messageIdentifier,
        TelemetryType.page,
        TelemetryPageIdentifier.eventDetailsPageUri
            .replaceAll(':eventId', widget.eventId));
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<EventDetail> _getEventDetails(context) async {
    _event = await Provider.of<EventRepository>(context, listen: false)
        .getEventDetails(widget.eventId);
    return _event;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: _getEventDetails(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                // var course = snapshot.data;
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                          pinned: false,
                          expandedHeight: 450,
                          leading: BackButton(color: AppColors.greys60),
                          flexibleSpace: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 32, 0, 32),
                                      child: Center(),
                                    )
                                  ]),
                              Container(
                                  width: double.infinity,
                                  child: (_event.eventIcon != null &&
                                          _event.eventIcon != '')
                                      ? Image.network(
                                          _event.eventIcon,
                                          // fit: BoxFit.cover,
                                          fit: BoxFit.cover,
                                          // width: 292,
                                          // height: 125,
                                        )
                                      : Image.asset(
                                          'assets/img/image_placeholder.jpg',
                                          // width: 320,
                                          // height: 182,
                                          fit: BoxFit.cover,
                                        )),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Text(
                                  _event.name,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 16),
                                child: Text(
                                  _event.instructions,
                                  // maxLines: 2,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    height: 1.5,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 16, right: 330, top: 8, bottom: 10),
                              //   child: Container(
                              //     height: 48,
                              //     width: 48,
                              //     decoration: BoxDecoration(
                              //       image: DecorationImage(
                              //           image: AssetImage(
                              //               'assets/img/igot_icon.png'),
                              //           fit: BoxFit.scaleDown),
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.all(
                              //           const Radius.circular(4.0)),
                              //       // shape: BoxShape.circle,
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: AppColors.grey08,
                              //           blurRadius: 3,
                              //           spreadRadius: 0,
                              //           offset: Offset(
                              //             3,
                              //             3,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          )),
                    ];
                  },

                  // TabBar view
                  body: Container(
                    color: AppColors.lightBackground,
                    child: EventOverview(
                      eventDetail: _event,
                    ),
                  ),
                );
              } else {
                // return Center(child: CircularProgressIndicator());
                return PageLoader();
              }
            }),
      ),
    );
  }
}
