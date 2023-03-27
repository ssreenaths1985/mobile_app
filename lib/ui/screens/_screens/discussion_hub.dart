import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../ui/pages/index.dart';
import '../../../constants/index.dart';
import '../../widgets/index.dart';
import './../../../localization/index.dart';

class DiscussionHub extends StatefulWidget {
  static const route = AppUrl.discussionHub;

  @override
  _DiscussionHubState createState() => _DiscussionHubState();
}

class _DiscussionHubState extends State<DiscussionHub>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  bool popularPosts = false;
  final service = HttpClient();
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
        length: DiscussionTab.items.length, vsync: this, initialIndex: 0);
    _controller.addListener(() {
      setState(() {
        _tabIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateDiscussPostsStatus() {
    setState(() {
      popularPosts = !popularPosts;
    });
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
          duration: Duration(milliseconds: 500),
          child: DefaultTabController(
            length: DiscussionTab.items.length,
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
                        titlePadding:
                            EdgeInsets.fromLTRB(60.0, 0.0, 10.0, 15.0),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon(
                            //   Icons.forum,
                            //   color: AppColors.primaryThree,
                            // ),
                            SvgPicture.asset(
                              'assets/img/Discuss.svg',
                              width: 24.0,
                              height: 24.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 13.0, top: 0.0),
                              child: Text(
                                EnglishLang.discuss,
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
                            for (var tabItem in DiscussionTab.items)
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
                            DiscussionCard(
                                tabIndex: _tabIndex,
                                popularPosts: popularPosts,
                                parentAction: _updateDiscussPostsStatus),
                            CategoryPage(
                              tabIndex: _tabIndex,
                            ),
                            TagsPage(
                              tabIndex: _tabIndex,
                            ),
                            MyDiscussionsPage(
                              tabIndex: _tabIndex,
                              isDiscussionPage: true,
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: OpenContainer(
              closedElevation: 10,
              openColor: AppColors.primaryThree,
              transitionDuration: Duration(milliseconds: 750),
              openBuilder: (context, _) => NewDiscussionPage(),
              closedShape: CircleBorder(),
              closedColor: AppColors.primaryThree,
              transitionType: ContainerTransitionType.fadeThrough,
              closedBuilder: (context, openContainer) => FloatingActionButton(
                    //   boxShadow: [
                    //   BoxShadow(
                    //     color: AppColors.grey08,
                    //     blurRadius: 3,
                    //     spreadRadius: 0,
                    //     offset: Offset(
                    //       3,
                    //       3,
                    //     ),
                    //   ),
                    // ],
                    elevation: 10,
                    heroTag: 'newDiscussion',
                    onPressed: openContainer,
                    child: Icon(Icons.add),
                    backgroundColor: AppColors.primaryThree,
                  )),
        ));
  }
}
