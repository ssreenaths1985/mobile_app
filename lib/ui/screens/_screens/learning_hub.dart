import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import './../../../ui/pages/_pages/network/my_mdo.dart';
import './../../../ui/pages/index.dart';
import '../../../constants/index.dart';
import '../../widgets/index.dart';
import './../../../localization/_langs/english_lang.dart';

class LearningHub extends StatefulWidget {
  static const route = AppUrl.learningHub;

  @override
  _LearningHubState createState() => _LearningHubState();
}

class _LearningHubState extends State<LearningHub>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  final service = HttpClient();

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: LearnMainTab.items.length, vsync: this, initialIndex: 0);
  }

  void switchIntoYourLearningTab() {
    setState(() {
      _controller.index = 1;
    });
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
        child: DefaultTabController(
          length: LearnMainTab.items.length,
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: BackButton(color: AppColors.greys60),
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: EdgeInsets.fromLTRB(60.0, 10.0, 10.0, 0.0),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(
                          //   Icons.school_rounded,
                          //   color: AppColors.primaryThree,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SvgPicture.asset(
                              'assets/img/Learn.svg',
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0, top: 10.0),
                            child: Text(
                              EnglishLang.learn,
                              style: GoogleFonts.montserrat(
                                color: AppColors.greys87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(
                                Icons.search,
                                color: AppColors.greys60,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TextSearchPage()));
                              }),
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
                          for (var tabItem in LearnMainTab.items)
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
                          LearningHubPage(
                            parentAction: switchIntoYourLearningTab,
                          ),
                          YourLearningPage(),
                          BrowseLearnPage(),
                          // BitesPage(),
                          ComingSoon(
                            removeGoToWebButton: true,
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: BottomBar(),
    );
  }
}
