import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/_landingPage/hub_info_card.dart';

import '../../../constants/_constants/color_constants.dart';

class IntroThreeBody extends StatelessWidget {
  const IntroThreeBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Solutioning space for all of Government",
          style: GoogleFonts.montserrat(
              color: AppColors.primaryBlue,
              height: 1.5,
              fontSize: 20.0,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 32,
        ),
        Column(
          children: [
            HubInfoCard(
              title: 'Learning hub',
              description: 'Learn anywhere, anytime.',
              icon: 'assets/img/Learn.svg',
            ),
            Divider(
              height: 35,
              thickness: 1,
              color: AppColors.grey08,
            ),
            HubInfoCard(
              title: 'Discussion hub',
              description: 'Discuss and learn with peers.',
              icon: 'assets/img/Discuss.svg',
            ),
            Divider(
              height: 35,
              thickness: 1,
              color: AppColors.grey08,
            ),
            HubInfoCard(
              title: 'Network hub',
              description: 'Connect with civil servants across the country.',
              icon: 'assets/img/Network.svg',
            ),
            Divider(
              height: 35,
              thickness: 1,
              color: AppColors.grey08,
            ),
            HubInfoCard(
              title: 'Competency hub',
              description: 'Identify your competency requirements.',
              icon: 'assets/img/competencies.svg',
            ),
            Divider(
              height: 35,
              thickness: 1,
              color: AppColors.grey08,
            ),
            HubInfoCard(
              title: 'Career hub',
              description: 'Explore career opportunities across the country.',
              icon: 'assets/img/Careers.svg',
            ),
            Divider(
              height: 35,
              thickness: 1,
              color: AppColors.grey08,
            ),
            HubInfoCard(
              title: 'Events hub',
              description: 'Join online and in-person events.',
              icon: 'assets/img/events.svg',
            ),
          ],
        )
      ],
    );
  }
}
