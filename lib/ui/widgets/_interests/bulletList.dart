import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/_constants/color_constants.dart';

class BulletList extends StatelessWidget {
  final List<String> strings;
  final bool hasSubBullets;

  BulletList(this.strings, {this.hasSubBullets = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasSubBullets ? '-' : '\u2022',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.25,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    str,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        letterSpacing: 0.25,
                        height: 1.5),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
