import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class FilterName extends StatelessWidget {
  final filterName;

  FilterName(this.filterName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        filterName,
        style: GoogleFonts.lato(
            color: AppColors.greys87,
            fontSize: 14.0,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
