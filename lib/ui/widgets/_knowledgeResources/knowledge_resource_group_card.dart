import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class KnowledgeGroupCard extends StatefulWidget {
  final String name;
  final String description;
  final String source;
  final bool showBookmarkIcon;
  final Object icon;
  final String documentId;
  final List files;
  final List links;

  const KnowledgeGroupCard(
      this.name,
      this.description,
      this.source,
      this.showBookmarkIcon,
      this.icon,
      this.documentId,
      this.files,
      this.links);

  @override
  _KnowledgeGroupCardState createState() => new _KnowledgeGroupCardState();
}

class _KnowledgeGroupCardState extends State<KnowledgeGroupCard> {
  Widget _link() {
    return Row(children: [
      Icon(
        Icons.link,
        color: AppColors.primaryThree,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          widget.links.length.toString() + ' URL',
          style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontSize: 14.0,
              fontWeight: FontWeight.w400),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          margin: EdgeInsets.only(top: 5.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 20.0, 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.source,
                      style: GoogleFonts.lato(
                          color: AppColors.greys60,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                    (widget.showBookmarkIcon)
                        ? IconButton(
                            icon: Icon(
                              Icons.bookmark,
                              color: AppColors.primaryThree,
                            ),
                            onPressed: () {},
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.bookmark,
                              color: AppColors.grey16,
                            ),
                            onPressed: () {},
                          )
                  ],
                ),
                Container(
                  child: Text(
                    widget.name,
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                widget.description != ''
                    ? Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.description,
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : Center(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Icon(
                      //   widget.icon,
                      //   color: AppColors.greys60,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          widget.documentId,
                          style: GoogleFonts.lato(
                              color: AppColors.greys60,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                          widget.files.length.toString(),
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      widget.files.length > 0 ? _link() : Center()
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
