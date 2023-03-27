import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
// import 'package:karmayogi_mobile/services/_services/competencies_service.dart';

class CompetencyLevelCard extends StatefulWidget {
  // const CompetencyLevelCard({ Key? key }) : super(key: key);
  final int index;
  final ValueChanged<Map> selectLevel;
  final ValueChanged<bool> checkSelectStatus;
  final int selectedLevel;
  final levelDetails;
  CompetencyLevelCard(
      {this.index,
      this.selectLevel,
      this.selectedLevel,
      this.levelDetails,
      this.checkSelectStatus});

  @override
  _CompetencyLevelCardState createState() => _CompetencyLevelCardState();
}

class _CompetencyLevelCardState extends State<CompetencyLevelCard> {
  // int _selected;

  @override
  Widget build(BuildContext context) {
    // print('Radio: ' + widget.selectedLevel.toString());
    return Container(
      width: 75,
      color: Colors.white,
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: 0),
                          value: widget.index,
                          groupValue: widget.selectedLevel,
                          onChanged: (value) {
                            setState(() {
                              widget.checkSelectStatus(true);
                              widget.selectLevel({
                                'levelValue': value,
                                'id': widget.levelDetails['id'],
                                'level': widget.levelDetails['level'],
                                'name': widget.levelDetails['name']
                              });
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Text(
                            widget.levelDetails['level'],
                            // "Name of the competency",
                            style: GoogleFonts.lato(
                              color: AppColors.greys60,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.levelDetails['name'],
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    thickness: 1,
                    width: 20,
                    color: AppColors.grey16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          widget.levelDetails[
                              'description'], // "Design and set up interface and interconnections from or among sensors, through a network, to a main location, to enable transmission of information",
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     // Navigator.push(
                      //     //   context,
                      //     //   FadeRoute(
                      //     //       page: CoursesInCompetency(
                      //     //           browseCompetencyCardModel)),
                      //     // );
                      //   },
                      //   child: Text(
                      //     "Read more",
                      //     style: GoogleFonts.lato(
                      //       color: AppColors.primaryThree,
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
