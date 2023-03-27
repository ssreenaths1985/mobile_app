import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChartModel {
  final DateTime labelAxis;
  final int dataAxis;
  final charts.Color lineColor;

  LineChartModel(
      {@required this.labelAxis,
      @required this.dataAxis,
      @required this.lineColor});
}
