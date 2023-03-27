import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../constants/index.dart';
import './../../../../respositories/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class NetworkRequests extends StatefulWidget {
  @override
  _NetworkRequestsState createState() => _NetworkRequestsState();
}

class _NetworkRequestsState extends State<NetworkRequests> {
  final TelemetryService telemetryService = TelemetryService();

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  int _start = 0;
  List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _getConnectionRequest(context);
    if (_start == 0) {
      allEventsData = [];
      _generateTelemetryData();
    }
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
      TelemetryPageIdentifier.connectionRequestsPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.connectionRequestsPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  @override
  void dispose() async {
    super.dispose();
  }

  /// Get connection request response
  Future<void> _getConnectionRequest(context) async {
    try {
      return await Provider.of<NetworkRespository>(context, listen: false)
          .getCrList();
    } catch (err) {
      return err;
    }
  }

  /// Navigate to discussion detail
  // _navigateToDetail(tid) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ChangeNotifierProvider<DiscussRepository>(
  //         create: (context) => DiscussRepository(),
  //         child: DiscussionPage(tid: tid),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: _getConnectionRequest(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data.data.length > 0) {
              // print('Connection request: ' + snapshot.data.data.toString());
              return Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Wrap(
                    children: [ConnectionRequests(snapshot.data, true)],
                  ),
                ],
              );
            } else {
              return
                  // Wrap(
                  //   alignment: WrapAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(50.0),
                  //       child: Center(
                  //         child: Column(
                  //           children: [
                  //             Padding(
                  //               padding: EdgeInsets.only(top: 20.0, bottom: 25.0),
                  //               child: SvgPicture.asset(
                  //                   'assets/img/connections_empty.svg'),
                  //             ),
                  //             Text(
                  //               EnglishLang.noConnectionsMessage,
                  //               textAlign: TextAlign.center,
                  //               style: GoogleFonts.lato(
                  //                 fontSize: 16.0,
                  //                 color: AppColors.greys60,
                  //                 fontWeight: FontWeight.w400,
                  //                 letterSpacing: 0.25,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // );
                  Stack(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: SvgPicture.asset(
                              'assets/img/connections.svg',
                              alignment: Alignment.center,
                              // width: MediaQuery.of(context).size.width,
                              // height: MediaQuery.of(context).size.height,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          EnglishLang.noRequests,
                          style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          EnglishLang.noRequestText,
                          style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else {
            return PageLoader(
              bottom: 150,
            );
          }
        },
      ),
    );
  }
}
