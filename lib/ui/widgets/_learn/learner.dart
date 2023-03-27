import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';

class Learner extends StatelessWidget {
  final String name;
  final String designation;

  Learner({this.name, this.designation});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: AppColors.lightBackground, width: 2.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.positiveLight,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(4.0)),
                    ),
                    child: Center(
                      child: Text(Helper.getInitialsNew(name),
                          style: GoogleFonts.lato(color: Colors.white)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              designation != null ? designation : '',
                              style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
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
