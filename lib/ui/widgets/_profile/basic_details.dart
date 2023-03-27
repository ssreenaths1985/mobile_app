import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../util/helper.dart';
import './../../../constants/index.dart';
import './../../../models/index.dart';
// import 'dart:developer' as developer;

class BasicDetails extends StatelessWidget {
  final Profile profileDetails;

  BasicDetails(this.profileDetails);

  @override
  Widget build(BuildContext context) {
    // developer.log(profileDetails.photo);
    // print('Designation: ' +
    //     profileDetails.professionalDetails[0]['name'].toString());
    // print('Photo: ' + profileDetails.rawDetails.photo.toString());
    return Column(
      children: <Widget>[
        Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            color: AppColors.ghostWhite,
            child: Center(
              child: profileDetails.photo != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.memory(
                          Helper.getByteImage(profileDetails.photo)))
                  : Container(
                      height: 100,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.positiveLight,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(4.0)),
                      ),
                      child: Center(
                        child: Text(
                          Helper.getInitialsNew(profileDetails.firstName +
                              ' ' +
                              profileDetails.surname),
                          style: GoogleFonts.lato(
                              color: AppColors.avatarText,
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0),
                        ),
                      ),
                    ),
            )),
        Container(
          // margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: AppColors.grey08),
            // borderRadius: BorderRadius.all(
            //   Radius.circular(4),
            // ),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  Helper.capitalize(profileDetails.firstName) +
                      ' ' +
                      Helper.capitalize(profileDetails.surname),
                  style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    letterSpacing: 0.12,
                  ),
                ),
              ),
              profileDetails.professionalDetails.length > 0
                  ? profileDetails.designation != null
                      ? Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            // profileDetails.firstName + ' ' + profileDetails.surname,
                            (profileDetails.designation) +
                                (profileDetails.professionalDetails[0]
                                            ['name'] !=
                                        null
                                    ? ' at ' +
                                        (profileDetails.professionalDetails[0]
                                            ['name'])
                                    : ''),
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                              letterSpacing: 0.12,
                            ),
                          ),
                        )
                      : Center()
                  : Center(),
              profileDetails.experience.length > 0
                  ? (profileDetails.experience[0]['location']) != null
                      ? Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            // profileDetails.firstName + ' ' + profileDetails.surname,
                            (profileDetails.experience[0]['location']),
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                              letterSpacing: 0.12,
                            ),
                          ),
                        )
                      : Center()
                  : Center(),
              // Container(
              //   alignment: Alignment.topLeft,
              //   child: Text(
              //     (profileDetails.designation != null
              //             ? profileDetails.designation
              //             : '') +
              //         (profileDetails.department != '' ? ' at ' : '') +
              //         profileDetails.department +
              //         '\n' +
              //         profileDetails.location,
              //     style: GoogleFonts.lato(
              //       color: AppColors.greys87,
              //       fontSize: 14,
              //       height: 1.5,
              //       fontWeight: FontWeight.w400,
              //       letterSpacing: 0.25,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
