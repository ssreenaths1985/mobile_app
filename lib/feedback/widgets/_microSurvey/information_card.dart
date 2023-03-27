import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';

class InformationCard extends StatelessWidget {
  final int scenarioNumber;
  final IconData icon;
  final String information;
  final Color iconColor;

  InformationCard(
      this.scenarioNumber, this.icon, this.information, this.iconColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
      child: Container(
        height: 48,
        color: AppColors.grey04,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 11),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  information,
                  style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
