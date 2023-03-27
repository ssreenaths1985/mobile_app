import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../../../models/index.dart';
import '../../../constants/index.dart';

class UsageLineChart extends StatelessWidget {
  final List<PlatformUsageViewer> data;

  UsageLineChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PlatformUsageViewer, int>> series = [
      charts.Series(
        id: 'Usage in hours',
        data: data,
        domainFn: (PlatformUsageViewer series, _) => series.days,
        measureFn: (PlatformUsageViewer series, _) => series.hours,
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
