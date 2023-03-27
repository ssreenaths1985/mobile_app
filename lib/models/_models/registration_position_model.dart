import 'package:equatable/equatable.dart';

class RegistrationPosition extends Equatable {
  final String id;
  final String name;
  final String description;

  const RegistrationPosition({
    this.id,
    this.name,
    this.description,
  });

  factory RegistrationPosition.fromJson(Map<String, dynamic> json) {
    return RegistrationPosition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  @override
  List<Object> get props => [id, name, description];
}
