import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../index.dart';
import './../../../constants.dart';
import './../../../../ui/widgets/index.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() {
    return _FeedbackPageState();
  }
}

class _FeedbackPageState extends State<FeedbackPage>
    with SingleTickerProviderStateMixin {
  int _activeTabIndex = 0;
  TabController _controller;
  List tabNames = ['Rating', 'Feedback'];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    _controller.addListener(_setActiveTabIndex);
  }

  void activateTab(index) {
    _controller.animateTo(index);
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _controller.index;
    });
    if (_activeTabIndex == 0) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: BackButton(color: FeedbackColors.black60),
        // leading: IconButton(
        //   icon: Icon(Icons.settings, color: AppColors.greys60),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: Row(children: [
          // Icon(Icons.settings, color: AppColors.greys60),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Give feedback',
                style: GoogleFonts.montserrat(
                  color: FeedbackColors.black87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ))
        ]),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        height: _activeTabIndex == 1 ? 75 : 0,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // color: FeedbackColors.primaryBlue,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(4),
          //     side: BorderSide(color: FeedbackColors.black16)),
          style: TextButton.styleFrom(
            // primary: Colors.white,
            backgroundColor: FeedbackColors.primaryBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: FeedbackColors.black16)),
            // onSurface: Colors.grey,
          ),
          child: Center(
            child: Text(
              'Submit feedback',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
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
                            color: FeedbackColors.primaryBlue,
                            width: 2.0,
                          ),
                        ),
                      ),
                      indicatorColor: Colors.white,
                      labelPadding: EdgeInsets.only(top: 0.0),
                      unselectedLabelColor: FeedbackColors.black60,
                      labelColor: FeedbackColors.primaryBlue,
                      labelStyle: GoogleFonts.lato(
                        fontSize: 14.0,
                        // color: FeedbackColors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: GoogleFonts.lato(
                        fontSize: 14.0,
                        color: FeedbackColors.black60,
                        fontWeight: FontWeight.w700,
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
                                  color: FeedbackColors.black87,
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
              color: FeedbackColors.background,
              child: TabBarView(
                controller: _controller,
                children: [
                  FeedbackRating(parentAction: activateTab),
                  FeedbackForm(),
                ],
              ),
            ),
          ))),
    );
  }
}
