import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../pages/index.dart';
import './../../widgets/index.dart';
import './../../../constants/index.dart';

class DashboardScreen extends StatefulWidget {
  static const route = AppUrl.dashboardPage;

  @override
  DashboardScreenState createState() {
    return new DashboardScreenState();
  }
}

class DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _activeTabIndex = 0;
  final String dropdownLabel1 = 'Time';
  final List<String> dropdownItems1 = ['This week', 'This month', 'This year'];
  final String selectedDropdownItem1 = 'This week';

  final String dropdownLabel2 = 'MDO';
  final List<String> dropdownItems2 = ['All', 'MDO 1', 'MDO 2'];
  final String selectedDropdownItem2 = 'All';

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: DashboardTab.items.length, vsync: this, initialIndex: 0);
    _controller.addListener(_setActiveTabIndex);
  }

  void _setActiveTabIndex() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _activeTabIndex = _controller.index;
      });
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
        // Tab controller
        body: DefaultTabController(
            length: DashboardTab.items.length,
            child: SafeArea(
                child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      pinned: false,
                      // expandedHeight: 280,
                      flexibleSpace: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 60),
                                child: Icon(
                                  Icons.bar_chart_outlined,
                                  color: AppColors.greys60,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 23),
                                child: Text(
                                  'Dashboard',
                                  style: GoogleFonts.montserrat(
                                    color: AppColors.greys87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Icon(Icons.settings)),
                            ],
                          ),
                        ],
                      )),
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
                          for (var tabItem in DashboardTab.items)
                            Container(
                              // width: 110,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
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
                          DashboardDiscussionsPage(),
                          DashboardLeaderBoardPage(),
                          DashboardCategoriesPage(),
                          DashboardTagsPage(),
                        ],
                      );
                    }),
              ),
            ))),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: _activeTabIndex == 0 ? 60 : 0,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryThree,
                  ),
                  height: 40,
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MDOFilters(),
                            ),
                          ),
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            height: 40,
                            child: FilterCard('MDO', 'All')),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimeFilters(),
                            ),
                          ),
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            height: 40,
                            child: FilterCard('Time', 'This month')),
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          height: 40,
                          child: FilterCard('MDO', 'All')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
