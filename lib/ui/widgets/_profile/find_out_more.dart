import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class FindOutMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      child: TextButton(
        onPressed: () {
          // print('Received click');
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
            'Find out more',
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
