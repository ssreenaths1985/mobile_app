import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/_constants/color_constants.dart';

class IntroOneBody extends StatelessWidget {
  const IntroOneBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              'assets/img/image_bg_blue.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.425,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.065,
              left: MediaQuery.of(context).size.width * 0.065,
              // top: MediaQuery.of(context).size.height * 0.1,
              // left: MediaQuery.of(context).size.width * 0.075,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  children: [
                    Text(
                      'Karmayogi Bharat'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.anton(
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          height: 1.125,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      color: AppColors.orangeBackground,
                      // height: 52,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "National Program for Civil Services Capacity Building",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            // letterSpacing: -2.5
                          ),
                        ),
                      ),
                    ),
                    // Stack(
                    //   alignment: AlignmentDirectional.center,
                    //   children: [
                    //     Container(
                    //       color: AppColors.orangeBackground,
                    //       height: 52,
                    //     ),
                    //     Positioned(
                    //         child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Text(
                    //         "National Program for Civil Services Capacity Building",
                    //         textAlign: TextAlign.center,
                    //         style: GoogleFonts.montserrat(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w700,
                    //           // letterSpacing: -2.5
                    //         ),
                    //       ),
                    //     ))
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              // bottom: MediaQuery.of(context).size.height * 0.0125,
              // right: MediaQuery.of(context).size.width * 0.008,
              child: Image.asset(
                'assets/img/image_bg_pm.png',
                fit: BoxFit.fitHeight,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            )
          ],
        ),
        // Image.asset(
        //   'assets/img/Intro.png',
        //   height: MediaQuery.of(context).size.height * 0.42,
        // ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Text(
                  '''National Programme for Civil Services Capacity Building, aptly named as Mission Karmayogi, aims to create a professional, well-trained and future-looking civil service.''',
                  textAlign: TextAlign.center,
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
    );
  }
}
