import 'package:flutter/material.dart';

class Badge {
  final String image;
  final String name;
  final String group;
  final String recievedDate;

  const Badge({
    @required this.image,
    @required this.name,
    @required this.group,
    @required this.recievedDate,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      image: json['image'] as String,
      name: json['badge_name'] as String,
      group: json['badge_group'] as String,
      recievedDate: json['first_received_date'] as String,
    );
  }
}
