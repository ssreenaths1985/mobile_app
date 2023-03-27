import 'package:flutter/material.dart';

class Organisation {
  final String organisation;

  const Organisation({
    @required this.organisation,
  });

  factory Organisation.fromJson(Map<String, dynamic> json) {
    return Organisation(
      organisation: json as String,
    );
  }
}
