import 'package:flutter/material.dart';

class VegaHelpItem {
  final String heading;
  final String description;
  final List<String> intents;

  const VegaHelpItem({
    @required this.heading,
    this.description,
    @required this.intents,
  });
}
