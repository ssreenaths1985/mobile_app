import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './../../../constants/index.dart';

class GlanceItem3 extends StatefulWidget {
  final String icon;
  final String text;
  final int status;
  final bool isModule;
  final bool showContent = true;
  final String contentType;
  final String duration;
  final bool isFeaturedCourse;
  final currentProgress;

  const GlanceItem3(
      {Key key,
      this.icon,
      this.text,
      this.status,
      this.isModule,
      this.contentType,
      this.duration,
      this.isFeaturedCourse = false,
      this.currentProgress})
      : super(key: key);

  @override
  _GlanceItem3State createState() => _GlanceItem3State();
}

class _GlanceItem3State extends State<GlanceItem3> {
// class GlanceItem3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 20, 8),
        child: Container(
          color: Colors.white,
          // height: 74,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              !widget.isFeaturedCourse
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5, top: 10),
                      child: (widget.status == 2)
                          ? Icon(Icons.check_circle,
                              size: 22, color: AppColors.positiveLight)
                          : Padding(
                              padding: const EdgeInsets.only(top: 4, right: 0),
                              child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    backgroundColor: AppColors.grey16,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.positiveLight,
                                    ),
                                    strokeWidth: 3,
                                    value: (widget.currentProgress != null &&
                                            widget.currentProgress != '')
                                        ? double.parse(
                                            widget.currentProgress.toString())
                                        : 0.0),
                              ),
                            ),
                    )
                  : Center(),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      // height: 30,
                      child: Text(
                        widget.text,
                        // softWrap: false,
                        // maxLines: 2,
                        style: GoogleFonts.lato(
                            height: 1.5,
                            decoration: TextDecoration.none,
                            color: AppColors.greys87,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            widget.icon,
                            color: AppColors.greys87,
                            height: 16,
                            width: 16,
                            // alignment: Alignment.topLeft,
                          ),
                          widget.duration != null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    // contentType,
                                    widget.duration,
                                    style: GoogleFonts.lato(
                                        height: 1.5,
                                        decoration: TextDecoration.none,
                                        color: AppColors.greys60,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : Center(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
