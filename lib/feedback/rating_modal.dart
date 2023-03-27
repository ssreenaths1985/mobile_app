// import 'dart:io';
// import 'dart:ffi';

import 'package:flutter/foundation.dart';

class Rating {
  final String userId;
  final double rating;

  Rating({
    @required this.userId,
    @required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_rating': rating,
    };
  }
}
