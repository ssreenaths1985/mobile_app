import 'package:equatable/equatable.dart';

class Network extends Equatable {
  final dynamic results;

  const Network({
    this.results,
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      results: json['results'],
    );
  }

  @override
  List<Object> get props => [
        results,
      ];
}
