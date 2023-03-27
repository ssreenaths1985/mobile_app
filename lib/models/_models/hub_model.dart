import 'package:flutter/material.dart';

class Hub {
  final int id;
  final String title;
  final String description;
  final Object icon;
  final Object iconColor;
  final bool comingSoon;
  final String url;
  final int points;
  final String svgIcon;
  final bool svg;

  const Hub(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.icon,
      @required this.iconColor,
      this.comingSoon,
      this.url,
      this.points,
      this.svgIcon,
      this.svg});
}
