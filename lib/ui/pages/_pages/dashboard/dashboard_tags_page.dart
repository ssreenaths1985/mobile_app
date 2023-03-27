import 'package:flutter/material.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class DashboardTagsPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;

  DashboardTagsPage();
  @override
  _DashboardTagsPageState createState() => _DashboardTagsPageState();
}

class _DashboardTagsPageState extends State<DashboardTagsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: ComingSoon(),
      ),
    );
  }
}
