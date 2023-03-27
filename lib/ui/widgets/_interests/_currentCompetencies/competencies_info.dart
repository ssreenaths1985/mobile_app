import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/bulletList.dart';

import '../../../../constants/_constants/color_constants.dart';

class CompetenciesInfo extends StatelessWidget {
  const CompetenciesInfo({Key key}) : super(key: key);

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
              "What are competencies?",
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
              '''Competencies are a combination of attitudes, skills, and knowledge that enable an individual to perform a task or activity successfully in a given job and roles are the starting point for arriving at them.     
There are three types of competencies: Behavioral, Functional and Domain''',
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
              "Competencies help with:",
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.25,
                  height: 1.5),
            ),
            BulletList([
              'Providing information on individual requirements from a role',
              'Identifying learning and development needs for government officials',
              'Streamlining the recruitment process'
            ]),
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
              '''Competency Label: Noting and Drafting
Competency Type: Functional
Description: Drafts and analyses a note, in order, in order to move a proposal for
decision making on the availability of evidence and existing rules and precedents.''',
              '''Competency Label: Communication Skills
Competency Type: Behavioral
Description: Articulates information to others in a language that is clear, concise, and easy to understand. It also includes the ability to listen and understand the unspoken feelings and concerns of others.''',
              '''Competency Label: Regulatory and Legal Advisory
Competency Type: Domain
Description: Provides advice to business and management stakeholders on regulatory compliance and legal matters related to support business decision making'''
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
