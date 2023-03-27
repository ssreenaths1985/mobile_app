import 'package:flutter/material.dart';

class BrowseBy {
  final int id;
  final String title;
  final String description;
  final bool comingSoon;
  final String svgImage;
  final String url;


  const BrowseBy(
      {@required this.id,
      @required this.title,
      @required this.description,
      this.comingSoon,
      this.svgImage,
      this.url
      });
}
