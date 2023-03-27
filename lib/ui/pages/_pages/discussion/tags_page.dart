import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../respositories/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

class TagsPage extends StatefulWidget {
  final int tabIndex;
  TagsPage({Key key, this.tabIndex}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
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
      TelemetryPageIdentifier.tagsPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.tagsPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _generateInteractTelemetryData(String contentId) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.tagsPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.tagCard);
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  /// Get trending tags
  Future<void> _trendingTags(context) async {
    List _tagsList = [];
    try {
      _tagsList = await Provider.of<DiscussRepository>(context, listen: false)
          .getTrendingTags();
    } catch (err) {
      return err;
    }

    return _tagsList;
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: _trendingTags(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TagsList(snapshot.data, _generateInteractTelemetryData);
            } else {
              return PageLoader(
                bottom: 175,
              );
            }
          },
        ),
      ),
    );
  }
}
