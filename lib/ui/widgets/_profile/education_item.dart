import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class EducationItem extends StatelessWidget {
  final education;

  EducationItem(this.education);

  @override
  Widget build(BuildContext context) {
    return education['nameOfQualification'] != '' ||
            education['nameOfQualification'] != null
        ? Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 3),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.grey08),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    education['nameOfQualification'] != ''
                        ? education['nameOfQualification']
                        : education['type'],
                    style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                education['nameOfInstitute'] != '' ||
                        education['yearOfPassing'] != ''
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              education['nameOfInstitute'],
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              education['yearOfPassing'],
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'No Information Available',
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ],
            ),
          )
        : Center();
  }
}
