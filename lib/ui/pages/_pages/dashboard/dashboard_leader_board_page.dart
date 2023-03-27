import 'package:flutter/material.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class DashboardLeaderBoardPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;

  DashboardLeaderBoardPage();
  @override
  _DashboardLeaderBoardPageState createState() =>
      _DashboardLeaderBoardPageState();
}

class _DashboardLeaderBoardPageState extends State<DashboardLeaderBoardPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: ComingSoon(),
      ),
    );
  }
}
