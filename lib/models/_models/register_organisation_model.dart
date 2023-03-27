import 'package:equatable/equatable.dart';

class OrganisationModel extends Equatable {
  final String id;
  final String name;
  final String orgType;
  final String subOrgType;
  final String subOrgId;
  final String subRootOrgId;

  const OrganisationModel(
      {this.id,
      this.name,
      this.orgType,
      this.subOrgType,
      this.subOrgId,
      this.subRootOrgId});

  factory OrganisationModel.fromJson(Map<String, dynamic> json) {
    return OrganisationModel(
        id: json['mapid'],
        name: json['orgname'],
        orgType: json['sborgtype'],
        subOrgType: json['sbsuborgtype'],
        subOrgId: json['sborgid'],
        subRootOrgId: json['sbrootorgid']);
  }

  @override
  List<Object> get props =>
      [id, name, orgType, subOrgType, subOrgId, subRootOrgId];
}
