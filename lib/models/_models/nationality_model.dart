import 'package:flutter/material.dart';

class Nationality {
  final String country;
  final String countryCode;

  const Nationality({
    @required this.country,
    @required this.countryCode,
  });

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      country: json['name'] as String,
      countryCode: json['countryCode'] as String,
    );
  }
}
