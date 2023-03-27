import 'dart:convert';

class EventDetail {
  final String identifier;
  final String name;
  final String description;
  final String eventIcon;
  final String source;
  final dynamic creatorDetails;
  final dynamic startDate;
  final dynamic startTime;
  final dynamic endTime;
  final String eventType;
  final dynamic lastUpdatedOn;
  final String learningObjective;
  final dynamic expiryDate;
  final dynamic endDate;
  final String instructions;
  final String registrationLink;

  EventDetail(
      {this.identifier,
      this.name,
      this.description,
      this.eventIcon,
      this.source,
      this.creatorDetails,
      this.startDate,
      this.startTime,
      this.endTime,
      this.eventType,
      this.lastUpdatedOn,
      this.learningObjective,
      this.expiryDate,
      this.endDate,
      this.instructions,
      this.registrationLink});

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      identifier: json['identifier'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      eventIcon: json['appIcon'] as String,
      source: json['sourceName'] as String,
      creatorDetails: json['creatorDetails'] != null
          ? jsonDecode(json['creatorDetails'])
          : [],
      startDate: json['startDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      eventType: json['resourceType'] as String,
      lastUpdatedOn: json['lastUpdatedOn'],
      learningObjective: json['learningObjective'],
      expiryDate: json['expiryDate'],
      endDate: json['endDate'],
      instructions: json['instructions'],
      registrationLink: json['registrationLink'],
    );
  }
}
