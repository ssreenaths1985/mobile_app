import 'package:flutter/material.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class CareersSearchPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;

  CareersSearchPage();
  @override
  _CareersSearchPageState createState() => _CareersSearchPageState();
}

class _CareersSearchPageState extends State<CareersSearchPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            ComingSoon()
            // Container(
            //   margin: const EdgeInsets.only(top: 10),
            //   alignment: Alignment.topLeft,
            //   child: SectionHeading('Careers search results'),
            // ),
          ],
        ),
      ),
    );
  }
}
