import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/signup.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';

import '../../../constants/_constants/color_constants.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import '../../../localization/_langs/english_lang.dart';
import '../../../models/_models/course_model.dart';
import '../../../models/_models/telemetry_event_model.dart';
import '../../../oAuth2_login.dart';
import '../../../services/_services/landing_page_service.dart';
import '../../pages/_pages/learn/course_details_page.dart';

class FeaturedCoursesPage extends StatefulWidget {
  const FeaturedCoursesPage({Key key}) : super(key: key);

  @override
  State<FeaturedCoursesPage> createState() => _FeaturedCoursesPageState();
}

class _FeaturedCoursesPageState extends State<FeaturedCoursesPage> {
  final landingPageService = LandingPageService();
  List<Course> _featuredCourses;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  List allEventsData = [];
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    // _getInfo();
  }

  _getFeaturedCourse() async {
    _featuredCourses = await landingPageService.getFeaturedCourses();
    return _featuredCourses;
  }

  void _generateInteractTelemetryData(String contentId) async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId(isPublic: true);
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId(isPublic: true);
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.learnPageId,
        userSessionId,
        messageIdentifier,
        contentId,
        TelemetrySubType.courseCard);
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap(),
        isPublic: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: _getFeaturedCourse(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              // print(snapshot.data);
              return (snapshot.hasData && snapshot.data != null)
                  ? Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(0),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: Icon(Icons.arrow_back)),
                                Text('Featured courses',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.primaryBlue,
                                        fontSize: 20.0,
                                        letterSpacing: 0.75,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height *
                                    (MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? 0.8
                                        : 0.9),
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 15,
                                ),
                                child: ListView.builder(
                                  scrollDirection:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.portrait
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                  itemCount: _featuredCourses.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          _generateInteractTelemetryData(
                                              _featuredCourses[index].id);
                                          Navigator.push(
                                            context,
                                            FadeRoute(
                                                page: CourseDetailsPage(
                                              id: _featuredCourses[index].id,
                                              isFeaturedCourse: true,
                                            )),
                                          );
                                        },
                                        child: Container(
                                          // margin: EdgeInsets.only(bottom: 24),
                                          child: CourseItem(
                                            course: _featuredCourses[index],
                                            isVertical: MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.portrait
                                                ? true
                                                : false,
                                            isFeatured: true,
                                          ),
                                        ));
                                  },
                                ))
                          ],
                        ),
                      ),
                    )
                  : PageLoader(
                      bottom: 150,
                    );
            }),
        bottomSheet: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? (MediaQuery.of(context).size.height * 0.07)
                : (MediaQuery.of(context).size.shortestSide * 0.1),
            color: AppColors.primaryBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.43,
                    padding: EdgeInsets.only(left: 16),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          EnglishLang.register,
                          // 'Register',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.375,
                              letterSpacing: 0.125),
                        ))),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Opacity(
                    opacity: 0.75,
                    child: VerticalDivider(
                      color: Colors.white,
                      width: 10,
                    ),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    padding: EdgeInsets.only(right: 16),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => OAuth2Login(),
                            ),
                          );
                        },
                        child: Text(
                          EnglishLang.signIn,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.375,
                              letterSpacing: 0.125),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
