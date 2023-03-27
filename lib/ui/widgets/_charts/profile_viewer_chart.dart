import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import './../../../models/index.dart';
import './../../../constants/index.dart';

class ProfileViewerChart extends StatelessWidget {
  final String legend;
  final List<ProfileViewer> data;

  ProfileViewerChart(this.legend, this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ProfileViewer, int>> series = [
      charts.Series(
        id: this.legend,
        data: data,
        domainFn: (ProfileViewer series, _) => series.year,
        measureFn: (ProfileViewer series, _) => series.sales,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(AppColors.primaryPink),
      )
    ];
    return charts.LineChart(
      series,
      animate: true,
      behaviors: [
        new charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
        )
      ],
    );
    // return Center();
  }
}
