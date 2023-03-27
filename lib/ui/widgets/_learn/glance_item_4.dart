import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './../../../constants/index.dart';

class GlanceItem4 extends StatelessWidget {
  final String icon;
  final String text;
  final int status;
  final bool isModule;
  final bool showContent = true;
  final String duration;
  final bool background;
  final bool isFeaturedCourse;
  final currentProgress;

  GlanceItem4(
      {this.icon,
      this.text,
      this.isModule = false,
      this.status,
      this.duration,
      this.background = true,
      this.isFeaturedCourse = false,
      this.currentProgress});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 20, 8),
        child: Container(
          color: background ? Color.fromRGBO(39, 117, 184, 0.1) : Colors.white,
          // height: 75,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              !isFeaturedCourse
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5, top: 15),
                      child: (status == 2)
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
                                    value: (currentProgress != null &&
                                            currentProgress != '')
                                        ? double.parse(
                                            currentProgress.toString())
                                        : 0.0),
                              ),
                            ),
                    )
                  : Center(),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 85,
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        text,
                        style: GoogleFonts.lato(
                            // height: 1.5,
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
                            icon,
                            color: AppColors.greys87,
                            height: 16,
                            width: 16,
                            // alignment: Alignment.topLeft,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              duration,
                              style: GoogleFonts.lato(
                                  height: 1.5,
                                  decoration: TextDecoration.none,
                                  color: AppColors.greys60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
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
