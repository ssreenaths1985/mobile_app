import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class GlanceItem2 extends StatelessWidget {
  final String text1;
  final String text2;

  GlanceItem2({this.text1, this.text2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: GoogleFonts.montserrat(
                decoration: TextDecoration.none,
                color: AppColors.primaryThree,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text2,
              style: GoogleFonts.montserrat(
                  decoration: TextDecoration.none,
                  color: AppColors.greys87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
