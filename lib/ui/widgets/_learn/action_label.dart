import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import './../../../constants/index.dart';

class ActionLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  ActionLabel({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        border: Border.all(color: AppColors.primaryThree),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryThree,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                  decoration: TextDecoration.none,
                  color: AppColors.primaryThree,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
