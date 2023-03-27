import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../constants/index.dart';
import './../../../../respositories/index.dart';
import './../../../../ui/widgets/index.dart';
// import './../../../../localization/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class NetworkHomePage extends StatefulWidget {
  static const route = AppUrl.networkHomePage;
  final parentAction;

  const NetworkHomePage({Key key, this.parentAction}) : super(key: key);

  @override
  _NetworkHomePageState createState() => _NetworkHomePageState();
}

class _NetworkHomePageState extends State<NetworkHomePage> {
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
    _getPymk(context);
    if (_start == 0) {
      allEventsData = [];
      _generateTelemetryData();
    }
    // _startTimer();
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
      TelemetryPageIdentifier.networkHomePageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.networkHomePageUri,
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

  Future<dynamic> _getFromMyMDO(context) async {
    try {
      dynamic _networks = [];
      _networks = await Provider.of<NetworkRespository>(context, listen: false)
          .getAllUsersFromMDO();

      return _networks;
    } catch (err) {
      return err;
    }
  }

  /// Get PYMK response
  Future<void> _getPymk(context) async {
    try {
      return Provider.of<NetworkRespository>(context, listen: false)
          .getPymkList();
    } catch (err) {
      return err;
    }
  }

  /// Get From My MDO response
  // Future<void> _getFromMyMDO(context) async {
  //   try {
  //     return Provider.of<NetworkRespository>(context, listen: false)
  //         .getAllUsersFromMDO();
  //   } catch (err) {
  //     return err;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          FutureBuilder(
            future: _getConnectionRequest(context),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 15.0),
                      child: Text(
                        EnglishLang.connectionRequests,
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Wrap(
                      children: [
                        ConnectionRequests(
                          snapshot.data,
                          false,
                          isFromHome: true,
                          parentAction: widget.parentAction,
                        )
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
          FutureBuilder(
            future: _getFromMyMDO(context),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                return Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(15.0, 16.0, 15.0, 16.0),
                      child: Row(
                        children: [
                          Text(
                            EnglishLang.peopleYouMayKnow,
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          // InkWell(
                          //     onTap: () => widget.parentAction(3),
                          //     child: Text(
                          //       EnglishLang.seeAll,
                          //       style: GoogleFonts.lato(
                          //         color: AppColors.primaryThree,
                          //         fontWeight: FontWeight.w700,
                          //         fontSize: 16,
                          //         letterSpacing: 0.12,
                          //       ),
                          //     ))
                        ],
                      ),
                    ),
                    Wrap(
                      children: [FromMyMDO(snapshot.data)],
                    ),
                  ],
                );
              } else {
                return Center();
              }
            },
          ),
          Container(
            height: 100,
          )
          // FutureBuilder(
          //   future: _getPymk(context),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return (snapshot.data != null && snapshot.data.length > 0)
          //           ? Wrap(
          //               alignment: WrapAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding:
          //                       EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 15.0),
          //                   child: Text(
          //                     EnglishLang.peopleYouMayKnow,
          //                     style: GoogleFonts.lato(
          //                       color: AppColors.greys87,
          //                       fontSize: 16.0,
          //                       fontWeight: FontWeight.w700,
          //                     ),
          //                   ),
          //                 ),
          //                 Wrap(
          //                   children: [
          //                     PeopleYouMayKnow(
          //                       peopleYouMayKnow: snapshot.data,
          //                     ),
          //                     Container(
          //                       padding: const EdgeInsets.only(bottom: 65),
          //                       child: Center(),
          //                     )
          //                   ],
          //                 ),
          //               ],
          //             )
          //           : Center();
          //     } else {
          //       return Center();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
