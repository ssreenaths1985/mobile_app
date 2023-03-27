import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/bulletList.dart';

import '../../../../constants/_constants/color_constants.dart';

class ActivitiesInfo extends StatelessWidget {
  const ActivitiesInfo({Key key}) : super(key: key);

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
              "What is an activity?",
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
              "Activities are a set of actions taken to contribute towards the various roles one performs within a position",
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
              "Activities speak directly to the execution capacity of an individual public official by providing details on the mandate of their position, and how it is distinguished from other positions in the government.",
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
              'Role: Ensures inclusion and accuracy of facts in vigilance related proposals',
              'Activities:',
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: BulletList(
                [
                  'Checks the facts with regards to proposal keeping in mind existing rules, provisions, and legal precedents',
                  'Supplies missing facts to a proposal if any information is missing',
                  'Supports drafting of proposals',
                  'Quotes previous precedents by referring to existing rules'
                ],
                hasSubBullets: true,
              ),
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
