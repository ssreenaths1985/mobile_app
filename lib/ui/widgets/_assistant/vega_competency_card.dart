import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
// import 'package:karmayogi_mobile/models/index.dart';
// import 'package:karmayogi_mobile/ui/pages/index.dart';
// import 'package:karmayogi_mobile/util/faderoute.dart';
import './../../../constants/_constants/color_constants.dart';

class VegaCompetencyCard extends StatelessWidget {
  final competency;

  const VegaCompetencyCard({Key key, this.competency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("Name: ${browseCompetencyCardModel.name}");
    return Container(
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
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          // browseCompetencyCardModel.name,
                          competency['name'],
                          style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          // browseCompetencyCardModel.competencyType,
                          competency['additionalProperties']['competencyType'],
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
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
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          // browseCompetencyCardModel.description,
                          competency['description'],
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   FadeRoute(page: CoursesInCompetency(browseCompetencyCardModel)),
                          // );
                        },
                        child: Text(
                          "Read more",
                          style: GoogleFonts.lato(
                            color: AppColors.primaryThree,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
