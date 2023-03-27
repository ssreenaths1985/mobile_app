import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/bulletList.dart';

import '../../../../constants/_constants/color_constants.dart';

class RolesInfo extends StatelessWidget {
  const RolesInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // insetPadding: EdgeInsets.symmetric(horizontal: 0),
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What is Role?",
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.12,
                  height: 1.5),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Roles describe the overall objective of a group of activities and how they contribute to the position.",
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.25,
                  height: 1.5),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "Why is it important?",
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.12,
                  height: 1.5),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Roles help understand the mandate of a position. There could be similar positions across the government, but differentiated by the roles they form. Roles help articulate these distinctions by highlighting why the position exists and how it works towards larger organisational goals and priorities.",
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.25,
                  height: 1.5),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "Example:",
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.12,
                  height: 1.5),
            ),
            SizedBox(
              height: 8,
            ),
            BulletList([
              'Ensures inclusion and accuracy of facts in vigilance proposals.',
              'Coordinates and manages relationships with various stakeholders',
              'Manages grievance redressal mechanisms'
            ]),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
