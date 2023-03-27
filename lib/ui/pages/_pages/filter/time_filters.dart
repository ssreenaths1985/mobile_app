import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';
import './../../../../ui/pages/index.dart';
import './../../../../ui/widgets/index.dart';

class TimeFilters extends StatefulWidget {
  @override
  _TimeFiltersState createState() {
    return new _TimeFiltersState();
  }
}

class _TimeFiltersState extends State<TimeFilters> {
  TabController _controller;
  List tabNames = ['Presets', 'Custom'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: Container(
          //   child: IconButton(
          //       icon: Icon(
          //         Icons.close,
          //         color: AppColors.greys87,
          //       ),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       }),
          // ),
          elevation: 0,
          // titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(children: [
            Container(
              child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.greys87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  'Time',
                  style: GoogleFonts.montserrat(
                    color: AppColors.greys87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ))
          ]),
        ),
        // Tab controller
        body: DefaultTabController(
            length: tabNames.length,
            child: SafeArea(
                child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
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
                          for (var tabItem in tabNames)
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              // padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Tab(
                                child: Text(
                                  tabItem,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
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
                child: TabBarView(
                  controller: _controller,
                  children: [
                    // Ratings(),
                    // FeedbackSubpage(),
                    PresetsTimeFilter(),
                    CustomTimeFilter(),
                  ],
                ),
              ),
            ))),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Reset to default',
                style: GoogleFonts.lato(
                  color: AppColors.primaryThree,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 180,
                color: AppColors.primaryThree,
                child: TextButton(
                  onPressed: null,
                  style: TextButton.styleFrom(
                    // primary: Colors.white,
                    backgroundColor: AppColors.primaryThree,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // onSurface: Colors.grey,
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
