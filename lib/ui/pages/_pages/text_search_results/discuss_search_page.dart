import 'package:flutter/material.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class DiscussSearchPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;

  DiscussSearchPage();
  @override
  _DiscussSearchPageState createState() => _DiscussSearchPageState();
}

class _DiscussSearchPageState extends State<DiscussSearchPage> {
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
            //   child: SectionHeading('Discuss search results'),
            // ),
          ],
        ),
      ),
    );
  }
}
