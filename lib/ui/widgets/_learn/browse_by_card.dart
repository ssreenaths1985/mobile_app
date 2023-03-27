import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../localization/index.dart';

class BrowseByCard extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final bool comingSoon;
  final String svgImage;
  final String url;

  BrowseByCard(this.id, this.title, this.description, this.comingSoon,
      this.svgImage, this.url);

  @override
  _BrowseByCardState createState() => _BrowseByCardState();
}

class _BrowseByCardState extends State<BrowseByCard> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildItems() {
    List<Widget> rowElements = [];
    rowElements.add(Text(
      widget.title,
      style: GoogleFonts.lato(
        color: AppColors.primaryThree,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.5,
      ),
    ));
    if (widget.comingSoon) {
      rowElements.add(Padding(
        padding: const EdgeInsets.only(left: 120),
        child: Container(
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
        ),
      ));
    }
    return rowElements;
  }

  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        height: 84,
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: ClipPath(
            child: Stack(fit: StackFit.passthrough, children: <Widget>[
              SvgPicture.asset(
                widget.svgImage,
                alignment: Alignment.center,
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 0,
                left: 16,
                child: Container(
                    // height: 84,
                    // width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _buildItems(),
                        ),
                        Text(
                          widget.description,
                          style: GoogleFonts.lato(
                              color: AppColors.greys60,
                              height: 1.5,
                              fontSize: 12),
                        ),
                      ],
                    )),
              ),
            ]),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
          ),
        ),
      ),
    );
  }
}
