import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class BitesCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String iconImage;

  BitesCard({this.imageUrl, this.title, this.iconImage});
  @override
  _BitesCardState createState() => new _BitesCardState();
}

class _BitesCardState extends State<BitesCard> {
  @override
  void initState() {
    super.initState();
    // print(widget.data.tags.toString());
    // _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.white70,
          image: DecorationImage(
              image: AssetImage(widget.imageUrl), fit: BoxFit.cover),
          borderRadius: BorderRadius.all(const Radius.circular(8.0)),
        ),
      ),
      Positioned(
        // draw a red marble
        bottom: -1,
        // right: -1,
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0)),
            color: AppColors.greys60,
          ),
          // margin: const EdgeInsets.only(top: 50, bottom: 5),
          child: Row(
            children: [
              SvgPicture.asset(
                widget.iconImage,
                width: 25.0,
                height: 25.0,
                // color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.title,
                  style: GoogleFonts.lato(
                    color: AppColors.white70,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
