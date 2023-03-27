import 'package:flutter/material.dart';
// import 'package:karmayogi_mobile/charts/bar_chart.dart';
import 'package:karmayogi_mobile/charts/line_chart.dart';
import 'package:karmayogi_mobile/charts/metric_chart.dart';
import 'package:karmayogi_mobile/charts/progress_chart.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/_charts/bar_chart_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:karmayogi_mobile/models/_charts/line_chart_model.dart';
import 'package:karmayogi_mobile/util/helper.dart';
// import 'dart:developer' as developer;

class VisualizationCard extends StatefulWidget {
  // static const route = AppUrl.dashboardProfilePage;
  final visualizationData;

  VisualizationCard(this.visualizationData);
  @override
  _VisualizationCardState createState() => _VisualizationCardState();
}

class _VisualizationCardState extends State<VisualizationCard> {
  List<BarChartModel> barChartData = [];
  List<LineChartModel> lineChartData = [];
  List chartRawData = [];
  List<Map> abbreviations = [];

  // List lineChartRawData = [
  //   {
  //     "headerName": "3.1 Number of officers onboarded weekly",
  //     "headerValue": null,
  //     "headerSymbol": null,
  //     "colorPaletteCode": null,
  //     "colorPaletteId": null,
  //     "plots": [
  //       {
  //         "label": "header",
  //         "name": new DateTime(2017, 2, 25),
  //         "value": 23,
  //         "valueLabel": "Value",
  //         "symbol": "number",
  //         "parentName": null,
  //         "parentLabel": null
  //       },
  //       {
  //         "label": "header",
  //         "name": new DateTime(2017, 5, 25),
  //         "value": 12,
  //         "valueLabel": "Value",
  //         "symbol": "number",
  //         "parentName": null,
  //         "parentLabel": null
  //       },
  //       {
  //         "label": "header",
  //         "name": new DateTime(2017, 6, 25),
  //         "value": 2,
  //         "valueLabel": "Value",
  //         "symbol": "number",
  //         "parentName": null,
  //         "parentLabel": null
  //       },
  //       {
  //         "label": "header",
  //         "name": new DateTime(2017, 7, 25),
  //         "value": 11,
  //         "valueLabel": "Value",
  //         "symbol": "number",
  //         "parentName": null,
  //         "parentLabel": null
  //       },
  //       {
  //         "label": "header",
  //         "name": new DateTime(2017, 9, 25),
  //         "value": 9,
  //         "valueLabel": "Value",
  //         "symbol": "number",
  //         "parentName": null,
  //         "parentLabel": null
  //       }
  //     ]
  //   }
  // ];

  @override
  void initState() {
    chartRawData = widget.visualizationData['data'];
    if (widget.visualizationData['chartType'] == 'bar' ||
        widget.visualizationData['chartType'] == 'horizontalbar') {
      for (int i = 0; i < chartRawData[0]['plots'].length; i++) {
        String label = '';
        List<String> strings = chartRawData[0]['plots'][i]['name'].split(' ');
        if (chartRawData[0]['plots'][i]['name'].contains('(') &&
            strings.length > 3) {
          strings = chartRawData[0]['plots'][i]['name'].split('(');
          strings = chartRawData[0]['plots'][i]['name'].split(' ');
          if (strings.length > 3) {
            for (int i = 0; i < strings.length; i++) {
              if (strings[i].length > 1)
                label = '$label${strings[i].substring(0, 1)}';
            }
            label = label.split('(')[0];
          }
          abbreviations.add({label: chartRawData[0]['plots'][i]['name']});
        } else {
          if (strings.length > 3) {
            for (int i = 0; i < strings.length; i++) {
              if (strings[i].length > 1)
                label = '$label${strings[i].substring(0, 1)}';
            }
            abbreviations.add({label: chartRawData[0]['plots'][i]['name']});
          } else {
            label = chartRawData[0]['plots'][i]['name'];
          }
        }
        // developer.log(abbreviations.toString());

        barChartData.add(BarChartModel(
          labelAxis: label,
          dataAxis: chartRawData[0]['plots'][i]['value'].toDouble(),
          barColor: charts.ColorUtil.fromDartColor(AppColors.primaryThree),
        ));
      }
    } else if (widget.visualizationData['chartType'] == 'line')
      for (int i = 0; i < chartRawData[0]['plots'].length; i++) {
        List rawDate = chartRawData[0]['plots'][i]['name'].split(' - ');
        lineChartData.add(LineChartModel(
          labelAxis: new DateTime(
              2022, Helper.getMonth(rawDate[1]), int.parse(rawDate[0])),
          dataAxis: chartRawData[0]['plots'][i]['value'],
          lineColor: charts.ColorUtil.fromDartColor(AppColors.primaryThree),
        ));
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          // width: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            widget.visualizationData['chartType'] == 'bar' ||
                    widget.visualizationData['chartType'] == 'horizontalbar'
                ? Center(
                    child: ProgressChart(
                        title: chartRawData[0]['headerName'],
                        data: barChartData,
                        vertical: widget.visualizationData['chartType'] == 'bar'
                            ? true
                            : false,
                        abbreviations: abbreviations))
                // BarChart(
                //     title: chartRawData[0]['headerName'],
                //     data: barChartData,
                //     vertical: widget.visualizationData['chartType'] == 'bar'
                //         ? true
                //         : false,
                //     abbreviations: abbreviations)
                //     )
                : widget.visualizationData['chartType'] == 'line'
                    ? Column(
                        children: [
                          (widget.visualizationData['innerWidget'].length > 0 &&
                                  widget.visualizationData['innerWidget'][0] !=
                                      null)
                              ? Center(
                                  child: MetricChart(
                                  title: widget.visualizationData['innerWidget']
                                      [0]['headerName'],
                                  value: widget
                                              .visualizationData['innerWidget']
                                                  [0]['headerValue']
                                              .runtimeType ==
                                          double
                                      ? int.parse(widget
                                          .visualizationData['innerWidget'][0]
                                              ['headerValue']
                                          .toInt()
                                          .toString())
                                      : int.parse(widget
                                          .visualizationData['innerWidget'][0]
                                              ['headerValue']
                                          .toString()),
                                ))
                              : Center(),
                          Center(
                              child: LineChart(
                            title: chartRawData[0]['headerName'],
                            data: lineChartData,
                            vertical: true,
                          )),
                        ],
                      )
                    : widget.visualizationData['chartType'] == 'metric'
                        ? Center(
                            child: MetricChart(
                            title: chartRawData[0]['headerName'],
                            value: chartRawData[0]['headerValue'].runtimeType ==
                                    double
                                ? int.parse(chartRawData[0]['headerValue']
                                    .toInt()
                                    .toString())
                                : int.parse(
                                    chartRawData[0]['headerValue'].toString()),
                          ))
                        : const Center(),
          ])),
    );
  }
}
