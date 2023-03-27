import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/app_routes.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/events/events.dart';

import '../../widgets/_common/bottom_bar.dart';

class EventsHub extends StatelessWidget {
  const EventsHub({Key key}) : super(key: key);
  static const route = AppUrl.eventsHub;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        duration: Duration(milliseconds: 0),
        child: SafeArea(
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: EdgeInsets.fromLTRB(60.0, 0.0, 10.0, 15.0),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(
                          //   Icons.supervisor_account,
                          //   color: AppColors.primaryThree,
                          // ),
                          SvgPicture.asset(
                            'assets/img/events.svg',
                            width: 24.0,
                            height: 24.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 13.0, top: 3.0),
                            child: Text(
                              EnglishLang.events,
                              style: GoogleFonts.montserrat(
                                color: AppColors.greys87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              // TabBar view
              body: EventsPage()),
        ),
      ),
      bottomSheet: BottomBar(),
    );
  }
}
