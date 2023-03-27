import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import './../../../models/index.dart';
import './../../../constants/index.dart';

class PlatformUsageChart extends StatelessWidget {
  final String legend;
  final List<PlatformUsage> data;

  PlatformUsageChart(this.legend, this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PlatformUsage, int>> series = [
      charts.Series(
        id: this.legend,
        data: data,
        domainFn: (PlatformUsage series, _) => series.views,
        measureFn: (PlatformUsage series, _) => series.hours,
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
