import 'package:flutter/material.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class DashboardCategoriesPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;

  DashboardCategoriesPage();
  @override
  _DashboardCategoriesPageState createState() =>
      _DashboardCategoriesPageState();
}

class _DashboardCategoriesPageState extends State<DashboardCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: ComingSoon(),
      ),
    );
  }
}
