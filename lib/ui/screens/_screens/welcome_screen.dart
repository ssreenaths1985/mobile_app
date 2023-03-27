import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/screens/_screens/interests_screen.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';

import '../../../constants/_constants/color_constants.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import '../../../models/_models/telemetry_event_model.dart';
import '../../../util/faderoute.dart';
import '../../../util/telemetry.dart';
import '../../../util/telemetry_db_helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _generateTelemetryData();
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData1 = Telemetry.getImpressionTelemetryEvent(
      deviceIdentifier,
      userId,
      departmentId,
      TelemetryPageIdentifier.welcomePageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.welcomePageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: InkWell(
                child: Icon(Icons.close),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CustomTabs(
                      customIndex: 0,
                    ),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Image.asset(
                          'assets/img/igot_icon.png',
                          width: 110,
                          fit: BoxFit.fitWidth,
                          // height: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pinned: true,
            )
          ];
        },
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Padding(
              //   padding: EdgeInsets.all(16),
              //   child: SvgPicture.asset(
              //     'assets/img/KarmayogiBharat_Logo_Horizontal.svg',
              //     // fit: BoxFit.cover,
              //     width: 164,
              //     height: 49,
              //     // alignment: Alignment.topLeft,
              //   ),
              // ),
              SizedBox(
                height: 40,
              ),
              SvgPicture.asset(
                'assets/img/welcome_page.svg',
                // fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.30,
                // alignment: Alignment.topLeft,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'Welcome to iGOT',
                        style: GoogleFonts.montserrat(
                            color: AppColors.greys87,
                            height: 1.5,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '''Let us take you through a quick guided onboarding to understand your interests at work. Knowing you better helps us give you a more personalized experience on the platform. This way you discover relevant and useful learning content in the easiest way possible. And don’t worry, you can always update your interests later!''',
                        style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            height: 1.5,
                            letterSpacing: 0.25,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
      bottomSheet: BottomAppBar(
        elevation: 0,
        notchMargin: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            // height: _activeTabIndex == 0 ? 60 : 0,
            width: double.infinity,
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primaryThree,
                      minimumSize: const Size.fromHeight(36), // NEW
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        FadeRoute(
                            page: InterestsScreen(
                          fromWelcome: true,
                        )),
                      );
                    },
                    child: Text(
                      'Let’s go',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.429,
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
