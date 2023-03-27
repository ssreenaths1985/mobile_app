import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
// import 'package:karmayogi_mobile/util/faderoute.dart';

class CourseRatingSubmitted extends StatefulWidget {
  final String title;
  CourseRatingSubmitted(this.title);
  @override
  _CourseRatingSubmittedState createState() => _CourseRatingSubmittedState();
}

class _CourseRatingSubmittedState extends State<CourseRatingSubmitted> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    // super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.clear, color: AppColors.greys60),
          onPressed: () {
            // Navigator.of(context).pop()
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
          },
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            color: AppColors.greys87,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        // centerTitle: true,
      ),
      // Tab controller

      body: SingleChildScrollView(
          child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        color: AppColors.lightBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SvgPicture.asset(
                  'assets/img/rating.svg',
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                'Thank you for the feedback!!!',
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                'You can update your rating at anytime.',
                style: GoogleFonts.lato(
                  color: AppColors.greys60,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      )),
      bottomSheet: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: AppColors.grey08,
              blurRadius: 6.0,
              spreadRadius: 0,
              offset: Offset(
                0,
                -3,
              ),
            ),
          ]),
          child: ScaffoldMessenger(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    // primary: Colors.white,
                    backgroundColor: AppColors.primaryThree,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: AppColors.grey16)),
                    // onSurface: Colors.grey,
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
