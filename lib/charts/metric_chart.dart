import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';

class MetricChart extends StatelessWidget {
  final String title;
  final int value;

  MetricChart({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(
            color: AppColors.grey08,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.5),
        elevation: 5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(value.toString(),
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(
                height: 8,
              ),
              Text(title,
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  )),

              // Expanded(
              //   child: charts.BarChart(
              //     series,
              //     animate: true,
              //     vertical: this.vertical,
              //     domainAxis: charts.OrdinalAxisSpec(
              //       renderSpec: charts.SmallTickRendererSpec(
              //         labelRotation: this.vertical ? 45 : 0,
              //         labelStyle: charts.TextStyleSpec(
              //             fontSize: 10, // size in Pts.
              //             color: charts.MaterialPalette.black),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
