import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class OtherItem extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final Object icon;
  final Object iconColor;
  final String url;

  OtherItem(this.id, this.title, this.description, this.icon, this.iconColor,
      this.url);

  @override
  _OtherItemState createState() => _OtherItemState();
}

class _OtherItemState extends State<OtherItem> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  widget.icon,
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              Container(
                  width: 278,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      )
                    ],
                  )),
            ],
          )),
    );
  }
}
