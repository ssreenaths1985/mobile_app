import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';

class PresetsTimeFilter extends StatefulWidget {
  @override
  _PresetsTimeFilterState createState() => _PresetsTimeFilterState();
}

class _PresetsTimeFilterState extends State<PresetsTimeFilter> {
  bool selectionStatus = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(children: <Widget>[
          ListTile(
            title: Text(
              'Today',
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            title: Text(
              'This week',
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
            onTap: () => {
              setState(() {
                selectionStatus = true;
              })
            },
            selected: selectionStatus,
            selectedTileColor: Color.fromRGBO(0, 116, 182, 0.2),
          ),
          ListTile(
            title: Text(
              'This month',
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            title: Text(
              'This year',
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ]),
      ),
    );
  }
}
