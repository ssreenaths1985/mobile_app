import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/_constants/color_constants.dart';

class LevelInfo extends StatelessWidget {
  final levelDetails;
  const LevelInfo({Key key, this.levelDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // insetPadding: EdgeInsets.symmetric(horizontal: 0),
      contentPadding: EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < levelDetails.length; i++)
              (Container(
                // height: 48,
                margin: const EdgeInsets.fromLTRB(1, 1, 1, 8),
                // padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: AppColors.grey16,
                )),
                child: ExpansionTile(
                  expandedAlignment: Alignment.topLeft,
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  childrenPadding:
                      EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  // collapsedTextColor: AppColors.primaryThree,
                  onExpansionChanged: (value) async {
                    // setState(() {
                    //   _isExpanded = value;
                    // });
                  },
                  tilePadding: EdgeInsets.only(left: 16, right: 16),
                  title: Text(
                    levelDetails[i]['level'],
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        letterSpacing: 0.25,
                        height: 1.5,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700),
                  ),
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        levelDetails[i]['name'],
                        style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.25,
                            height: 1.5),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      levelDetails[i]['description'],
                      style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                          height: 1.5),
                    ),
                  ],
                ),
              ))
          ],
        ),
      ),
    );
  }
}
