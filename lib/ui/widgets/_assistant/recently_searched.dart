import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentlySearched extends StatelessWidget {
  final recentlySearchedValue;

  RecentlySearched(this.recentlySearchedValue);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 34,
        // width: 81,
        margin: const EdgeInsets.only(left: 20),
        child: FittedBox(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Text(recentlySearchedValue,
                style: GoogleFonts.lato(
                  color: Colors.black87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          borderRadius: BorderRadius.all(Radius.circular(21)),
          border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.16)),
        ));
  }
}
