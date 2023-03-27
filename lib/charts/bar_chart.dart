import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/models/_charts/bar_chart_model.dart';

class BarChart extends StatelessWidget {
  final String title;
  final List<BarChartModel> data;
  final bool vertical;
  final List<Map> abbreviations;

  BarChart(
      {@required this.title,
      @required this.data,
      @required this.vertical,
      @required this.abbreviations});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "BarChartModel",
          labelAccessorFn: (BarChartModel skill, _) => skill.dataAxis
                      .toString()
                      .substring(skill.dataAxis.toString().length - 2,
                          skill.dataAxis.toString().length) ==
                  '.0'
              ? '${skill.dataAxis.toString().replaceAll('.0', '')}'
              : '${skill.dataAxis.toString()}',
          insideLabelStyleAccessorFn: (BarChartModel skill, _) {
            final color = charts.MaterialPalette.white;
            return new charts.TextStyleSpec(color: color, fontSize: 10);
          },
          outsideLabelStyleAccessorFn: (BarChartModel skill, _) {
            final color = charts.MaterialPalette.black;
            return new charts.TextStyleSpec(color: color, fontSize: 10);
          },
          data: data,
          domainFn: (BarChartModel skill, _) => skill.labelAxis,
          measureFn: (BarChartModel skill, _) => skill.dataAxis,
          colorFn: (BarChartModel skill, _) =>
              charts.ColorUtil.fromDartColor(AppColors.indicatorColor)),
    ];

    return Container(
      height: 400 + double.parse((abbreviations.length * 12).toString()),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  )),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  vertical: this.vertical,
                  barRendererDecorator: new charts.BarLabelDecorator<String>(),
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelRotation: this.vertical ? 45 : 0,
                      labelStyle: charts.TextStyleSpec(
                          fontSize: 10, // size in Pts.
                          color: charts.MaterialPalette.black),
                    ),
                  ),
                ),
              ),
              abbreviations.length > 0
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 2, 5),
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
    );
  }
}
