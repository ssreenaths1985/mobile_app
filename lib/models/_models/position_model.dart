import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final String type;
  final String id;
  final String name;
  final String description;
  final String status;
  final String source;
  final String department;

  const Position({
    this.type,
    this.id,
    this.name,
    this.description,
    this.status,
    this.source,
    this.department,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      type: json['type'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      source: json['source'],
      // department: json['additionalProperties']['Department'],
      department: '',
    );
  }

  @override
  List<Object> get props =>
      [type, id, name, description, status, source, department];
}