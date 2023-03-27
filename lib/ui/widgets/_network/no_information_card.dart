import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/_constants/color_constants.dart';

class NoInformationCard extends StatelessWidget {
  final specialFieldText;
  const NoInformationCard({Key key, this.specialFieldText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.grey08),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      // alignment: Alignment.topLeft,
      // padding: EdgeInsets.only(bottom: 5),
      child: Text(
        "No $specialFieldText information available",
        style: GoogleFonts.lato(
          color: AppColors.greys60,
          fontSize: 14,
        ),
      ),
    );
  }
}
