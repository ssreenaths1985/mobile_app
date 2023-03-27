import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/_models/course_model.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/learn/course_details_page.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:karmayogi_mobile/util/helper.dart';
// import '../../../localization/_langs/english_lang.dart';
import './../../../constants/_constants/color_constants.dart';

class MyLearningCard extends StatelessWidget {
  final Course course;
  final bool isMandatory;

  MyLearningCard(this.course, {this.isMandatory = false});

  @override
  Widget build(BuildContext context) {
    var imageExtension;
    if (course.raw['content']['appIcon'] != null) {
      imageExtension = course.raw['content']['appIcon']
          .substring(course.raw['content']['appIcon'].length - 3);
    }
    return InkWell(
        onTap: () => Navigator.push(
              context,
              FadeRoute(
                  page: CourseDetailsPage(
                id: course.raw['content']['identifier'],
                isContinueLearning: false,
              )),
            ),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      course.raw['content']['appIcon'] != null
                                          ? imageExtension != 'svg'
                                              ? NetworkImage(
                                                  Helper.convertToPortalUrl(
                                                      course.raw['content']
                                                          ['appIcon']))
                                              : AssetImage(
                                                  'assets/img/image_placeholder.jpg',
                                                )
                                          : AssetImage(
                                              'assets/img/image_placeholder.jpg',
                                            ),
                                  fit: BoxFit.scaleDown),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(4.0)),
                              // shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.grey08,
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                  offset: Offset(
                                    3,
                                    3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  course.raw['courseName'],
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  course.raw['content']['license'] != null
                                      ? course.raw['content']['license']
                                      : '',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: course.raw['content']
                                                      ['creatorLogo'] !=
                                                  null
                                              ? NetworkImage(
                                                  Helper.convertToPortalUrl(
                                                      course.raw['content']
                                                          ['creatorLogo']))
                                              : AssetImage(
                                                  'assets/img/igot_icon.png'),
                                          fit: BoxFit.scaleDown),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(4.0)),
                                      // shape: BoxShape.circle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Container(
                                      height: 24,
                                      // width: 85,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: AppColors.grey08),
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(4.0)),
                                        // shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // assets/img/course_icon.svg
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: SvgPicture.asset(
                                                'assets/img/course_icon.svg',
                                                width: 16.0,
                                                height: 16.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6, right: 8),
                                              child: Text(
                                                course.contentType
                                                    .toUpperCase(),
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isMandatory == true
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16, bottom: 8),
                                          child: Text(
                                              'Deadline: ' +
                                                  ((course.raw['batch'] !=
                                                              null &&
                                                          course.raw['batch']
                                                                  ['endDate'] !=
                                                              null)
                                                      ? DateFormat.yMMMd()
                                                          .format(DateTime
                                                              .parse(course.raw[
                                                                      'batch']
                                                                  ['endDate']))
                                                          .toString()
                                                      : ''),
                                              style: GoogleFonts.lato(
                                                  color: AppColors.greys87,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  height: 1.429,
                                                  letterSpacing: 0.25)),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       top: 8, bottom: 4),
                                        //   child: Chip(
                                        //       label: Text(
                                        //         '20 Days',
                                        //         style: GoogleFonts.lato(
                                        //             color: Colors.white),
                                        //       ),
                                        //       backgroundColor:
                                        //           AppColors.primaryThree),
                                        // )
                                      ],
                                    ),
                                  )
                                : Center(),
                            course.duration != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        // Text(
                                        //   '4.5',
                                        //   style: GoogleFonts.lato(
                                        //     color: AppColors.primaryOne,
                                        //     fontWeight: FontWeight.w700,
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 4),
                                        //   child: Icon(
                                        //     Icons.star_sharp,
                                        //     size: 16,
                                        //     color: AppColors.primaryOne,
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       left: 4, bottom: 5),
                                        //   child: Text(
                                        //     '.',
                                        //     style: GoogleFonts.lato(
                                        //       color: AppColors.greys60,
                                        //       fontWeight: FontWeight.w700,
                                        //       fontSize: 14,
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: course.duration != null
                                              ? Text(
                                                  Helper.getTimeFormat(
                                                      course.duration),
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.0,
                                                  ),
                                                )
                                              : Text(''),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 19, bottom: 0),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  backgroundColor: AppColors.grey16,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryThree,
                  ),
                  value: course.raw['completionPercentage'] / 100,
                ),
              ),
            ],
          ),
        ));
  }
}
