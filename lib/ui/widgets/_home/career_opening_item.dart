import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_moment/simple_moment.dart';
import './../../../models/_models/career_opening_model.dart';
import '../../../constants/index.dart';
import './../../../util/helper.dart';
// import './../../../util/faderoute.dart';
// import './../../../ui/screens/index.dart';

class CareerOpeningItem extends StatelessWidget {
  final CareerOpening careerOpening;
  final dateNow = Moment.now();

  CareerOpeningItem(this.careerOpening);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        // onTap: () => Navigator.push(
        //       context,
        //       FadeRoute(page: ComingSoonScreen()),
        //     ),
        child: Card(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 10),
      child: new Container(
        width: 300.0,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey08),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        // height: double.infinity,
        // padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, left: 20),
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: AppColors.avatarRed,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(4.0)),
                      ),
                      child: Center(
                        child: Text(
                          Helper.getInitials(careerOpening.title),
                          style: TextStyle(color: AppColors.avatarText),
                        ),
                      ),
                    ),
                    Container(
                        // alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10),
                        width: 220,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                careerOpening.title,
                                maxLines: 2,
                                style: TextStyle(
                                  color: AppColors.greys87,
                                  fontSize: 12.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  (dateNow.from(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              careerOpening.timeStamp)))
                                      .toString(),
                                  style: TextStyle(
                                    color: AppColors.greys60,
                                    fontSize: 12.0,
                                  ),
                                ),
                              )
                            ])),
                  ],
                )),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(20),
              child: Text(
                careerOpening.description,
                maxLines: 3,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
