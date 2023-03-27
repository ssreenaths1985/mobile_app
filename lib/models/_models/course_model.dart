import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/util/helper.dart';

class Course {
  final String id;
  final String appIcon;
  final String name;
  final String description;
  final String duration;
  final double rating;
  final String creatorIcon;
  final String creatorLogo;
  final String contentType;
  final String source;
  final raw;

  Course({
    @required this.id,
    @required this.appIcon,
    @required this.name,
    @required this.description,
    @required this.duration,
    this.creatorIcon,
    this.rating,
    this.creatorLogo,
    this.contentType,
    this.source,
    this.raw,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['identifier'] as String,
      appIcon: Helper.convertToPortalUrl(json['posterImage']),
      name: json['name'] as String,
      description: json['description'] as String,
      duration: json['duration'] != null
          ? json['duration']
          : ((json['content'] != null && json['content']['duration'] != null)
              ? json['content']['duration']
              : null) as String,
      rating: 0.0,
      creatorIcon: json['creatorIcon'] as String,
      creatorLogo: json['creatorLogo'] != null
          ? Helper.convertToPortalUrl(json['creatorLogo'])
          : '',
      contentType: json['primaryCategory'] != null
          ? json['primaryCategory']
          : ((json['content'] != null &&
                  json['content']['primaryCategory'] != null)
              ? json['content']['primaryCategory']
              : ''),
      source: json['source'] != null ? json['source'].toString() : '',
      raw: json,
    );
  }
}
