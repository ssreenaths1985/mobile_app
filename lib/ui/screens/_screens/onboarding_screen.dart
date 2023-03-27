import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_introduction/featured_courses.dart';
import 'package:karmayogi_mobile/ui/widgets/_introduction/intro_one_body.dart';
import 'package:karmayogi_mobile/ui/widgets/_introduction/intro_three_body.dart';
import 'package:karmayogi_mobile/ui/widgets/_introduction/intro_two_body.dart';

import '../../../oAuth2_login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  StreamSubscription _connectivitySubscription;
  bool _isDeviceConnected = false;
  bool _isSetAlert = false;

  @override
  void initState() {
    super.initState();
    _getConnectivity();
  }

  _getConnectivity() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      _isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!_isDeviceConnected && !_isSetAlert) {
        _showDialogBox();
        setState(() {
          _isSetAlert = true;
        });
      }
    });
  }

  _showDialogBox() => {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/img/No_network.svg',
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(EnglishLang.noConnection)
                    ],
                  ),
                  content: Text(
                    EnglishLang.noConnectionDescription,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context, EnglishLang.cancel);
                          setState(() {
                            _isSetAlert = false;
                          });
                          _isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!_isDeviceConnected) {
                            _showDialogBox();
                            setState(() {
                              _isSetAlert = true;
                            });
                          }
                        },
                        child: Text(EnglishLang.retry))
                  ],
                ))
      };

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
    // _getUserSessionId();
  }

  @override
  Widget build(BuildContext context) {
    PageDecoration getPageDecoration(
            {bool contentMargin = true, titlePadding = true}) =>
        PageDecoration(
          pageColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 20),
          contentMargin: contentMargin ? EdgeInsets.all(16) : EdgeInsets.all(0),
          titlePadding: titlePadding
              ? EdgeInsets.only(top: 16.0, bottom: 24.0)
              : EdgeInsets.all(0),
          // titlePadding: EdgeInsets.only(bottom: 16)
        );
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: Colors.white,
          showNextButton: false,
          pages: [
            PageViewModel(
                titleWidget: SvgPicture.asset(
                  'assets/img/KarmayogiBharat_Logo_Horizontal.svg',
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                bodyWidget: IntroOneBody(),
                decoration: getPageDecoration(contentMargin: false)),
            PageViewModel(
                // titleWidget: SvgPicture.asset(
                //   'assets/img/KarmayogiBharat_Logo_Horizontal.svg',
                //   width: MediaQuery.of(context).size.width * 0.4,
                // ),
                titleWidget: Center(),
                bodyWidget: IntroTwoBody(),
                decoration: getPageDecoration(titlePadding: false)),
            PageViewModel(
                // titleWidget: SvgPicture.asset(
                //   'assets/img/KarmayogiBharat_Logo_Horizontal.svg',
                //   width: MediaQuery.of(context).size.width * 0.4,
                // ),
                titleWidget: Center(),
                bodyWidget: IntroThreeBody(),
                decoration: getPageDecoration(titlePadding: false)),
          ],
          // next: Text("Next",
          //     style: TextStyle(
          //         fontWeight: FontWeight.w700,
          //         color: AppColors.greys87,
          //         fontSize: 14)),
          showBackButton: false,
          // back: Text("Back",
          //     style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          showSkipButton: false,
          // skip: Text(EnglishLang.signIn,
          //     style: TextStyle(
          //         fontWeight: FontWeight.w700,
          //         color: AppColors.greys87,
          //         fontSize: 14)),
          // onSkip: () => Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => OAuth2Login(),
          //   ),
          // ),
          // done: Text(
          //   EnglishLang.register,
          //   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          // ),
          showDoneButton: false,
          // onDone: () => Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => SignUpPage(),
          //   ),
          // ),
          dotsDecorator: DotsDecorator(
              color: AppColors.grey16,
              activeColor: AppColors.primaryBlue,
              activeSize: Size(28, 8),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
          globalFooter: SafeArea(
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
                                builder: (context) => FeaturedCoursesPage(),
                              ),
                            );
                          },
                          child: Text(
                            EnglishLang.featuredCourses,
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
      ),
    );
  }
}
