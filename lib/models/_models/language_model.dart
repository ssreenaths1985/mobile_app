import 'package:flutter/material.dart';

class Language {
  final String language;

  const Language({
    @required this.language,
  });

  factory Language.fromJson(String json) {
    return Language(
      language: json,
    );
  }
}
