import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './../../../constants/index.dart';

class GlanceItem1 extends StatelessWidget {
  final String icon;
  final String text;
  final bool isModule;
  final bool showContent = true;

  GlanceItem1({this.icon, this.text, this.isModule = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 20, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: AppColors.greys87,
              // alignment: Alignment.topLeft,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                text,
                style: GoogleFonts.lato(
                    // height: 1.5,
                    decoration: TextDecoration.none,
                    color: AppColors.greys87,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            )),
          ],
        ));
  }
}
