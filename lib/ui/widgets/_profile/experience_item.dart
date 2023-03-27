import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class ExperienceItem extends StatelessWidget {
  final experience, index;

  ExperienceItem(this.experience, this.index);

  @override
  Widget build(BuildContext context) {
    return (experience['designation'] != '' &&
            experience['designation'] != null)
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
                    experience['designation'].toString(),
                    style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                (experience['name'] != null && experience['name'] != '')
                    ? Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          experience['name'].toString(),
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Center(),
                experience['location'] != null
                    ? Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          experience['location'].toString(),
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Center(),
                experience['doj'] != null
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          experience['doj'].toString() + ' - Present',
                          style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Center(),
              ],
            ),
          )
        : Center();
  }
}
