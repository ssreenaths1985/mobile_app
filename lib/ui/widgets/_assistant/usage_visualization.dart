import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../models/index.dart';
import './../../../ui/widgets/_assistant/platform_usage_line_chart.dart';

class UsageVisualization extends StatelessWidget {
  final List<PlatformUsageViewer> data = [
    PlatformUsageViewer(days: 5, hours: 2),
    PlatformUsageViewer(days: 10, hours: 5),
    PlatformUsageViewer(days: 15, hours: 1),
    PlatformUsageViewer(days: 20, hours: 18),
    PlatformUsageViewer(days: 25, hours: 3),
    PlatformUsageViewer(days: 30, hours: 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            'Platform usage',
            style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            'Usage over last 30 days',
            style: GoogleFonts.lato(
              color: AppColors.greys60,
              fontSize: 12,
            ),
          ),
        ),
        Container(height: 300, child: UsageLineChart(data)),
      ],
    );
  }
}
