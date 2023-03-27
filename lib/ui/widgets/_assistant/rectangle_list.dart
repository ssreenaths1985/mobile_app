import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RectangleList extends StatefulWidget {
  final int id;
  final String title;
  final Object icon;
  final Object iconColor;
  final int points;
  final String svgIcon;

  RectangleList(this.id, this.title, this.icon, this.iconColor, this.points,
      this.svgIcon);

  @override
  _RectangleListState createState() => _RectangleListState();
}

class _RectangleListState extends State<RectangleList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 139,
      height: 85,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
      // height: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Row(children: [
              Text(widget.points.toString(),
                  style: GoogleFonts.lato(
                    color: Color.fromRGBO(0, 0, 0, 0.87),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 9),
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                  child: SvgPicture.asset(widget.svgIcon,
                      width: 25.0,
                      height: 25.0,
                      color: Color.fromRGBO(0, 0, 0, 0.87))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                child: Text(widget.title,
                    style: GoogleFonts.lato(
                      color: Color.fromRGBO(0, 0, 0, 0.87),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    )),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
