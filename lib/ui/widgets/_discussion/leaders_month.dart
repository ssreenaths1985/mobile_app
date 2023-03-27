import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class LeaderMonth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          // Heading
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Leaders of this month',
                  style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Leaders list
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: SizedBox(
                  height: 170.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, index) => Container(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(05),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.grey04,
                                  blurRadius: 8.0,
                                  spreadRadius: 0.0)
                            ]),
                        child: SizedBox(
                          width: 187.0,
                          height: 158.0,
                          child: Card(
                            elevation: 0,
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: AppColors.positiveLight,
                                    child: Center(
                                      child: Text(
                                        'RD',
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      'Ranjit Damodaran',
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          color: AppColors.positiveDark,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            '187 karma points',
                                            style: GoogleFonts.lato(
                                              color: AppColors.positiveLight,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
