import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartModel {
  final String labelAxis;
  final double dataAxis;
  final charts.Color barColor;

  BarChartModel(
      {@required this.labelAxis,
      @required this.dataAxis,
      @required this.barColor});
}
