import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class HomeHubItem extends StatefulWidget {
  final int id;
  final String title;
  final Object icon;
  final Object iconColor;
  final String url;
  final bool displayNotification;
  final String svgIcon;

  HomeHubItem(this.id, this.title, this.icon, this.iconColor, this.url,
      this.displayNotification, this.svgIcon);

  @override
  _HomeHubItemState createState() => _HomeHubItemState();
}

class _HomeHubItemState extends State<HomeHubItem> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildItems() {
    List<Widget> stackElements = [];
    stackElements.add(Container(
      // height: 70,
      // margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(top: 14),
      alignment: Alignment.center,
      child: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            SvgPicture.asset(
              widget.svgIcon,
              width: 24.0,
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.title,
                style: GoogleFonts.lato(
                  color: Colors.black87,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
              ),
            ),
          ],
        ),
      ]),
      decoration: BoxDecoration(
          color: Colors.white,
          // color: Colors.blueAccent,
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
    if (widget.displayNotification) {
      stackElements.add(Positioned(
        // draw a red marble
        top: -1,
        right: -1,
        child: new Icon(Icons.brightness_1,
            size: 12.0, color: AppColors.negativeLight),
      ));
    }
    return stackElements;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        // onTap: () => selectCategory(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
        child: Stack(children: _buildItems()));
  }
}
