import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/competency/competency_details.dart';
import 'package:karmayogi_mobile/ui/pages/index.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import './../../../constants/_constants/color_constants.dart';

class BrowseCompetencyCard extends StatelessWidget {
  final BrowseCompetencyCardModel browseCompetencyCardModel;
  final isCompetencyDetails;

  BrowseCompetencyCard(
      {this.browseCompetencyCardModel, this.isCompetencyDetails});

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              browseCompetencyCardModel.name,
                              // "Name of the competency",
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
                              browseCompetencyCardModel.competencyType != null
                                  ? browseCompetencyCardModel.competencyType
                                  : '',
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      browseCompetencyCardModel.count != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 4),
                                    child: SvgPicture.asset(
                                      'assets/img/school.svg',
                                      color: AppColors.greys60,
                                      width: 16,
                                      height: 16,
                                      alignment: Alignment.center,
                                      // width: MediaQuery.of(context).size.width,
                                      // height: MediaQuery.of(context).size.height,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      browseCompetencyCardModel.count
                                              .toString() +
                                          ' CBP\'s',
                                      style: GoogleFonts.lato(
                                          color: AppColors.greys60,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                          height: 1.2),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Center()
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
                          browseCompetencyCardModel.description != null
                              ? browseCompetencyCardModel.description
                              : '',
                          // "Design and set up interface and interconnections from or among sensors, through a network, to a main location, to enable transmission of information",
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                                page: isCompetencyDetails == true
                                    ? CompetencyDetailsPage(
                                        browseCompetencyCardModel)
                                    : CoursesInCompetency(
                                        browseCompetencyCardModel)),
                          );
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
