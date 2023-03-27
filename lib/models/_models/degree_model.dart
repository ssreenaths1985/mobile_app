import 'package:flutter/material.dart';

class Degree {
  final String degree;

  const Degree({
    @required this.degree,
  });

  factory Degree.fromJson(String json) {
    return Degree(
      degree: json,
    );
  }
}
