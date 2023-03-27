import 'package:equatable/equatable.dart';

class Wtoken extends Equatable {
  final String wid;
  final String userName;
  final String firstName;
  final String lastName;
  final String deptName;
  final String deptId;
  final String email;
  final String designation;
  // final String cookie;

  const Wtoken(
      {this.wid,
      this.userName,
      this.firstName,
      this.lastName,
      this.deptName,
      this.deptId,
      this.email,
      this.designation
      // this.cookie,
      });

  factory Wtoken.fromJson(Map<String, dynamic> json) {
    return Wtoken(
        wid: json['id'],
        userName: json['userName'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        deptName: json['rootOrg']['orgName'],
        deptId: json['rootOrgId'],
        email: json['email'],
        designation: json['profileDetails'] != null
            ? ((json['profileDetails']['professionalDetails'] != null &&
                    (json['profileDetails']['professionalDetails'].length > 0 &&
                        json['profileDetails']['professionalDetails'][0] !=
                            null))
                ? json['profileDetails']['professionalDetails'][0]
                    ['designation']
                : null)
            : null
        // email: json['profileDetails']['personalDetails'] != null
        //     ? json['profileDetails']['personalDetails']['primaryEmail']
        // : '',
        // cookie: json['cookie'],
        );
  }

  @override
  List<Object> get props => [
        wid,
        userName,
        firstName,
        lastName,
        deptName,
        deptId,
        email,
        designation
        // cookie,
      ];
}
