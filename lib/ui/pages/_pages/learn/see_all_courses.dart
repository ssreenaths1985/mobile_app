import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import '../../../../constants/_constants/color_constants.dart';
import './../../../../ui/widgets/index.dart';
import './../../../widgets/index.dart';

// ignore: must_be_immutable
class SeeAllCoursesPage extends StatefulWidget {
  final courses;
  final bool isRecommended;
  final bool isInterested;
  SeeAllCoursesPage(this.courses,
      {this.isInterested = false, this.isRecommended = false});

  @override
  _SeeAllCoursesPageState createState() => _SeeAllCoursesPageState();
}

class _SeeAllCoursesPageState extends State<SeeAllCoursesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          widget.isRecommended
              ? EnglishLang.allRecommendedCBPs
              : EnglishLang.basedOnYourInterests,
          style: GoogleFonts.montserrat(
            color: AppColors.greys87,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            child: ListView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              itemCount: widget.courses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BrowseCourseCard(
                    course: widget.courses[index],
                  ),
                );
              },
            ),
          )
        ],
      )),
    );
  }
}
