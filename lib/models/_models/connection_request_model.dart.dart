import 'package:equatable/equatable.dart';

class ConnectionRequest extends Equatable {
  final dynamic data;

  const ConnectionRequest({
    this.data,
  });

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      data: json['data'],
    );
  }

  @override
  List<Object> get props => [
        data,
      ];
}
