import 'package:flutter/widgets.dart';

class InformationCardModel {
  final int scenarioNumber;
  final IconData icon;
  final String information;
  final Color iconColor;

  const InformationCardModel(
      {this.scenarioNumber, this.icon, this.information, this.iconColor});
}
