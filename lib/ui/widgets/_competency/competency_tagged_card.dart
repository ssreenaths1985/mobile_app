import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';

class TaggedCompetency extends StatefulWidget {
  final yourTaggedCompetency;
  final courseCompetencies;
  const TaggedCompetency({this.yourTaggedCompetency, this.courseCompetencies});

  @override
  _TaggedCompetencyState createState() => _TaggedCompetencyState();
}

class _TaggedCompetencyState extends State<TaggedCompetency> {
  // int _courseCompetencyLevel;

  @override
  void initState() {
    super.initState();
    // findCourseCompetencyLevel(widget.yourTaggedCompetency.id);
  }

  // void findCourseCompetencyLevel(String id) {
  //   if (widget.courseCompetencies != null) {
  //     for (var i = 0; i < widget.courseCompetencies.length; i++) {
  //       if (widget.courseCompetencies[i].id == id) {
  //         setState(() {
  //           _courseCompetencyLevel = int.parse(widget
  //               .courseCompetencies[i].courseCompetencyLevel
  //               .replaceAll('Level ', ''));
  //         });
  //       }
  //     }
  //   }
  // }

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
                              widget.yourTaggedCompetency.name,
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
                                widget.yourTaggedCompetency.competencyType,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        Row(
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
                                  widget.yourTaggedCompetency
                                              .courseCompetencyLevel !=
                                          null
                                      ? (Row(
                                          children: [
                                            for (var i = 0;
                                                i <
                                                    int.parse(widget
                                                        .yourTaggedCompetency
                                                        .courseCompetencyLevel
                                                        .replaceAll(
                                                            'Level ', ''));
                                                i++)
                                              (Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3),
                                                child: Container(
                                                  height: 6,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryThree,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(1.0),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                            for (var i = 0;
                                                i <
                                                    5 -
                                                        int.parse(widget
                                                            .yourTaggedCompetency
                                                            .courseCompetencyLevel
                                                            .replaceAll(
                                                                'Level ', ''));
                                                i++)
                                              (Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3),
                                                child: Container(
                                                  height: 6,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.grey08,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(1.0),
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
                                                padding: const EdgeInsets.only(
                                                    left: 3),
                                                child: Container(
                                                  height: 6,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.grey08,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(1.0),
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
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Your level: ',
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),

                            //Not coming the value for Certified from the backend

                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                            //   child: Text(
                            //     'Certified',
                            //     style: GoogleFonts.lato(
                            //         color: AppColors.greys87,
                            //         fontSize: 14.0,
                            //         fontWeight: FontWeight.w400),
                            //   ),
                            // ),
                            widget.yourTaggedCompetency.selfAttestedLevel !=
                                    null
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                                    child: Row(
                                      children: [
                                        for (var i = 0;
                                            i <
                                                widget.yourTaggedCompetency
                                                    .selfAttestedLevel;
                                            i++)
                                          (Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Container(
                                              height: 6,
                                              width: 12,
                                              decoration: BoxDecoration(
                                                color: AppColors.positiveLight,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(1.0),
                                                ),
                                              ),
                                            ),
                                          )),
                                        for (var i = 0;
                                            i <
                                                5 -
                                                    widget.yourTaggedCompetency
                                                        .selfAttestedLevel;
                                            i++)
                                          (Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Container(
                                              height: 6,
                                              width: 12,
                                              decoration: BoxDecoration(
                                                color: AppColors.grey08,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(1.0),
                                                ),
                                              ),
                                            ),
                                          ))
                                      ],
                                    ),
                                  )
                                : Center(),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        )
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
