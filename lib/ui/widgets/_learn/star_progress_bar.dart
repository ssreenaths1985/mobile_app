import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class StarProgressBar extends StatelessWidget {
  final String text;
  final double progress;

  StarProgressBar({this.text, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: 50,
          child: Text(
            text,
            style: GoogleFonts.lato(
                color: AppColors.greys87,
                fontSize: 14.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: AppColors.grey16,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryOne,
                ),
                value: progress,
              )),
        )
      ]),
    );
  }
}
