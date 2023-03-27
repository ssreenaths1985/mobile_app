import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';

class OtherTaggedCompetency extends StatelessWidget {
  final otherTaggedCompetencies;
  final bool needTaggedStatus;
  const OtherTaggedCompetency(this.otherTaggedCompetencies,
      {this.needTaggedStatus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: EdgeInsets.all(16),
      // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.zero)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              otherTaggedCompetencies.name,
                              style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Competency type: ',
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 16, 0, 0),
                              child: Text(
                                otherTaggedCompetencies.competencyType,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        needTaggedStatus
                            ? Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      'Tagged to course: ',
                                      style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                                    child: Text(
                                      'Tagged',
                                      style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                                    child: Row(
                                      children: [
                                        (otherTaggedCompetencies
                                                        .courseCompetencyLevel !=
                                                    null &&
                                                otherTaggedCompetencies
                                                        .courseCompetencyLevel !=
                                                    '')
                                            ? (Row(
                                                children: [
                                                  for (var i = 0;
                                                      i <
                                                          int.parse(
                                                              otherTaggedCompetencies
                                                                  .courseCompetencyLevel
                                                                  .replaceAll(
                                                                      'Level ',
                                                                      ''));
                                                      i++)
                                                    (Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3),
                                                      child: Container(
                                                        height: 6,
                                                        width: 12,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .primaryThree,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                1.0),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                  for (var i = 0;
                                                      i <
                                                          5 -
                                                              int.parse(otherTaggedCompetencies
                                                                  .courseCompetencyLevel
                                                                  .replaceAll(
                                                                      'Level ',
                                                                      ''));
                                                      i++)
                                                    (Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3),
                                                      child: Container(
                                                        height: 6,
                                                        width: 12,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.grey08,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                1.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                ],
                                              ))
                                            : Row(
                                                children: [
                                                  for (var i = 0; i < 5; i++)
                                                    (Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3),
                                                      child: Container(
                                                        height: 6,
                                                        width: 12,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.grey08,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                1.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Center(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
