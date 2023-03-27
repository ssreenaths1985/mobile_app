import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/index.dart';
import './../../../constants/index.dart';

class CompetenciesAndTopicsCard extends StatelessWidget {
  final CourseTopics courseTopics;
  final String name;
  final int count;
  final Color cardColor;
  final bool isTopic;

  CompetenciesAndTopicsCard(
      {this.name = '',
      this.count = 0,
      this.cardColor,
      this.courseTopics,
      this.isTopic = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        height: 150,
        // width: (MediaQuery.of(context).size.width)/2 - 48,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(4.0)),
          color: cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 0),
              child: Text(
                isTopic ? courseTopics.name : name,
                maxLines: 2,
                // overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                    color: AppColors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                isTopic
                    ? courseTopics.noOfHoursConsumed.toString() +
                        ' hours in last week'
                    : count.toString() + ' hours in last week',
                style: GoogleFonts.lato(
                    color: AppColors.white70,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
