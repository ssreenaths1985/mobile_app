import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/_constants/color_constants.dart';

class HubInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  const HubInfoCard({Key key, this.title, this.description, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: SvgPicture.asset(
                '$icon',
              ),
            ),
            Text('$title',
                style: GoogleFonts.montserrat(
                    color: AppColors.secondaryBlack,
                    // height: 2,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('$description',
              style: GoogleFonts.montserrat(
                  color: AppColors.tertiaryBlack,
                  height: 1.3125,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500)),
        )
      ],
    );
  }
}
