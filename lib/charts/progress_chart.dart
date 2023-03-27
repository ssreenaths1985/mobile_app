import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/models/_charts/bar_chart_model.dart';

class ProgressChart extends StatelessWidget {
  final String title;
  final List<BarChartModel> data;
  final bool vertical;
  final List<Map> abbreviations;

  ProgressChart(
      {@required this.title,
      @required this.data,
      @required this.vertical,
      @required this.abbreviations});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // height: (data.length * (vertical ? 60 : 58)) +
        //     double.parse(((abbreviations.length * 12)).toString()),
        // height: data.length.toDouble() * (vertical ? 50 : 71),
        padding: EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var i = 0; i < data.length; i++)
                          (Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.425,
                                    child: Text(data[i].labelAxis,
                                        style: GoogleFonts.lato(fontSize: 16)),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data[i].dataAxis.toString().substring(
                                                    data[i]
                                                            .dataAxis
                                                            .toString()
                                                            .length -
                                                        2,
                                                    data[i]
                                                        .dataAxis
                                                        .toString()
                                                        .length) ==
                                                '.0'
                                            ? '${data[i].dataAxis.toString().replaceAll('.0', '')}'
                                            : '${data[i].dataAxis.toString()}',
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: TweenAnimationBuilder<double>(
                                            tween: Tween<double>(
                                                begin: 0.0,
                                                end: data[i].dataAxis /
                                                    data[0].dataAxis),
                                            duration: const Duration(
                                                milliseconds: 750),
                                            builder: (context, value, _) =>
                                                LinearProgressIndicator(
                                              minHeight: 12,
                                              backgroundColor:
                                                  Colors.transparent,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                AppColors.indicatorColor,
                                              ),
                                              value: value,
                                            ),
                                          )),
                                      // Text('Indicator')
                                    ],
                                  )
                                ],
                              ),
                              Divider(
                                color: AppColors.grey08,
                                height: 25,
                                thickness: 1,
                              )
                            ],
                          ))
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 12,
                // ),
                abbreviations.length > 0
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(0, 16, 2, 5),
                        child: Wrap(children: [
                          for (Map item in abbreviations)
                            Container(
                              width: double.infinity,
                              child: HtmlWidget(
                                  '<b>${item.keys.elementAt(0)}</b>: ' +
                                      item.values.elementAt(0),
                                  textStyle: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  )),
                            )
                        ]),
                      )
                    : const Center()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
