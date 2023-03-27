import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class CompetencyLevelBar extends StatelessWidget {
  final String text;
  final bool isWorkOrder;
  final bool isEvaluation;
  final bool isGap;

  CompetencyLevelBar(
      {this.text,
      this.isWorkOrder = false,
      this.isEvaluation = false,
      this.isGap = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8, left: 16, right: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 20, 12),
            child: Row(
              children: [
                isWorkOrder == true
                    ? Container(
                        height: 8,
                        width: 20,
                        decoration: BoxDecoration(
                          color: AppColors.primaryThree,
                          borderRadius: BorderRadius.all(
                            Radius.circular(3.0),
                          ),
                        ),
                      )
                    : isEvaluation
                        ? Container(
                            height: 8,
                            width: 20,
                            decoration: BoxDecoration(
                              color: AppColors.positiveLight,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3.0),
                              ),
                            ),
                          )
                        : isGap == true
                            ? Container(
                                height: 8,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3.0),
                                    ),
                                    border: Border.all(
                                        color: Colors.redAccent, width: 1.5)),
                              )
                            : Container(
                                height: 8,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.grey08,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3.0),
                                  ),
                                ),
                              ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(left: 12, bottom: 5),
                  child: Text(
                    text,
                    style: GoogleFonts.lato(
                        height: 1.5,
                        decoration: TextDecoration.none,
                        color: AppColors.greys87,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                )),
              ],
            )),
      ),
    );
  }
}
