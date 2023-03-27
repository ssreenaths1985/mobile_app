import 'package:flutter/material.dart';

class CareerOpening {
  final String title;
  final String description;
  final dynamic timeStamp;
  final String hrs;
  final int viewCount;
  final List tags;

  CareerOpening(
      {@required this.title,
      @required this.description,
      @required this.timeStamp,
      this.viewCount,
      this.hrs,
      this.tags});

  factory CareerOpening.fromJson(Map<String, dynamic> json) {
    return CareerOpening(
        title: json['title'] as String,
        // description: json['teaser']['content'] as String,
        description: json['titleRaw'] as String,
        timeStamp: json['timestamp'],
        viewCount: json['viewcount'],
        tags: json['tags']);
  }
}
