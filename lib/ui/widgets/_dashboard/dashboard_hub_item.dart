import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class DashboardHubItem extends StatefulWidget {
  final int id;
  final String title;
  final Object icon;
  final Object iconColor;

  DashboardHubItem(this.id, this.title, this.icon, this.iconColor);

  @override
  _DashboardHubItemState createState() => _DashboardHubItemState();
}

class _DashboardHubItemState extends State<DashboardHubItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.fromLTRB(3.0, 20.0, 3.0, 3.0),
      // alignment: Alignment.center,
      width: 150,
      child: Column(children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 25, bottom: 5),
          child: Text(
            5.toString(),
            style: GoogleFonts.lato(
              color: Colors.black87,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: widget.iconColor),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.title,
                  style: GoogleFonts.lato(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ))
          ],
        )
      ]),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.grey08),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey08,
              blurRadius: 6.0,
              spreadRadius: 0,
              offset: Offset(
                0, // Move to right 10  horizontally
                3, // Move to bottom 10 Vertically
              ),
            ),
          ]),
    ));
  }
}
