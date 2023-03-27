// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/services/index.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../constants/index.dart';
import './../../../../ui/pages/_pages/ai_assistant_page.dart';
import './../../../../ui/screens/index.dart';
// import './../../../../localization/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

//ignore: must_be_immutable
class TextSearchPage extends StatefulWidget {
  @override
  TextSearchPageState createState() => TextSearchPageState();
}

class TextSearchPageState extends State<TextSearchPage> {
  // var searchActionIcon = Icons.mic_rounded;
  var searchActionIcon =
      VegaConfiguration.isEnabled ? Icons.mic_rounded : Icons.arrow_forward;
  final textController = TextEditingController();
  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  List allEventsData = [];
  String deviceIdentifier;
  var telemetryEventData;

  final TelemetryService telemetryService = TelemetryService();

  @override
  void initState() {
    super.initState();
    if (VegaConfiguration.isEnabled) {
      textController.addListener(_manageSearchActionIcon);
    }
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
      TelemetryPageIdentifier.globalSearchPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.globalSearchPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    allEventsData.add(eventData1);
    // await telemetryService.triggerEvent(allEventsData);
  }

  void _manageSearchActionIcon() {
    var icon;
    if (textController.text != '') {
      icon = Icons.arrow_forward;
    } else {
      icon = Icons.mic_rounded;
    }

    setState(() {
      searchActionIcon = icon;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                pinned: false,
                // expandedHeight: 280,
                flexibleSpace: ListView(
                  shrinkWrap: true,
                  children: <Widget>[],
                )),
          ];
        },
        body: Column(
          children: [
            Container(
                // color: Colors.white,
                // height: double.infinity,
                ),
          ],
        ),
      )),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          child: Container(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: Icon(
                        Icons.search,
                        color: AppColors.greys60,
                      )),
                  SizedBox(
                      height: 38,
                      width: MediaQuery.of(context).size.width - 150,
                      child: TextField(
                        autofocus: true,
                        controller: textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: textController.text != ''
                              ? textController.text
                              : (VegaConfiguration.isEnabled
                                  ? EnglishLang.askVega
                                  : EnglishLang.search),
                        ),
                      )),
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryThree,
                        child: IconButton(
                          icon: Icon(searchActionIcon),
                          color: Colors.white,
                          onPressed: () {
                            if (searchActionIcon == Icons.mic_rounded) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AiAssistantPage(
                                            searchKeyword: '...',
                                            index: 2,
                                          )));
                            } else {
                              _navigateToSubPage(context);
                            }
                          },
                        ),
                        radius: 20,
                      )),
                ],
              )),
          color: Colors.white,
        ),
      ),
    );
  }

  void _navigateToSubPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TextSearchResultScreen(searchKeyword: textController.text)));
  }
}
