import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/app_routes.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
// import 'package:karmayogi_mobile/ui/pages/_pages/careers/browse_by_location.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/careers/browse_by_mdo.dart';
// import 'package:karmayogi_mobile/ui/pages/_pages/careers/careers_browse_by_competency.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/career_browse_by_tab.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';

class CareerBrowseBy extends StatefulWidget {
  final tabIndex;
  const CareerBrowseBy({Key key, this.tabIndex = 0}) : super(key: key);
  static const route = AppUrl.careersHub;

  @override
  _CareerBrowseByState createState() => _CareerBrowseByState();
}

class _CareerBrowseByState extends State<CareerBrowseBy>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  // int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: CareerBrowseByTab.items.length, vsync: this, initialIndex: 0);

    // _controller.addListener(() {
    //   setState(() {
    //     _tabIndex = _controller.index;
    //   });
    // });
    _controller.index = widget.tabIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                          'assets/img/Careers.svg',
                          width: 24.0,
                          height: 24.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 13.0, top: 3.0),
                          child: Text(
                            EnglishLang.careers,
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
                SliverPersistentHeader(
                  delegate: SilverAppBarDelegate(
                    TabBar(
                        isScrollable: true,
                        indicator: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primaryThree,
                              width: 2.0,
                            ),
                          ),
                        ),
                        indicatorColor: Colors.white,
                        labelPadding: EdgeInsets.only(top: 0.0),
                        unselectedLabelColor: AppColors.greys60,
                        labelColor: AppColors.primaryThree,
                        labelStyle: GoogleFonts.lato(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.lato(
                          fontSize: 10.0,
                          fontWeight: FontWeight.normal,
                        ),
                        tabs: [
                          for (var tabItem in CareerBrowseByTab.items)
                            Container(
                              // width: 125.0,
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Tab(
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    tabItem.title,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                        controller: _controller,
                        onTap: (value) => null
                        // _triggerInteractTelemetryData(_controller.index),
                        ),
                  ),
                  pinned: true,
                  floating: false,
                ),
              ];
            },

            // TabBar view
            body: Container(
              color: AppColors.lightBackground,
              child: FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 500)),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return TabBarView(
                      controller: _controller,
                      children: [
                        BrowseByMDO(),
                        // BrowseByLocation(),
                        ComingSoon(),
                        // CareerBrowseByCompetency(),
                        ComingSoon()
                        // Text('4'),
                      ],
                    );
                  }),
            ),
            // ChangeNotifierProvider<CareerRepository>(
            //   create: (context) => CareerRepository(),
            //   child: CareersPage(),
            // ),
          ),
        ),
      ),
      bottomSheet: BottomBar(),
    );
  }
}
