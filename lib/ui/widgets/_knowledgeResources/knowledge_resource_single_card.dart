import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class KnowledgeSingleCard extends StatefulWidget {
  final String sourceName;
  final String title;

  const KnowledgeSingleCard(this.sourceName, this.title);

  @override
  _KnowledgeSingleCardState createState() => new _KnowledgeSingleCardState();
}

class _KnowledgeSingleCardState extends State<KnowledgeSingleCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          margin: EdgeInsets.only(top: 5.0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.sourceName,
                        style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/img/pdf.svg',
                        width: 24.0,
                        height: 24.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 18),
                        child: Text(
                          'PDF',
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
