import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../ui/widgets/index.dart';

class Visualization extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String legend;
  final bool displayTotalViews;
  final data;
  final String chartType;
  Visualization(
      {@required this.heading,
      @required this.subHeading,
      @required this.legend,
      @required this.displayTotalViews,
      @required this.data,
      @required this.chartType});

  generateVisualization() {
    var visualizationWidgets = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    visualizationWidgets.children.add(
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(bottom: 5),
        child: Text(
          heading,
          style: GoogleFonts.lato(
            color: AppColors.greys87,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
    visualizationWidgets.children.add(
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(bottom: 5),
        child: Text(
          subHeading,
          style: GoogleFonts.lato(
            color: AppColors.greys60,
            fontSize: 12,
          ),
        ),
      ),
    );

    if (displayTotalViews) {
      visualizationWidgets.children.add(
        Container(
          alignment: Alignment.topLeft,
          color: AppColors.lightGrey,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          margin: EdgeInsets.only(top: 10, bottom: 10),
          height: 80,
          width: 150,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: Text(
                  'Total views',
                  style: GoogleFonts.lato(
                    color: AppColors.greys60,
                    fontSize: 12,
                  ),
                  // textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '24',
                      style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.arrow_upward,
                      color: AppColors.positiveLight,
                    ),
                    Text(
                      '%change',
                      style: GoogleFonts.lato(
                        color: AppColors.positiveLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    if (chartType == ChartType.profileViews) {
      visualizationWidgets.children.add(
        Container(height: 300, child: ProfileViewerChart(legend, data)),
      );
    }
    if (chartType == ChartType.platformUsage) {
      visualizationWidgets.children.add(
        Container(height: 300, child: PlatformUsageChart(legend, data)),
      );
    }

    return visualizationWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return generateVisualization();
  }
}
