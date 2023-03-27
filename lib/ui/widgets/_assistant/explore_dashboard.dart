import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class ExploreDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.only(top: 15),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppUrl.dashboardPage);
        },
        style: TextButton.styleFrom(
          // primary: Colors.white,
          backgroundColor: AppColors.customBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: AppColors.grey16)),
          // onSurface: Colors.grey,
        ),
        child: Row(children: <Widget>[
          Text(
            'Explore Dashboard',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Spacer(),
          Icon(
            Icons.chevron_right,
            color: Colors.white,
          )
        ]),
      ),
    );
  }
}
