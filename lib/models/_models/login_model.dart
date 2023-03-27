import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final String accessToken;
  final String refreshToken;

  const Login({
    this.accessToken,
    this.refreshToken,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  @override
  List<Object> get props => [
        accessToken,
        refreshToken,
      ];
}
