// import 'package:flutter/material.dart';

class ProviderCardModel {
  final String name;
  final String orgId;
  final int contentCount;
  final String logoUrl;
  final String description;

  ProviderCardModel(
      {this.name,
      this.orgId,
      this.contentCount,
      this.logoUrl,
      this.description});

  factory ProviderCardModel.fromJson(Map<String, dynamic> json) {
    return ProviderCardModel(
        name: json['name'],
        orgId: json['orgId'],
        contentCount: json['contentCount'],
        logoUrl: json['logoUrl'],
        description: json['description']);
  }
}
