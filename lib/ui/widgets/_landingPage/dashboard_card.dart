import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/_constants/color_constants.dart';

class DashboardCard extends StatelessWidget {
  final String count;
  final String text;
  final String chart;
  final parentContext;
  const DashboardCard(
      {Key key, this.chart, this.text, this.count, this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      padding: EdgeInsets.fromLTRB(12, 12, 4, 8),
      height: (MediaQuery.of(parentContext).orientation == Orientation.portrait
              ? MediaQuery.of(parentContext).size.height
              : MediaQuery.of(parentContext).size.width) *
          0.2,
      width: MediaQuery.of(parentContext).size.width * 0.4125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(8.0) //                 <--- border radius here
              ),
          border: Border.all(color: AppColors.grey08)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: GoogleFonts.montserrat(
                  color: AppColors.orangeBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.22),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              '$text',
              style: GoogleFonts.montserrat(
                  color: AppColors.secondaryBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.22),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              padding: EdgeInsets.only(top: 8),
              // height: 30,
              // height: 50,
              child: Image.asset(
                '$chart',
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? (MediaQuery.of(context).size.width * 0.35)
                        : (MediaQuery.of(context).size.width * 0.3),
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),
      ),
    );
  }
}
