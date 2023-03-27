import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';

class DashboardDiscussionsPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;

  DashboardDiscussionsPage();
  @override
  _DashboardDiscussionsPageState createState() =>
      _DashboardDiscussionsPageState();
}

class _DashboardDiscussionsPageState extends State<DashboardDiscussionsPage> {

   ScrollController _scrollController;
  final List<ProfileViewer> data1 = [
    ProfileViewer(year: 1, sales: 2),
    ProfileViewer(year: 2, sales: 9),
    ProfileViewer(year: 3, sales: 7),
    ProfileViewer(year: 4, sales: 1),
    // ProfileViewer(year: 5, sales: 5),
  ];

  final List<PlatformUsage> data2 = [
    PlatformUsage(views: 3, hours: 2),
    PlatformUsage(views: 6, hours: 1),
    PlatformUsage(views: 9, hours: 3),
    PlatformUsage(views: 12, hours: 4),
    // ProfileViewer(year: 5, sales: 5),
  ];

   @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _getCourseTopics();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: DASHBOARD_HUBS
                    .map(
                      (hub) => Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 10),
                          child: new Container(
                              width: 150.0,
                              child: DashboardHubItem(
                                hub.id,
                                hub.title,
                                hub.icon,
                                hub.iconColor,
                              ))),
                    )
                    .toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(5, 20, 5, 0),
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Visualization(
                heading: 'Your profile was viewed 24 times last week',
                subHeading: 'Number of unique visitors to your profile',
                legend: 'Profile views',
                displayTotalViews: true,
                chartType: ChartType.profileViews,
                data: data1,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(5, 20, 5, 20),
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Visualization(
                heading: 'Platform usage',
                subHeading: 'Usage over last 30 days',
                legend: 'Usage in hours',
                displayTotalViews: false,
                chartType: ChartType.platformUsage,
                data: data2,
              ),
            ),
            InkWell(
                        onTap: _scrollToTop,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Column(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(const Radius.circular(50)),
                                ),
                                child: Center(
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_upward,
                                        color: AppColors.greys60,
                                        size: 24,
                                      ),
                                      onPressed: _scrollToTop),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 68, top: 12),
                                child: Text(
                                  'Back to top',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    letterSpacing: 0.12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
