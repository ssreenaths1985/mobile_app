import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';

class HomepageAssessmentCompleted extends StatefulWidget {
  HomepageAssessmentCompleted();
  @override
  _HomepageAssessmentCompletedState createState() =>
      _HomepageAssessmentCompletedState();
}

class _HomepageAssessmentCompletedState
    extends State<HomepageAssessmentCompleted> {
  @override
  Widget build(BuildContext context) {
    return Center(
        // padding: const EdgeInsets.only(top: 100),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/img/done.png',
          width: 50.0,
          height: 50.0,
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'You got 2/3 right',
            style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'More power to you!',
            style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width / 2 - 50,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              // primary: Colors.white,
              backgroundColor: AppColors.customBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: AppColors.grey16)),
              // onSurface: Colors.grey,
            ),
            child: Text(
              'Done',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
