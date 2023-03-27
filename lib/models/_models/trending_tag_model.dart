import 'package:equatable/equatable.dart';

class TrendingTag extends Equatable {
  final String tagValue;
  final int tagScore;

  const TrendingTag({this.tagValue, this.tagScore});

  factory TrendingTag.fromJson(Map<String, dynamic> json) {
    return TrendingTag(
      tagValue: json['value'],
      tagScore: json['score'],
    );
  }

  @override
  List<Object> get props => [
        tagValue,
        tagScore,
      ];
}
