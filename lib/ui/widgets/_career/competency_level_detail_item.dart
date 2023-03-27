import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';

class CompetencyLevelDetailItem extends StatelessWidget {
  const CompetencyLevelDetailItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey04,
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result Orientation',
                    style: GoogleFonts.lato(
                        height: 1.5,
                        decoration: TextDecoration.none,
                        color: AppColors.greys87,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Domain',
                    // textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                        height: 1.5,
                        decoration: TextDecoration.none,
                        color: AppColors.greys87,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Text(
                          "Position",
                          style: GoogleFonts.lato(
                              height: 1.5,
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < 3; i++)
                            (Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Container(
                                height: 6,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryThree,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1.0),
                                  ),
                                ),
                              ),
                            )),
                          for (var i = 0; i < 5 - 3; i++)
                            (Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Container(
                                height: 6,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.grey04,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1.0),
                                  ),
                                ),
                              ),
                            ))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        child: Text(
                          "Your level",
                          style: GoogleFonts.lato(
                              height: 1.5,
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < 3; i++)
                            (Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Container(
                                height: 6,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.positiveLight,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1.0),
                                  ),
                                ),
                              ),
                            )),
                          for (var i = 0; i < 5 - 3; i++)
                            (Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Container(
                                height: 6,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.grey04,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1.0),
                                  ),
                                ),
                              ),
                            ))
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}
