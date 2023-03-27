import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/_models/landing_page_info_model.dart';
import 'package:karmayogi_mobile/services/_services/landing_page_service.dart';
import 'package:karmayogi_mobile/ui/widgets/_common/page_loader.dart';
import 'package:karmayogi_mobile/ui/widgets/_landingPage/dashboard_card.dart';

import '../../../constants/_constants/color_constants.dart';

class IntroTwoBody extends StatefulWidget {
  const IntroTwoBody({Key key}) : super(key: key);

  @override
  State<IntroTwoBody> createState() => _IntroTwoBodyState();
}

class _IntroTwoBodyState extends State<IntroTwoBody> {
  final landingPageService = LandingPageService();
  LandingPageInfo _landingPageInfo;
  @override
  void initState() {
    super.initState();
    // _getInfo();
  }

  _getInfo() async {
    _landingPageInfo = await landingPageService.getLandingPageInfo();
    return _landingPageInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Learn and network with civil servants and subject matter experts India",
                style: GoogleFonts.montserrat(
                    color: AppColors.primaryBlue,
                    height: 1.5,
                    fontSize: 20.0,
                    // letterSpacing: 0.75,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 32,
              ),
              snapshot.hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Number of users/MDO's",
                            style: GoogleFonts.montserrat(
                                color: AppColors.secondaryBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.3125),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DashboardCard(
                              count: '${_landingPageInfo.karmayogiOnboarded}',
                              text: 'Karmayogis onboarded',
                              chart: 'assets/img/learnGraph.png',
                              parentContext: context,
                            ),
                            DashboardCard(
                              count: '${_landingPageInfo.registeredMdo}',
                              text: "Registered MDO's",
                              chart: 'assets/img/learnGraph.png',
                              parentContext: context,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Available content',
                            style: GoogleFonts.montserrat(
                                color: AppColors.secondaryBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.3125),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DashboardCard(
                              count: '${_landingPageInfo.courses}',
                              text: 'Courses',
                              chart: 'assets/img/coursesGraph.png',
                              parentContext: context,
                            ),
                            DashboardCard(
                              count: '${_landingPageInfo.availableContent}',
                              text: 'Available content (hours)',
                              chart: 'assets/img/contentGraph.png',
                              parentContext: context,
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 24,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 8),
                        //   child: Text(
                        //     'Engagement',
                        //     style: GoogleFonts.montserrat(
                        //         color: AppColors.secondaryBlack,
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 14,
                        //         height: 1.3125),
                        //   ),
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     DashboardCard(
                        //       count: '${_landingPageInfo.courseEnrollments}',
                        //       text: 'Course enrollments',
                        //       chart: 'assets/img/learnGraph.png',
                        //     ),
                        //     // DashboardCard(
                        //     //   count: '500+',
                        //     //   text: 'Minutes spent',
                        //     //   chart: 'assets/img/line_chart.png',
                        //     // ),
                        //   ],
                        // )
                      ],
                    )
                  : PageLoader(
                      bottom: 300,
                    ),
            ],
          );
        });
  }
}
