// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/screens/index.dart';
// import './../../../../ui/pages/index.dart';
import './../../../../util/faderoute.dart';
import './../../../../constants/index.dart';
import './../../../widgets/index.dart';
import './../../../../services/index.dart';

class BrowseLearnPage extends StatefulWidget {
  @override
  _BrowseLearnPageState createState() => _BrowseLearnPageState();
}

class _BrowseLearnPageState extends State<BrowseLearnPage> {
  TelemetryService telemetryService = TelemetryService();
  ScrollController _scrollController;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  List allEventsData = [];
  String deviceIdentifier;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // padding: const EdgeInsets.only(bottom: 120),
        height: MediaQuery.of(context).size.height - 62,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(), // new
          controller: _scrollController,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Explore all CBP\'s within the \'Learn hub\'',
                style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.12,
                    height: 1.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              // child: AspectRatio(
              //   aspectRatio: 2/1,
              child: Container(
                // height: 200,
                child: SvgPicture.asset(
                  'assets/img/explore_w.svg',
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            // ),
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
              // padding: const EdgeInsets.fromLTRB(0, 20, 0 , 10),
              child: Column(
                children: BROWSEBY
                    .map(
                      (browseBy) => InkWell(
                          onTap: () => browseBy.comingSoon
                              ? Navigator.push(
                                  context,
                                  FadeRoute(page: ComingSoonScreen()),
                                )
                              : Navigator.pushNamed(context, browseBy.url),
                          child: BrowseByCard(
                              browseBy.id,
                              browseBy.title,
                              browseBy.description,
                              browseBy.comingSoon,
                              browseBy.svgImage,
                              browseBy.url)),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
    //   } else {
    //     return PageLoader(
    //       bottom: 150,
    //     );
    //   }
    // }));
  }
}
