import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/color_constants.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../localization/_langs/english_lang.dart';
import './../../../../respositories/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class MyConnections extends StatefulWidget {
  @override
  _MyConnectionsState createState() => _MyConnectionsState();
}

class _MyConnectionsState extends State<MyConnections> {
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
    _getEstablishedConnections(context);
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
      TelemetryPageIdentifier.myConnectionsPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.myConnectionsPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  @override
  void dispose() async {
    super.dispose();
  }

  /// Get established connections
  Future<void> _getEstablishedConnections(context) async {
    try {
      return Provider.of<NetworkRespository>(context, listen: false)
          .getEstablishedConnectionList();
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
        future: _getEstablishedConnections(context),
        builder: (context, snapshot) {
          if ((snapshot.hasData && snapshot.data != null) &&
              snapshot.data.data.length != 0) {
            // print('Data: ' + snapshot.data.toString());
            return Wrap(
              alignment: WrapAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 10.0),
                //   child: Text(
                //     snapshot.data.data.length.toString() +
                //         ' ' +
                //         EnglishLang.connections,
                //     style: GoogleFonts.lato(
                //       color: AppColors.greys60,
                //       fontSize: 14.0,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
                Wrap(
                  children: [MyConnectionCard(snapshot.data)],
                ),
              ],
            );
          } else if ((snapshot.hasData && snapshot.data != null) &&
              (snapshot.data.data != null && snapshot.data.data.length == 0)) {
            return Stack(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
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
                        EnglishLang.noEstablishedConnections,
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
                        EnglishLang.noEstablishedConnectionText,
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
