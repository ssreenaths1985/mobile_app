import 'package:equatable/equatable.dart';

class LoginUser extends Equatable {
  final String email;
  final String mobileNumber;
  final String loginId;
  final String firstName;
  final String lastName;
  final String parichayId;

  const LoginUser(
      {this.email,
      this.mobileNumber,
      this.loginId,
      this.firstName,
      this.lastName,
      this.parichayId});

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
        email: json['Email'],
        mobileNumber: json['MobileNo'],
        loginId: json['loginId'],
        firstName: json['FirstName'],
        lastName: json['LastName'],
        parichayId: json['parichayId']);
  }

  @override
  List<Object> get props =>
      [email, mobileNumber, loginId, firstName, lastName, parichayId];
}
