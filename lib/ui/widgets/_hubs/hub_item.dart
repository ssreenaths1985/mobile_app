import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../localization/index.dart';

class HubItem extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final Object icon;
  final Object iconColor;
  final bool comingSoon;
  final String url;
  final String svgIcon;
  final bool svg;

  HubItem(this.id, this.title, this.description, this.icon, this.iconColor,
      this.comingSoon, this.url, this.svgIcon, this.svg);

  @override
  _HubItemState createState() => _HubItemState();
}

class _HubItemState extends State<HubItem> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildItems() {
    List<Widget> rowElements = [];
    rowElements.add(Text(
      widget.title,
      style: GoogleFonts.lato(
        color: AppColors.greys87,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.5,
      ),
    ));
    if (widget.comingSoon) {
      rowElements.add(Container(
        // margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text(
          EnglishLang.comingSoon,
          style: GoogleFonts.lato(color: AppColors.greys60, fontSize: 10),
        ),
      ));
    }
    return rowElements;
  }

  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      child: Card(
        child: ClipPath(
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
              child: Row(
                children: <Widget>[
                  (widget.svg)
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            border: Border.all(color: AppColors.lightGrey),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: SvgPicture.asset(
                            widget.svgIcon,
                            width: 25.0,
                            height: 25.0,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            border: Border.all(color: AppColors.lightGrey),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Icon(widget.icon, color: widget.iconColor),
                        ),
                  Expanded(
                      child: Container(
                          // width: 282,
                          padding: EdgeInsets.only(left: 15, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _buildItems(),
                              ),
                              Text(
                                widget.description,
                                maxLines: 5,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    height: 1.5,
                                    fontSize: 12),
                              ),
                            ],
                          ))),
                ],
              )),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
        ),
      ),
    );
  }
}
