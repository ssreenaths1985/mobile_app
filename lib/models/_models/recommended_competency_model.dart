class RecommendedCompetencyCardModel {
  final String type;
  final String id;
  final String name;
  final String description;
  final String status;
  final String source;
  final bool bookmark;
  final String competencyType;
  final String competencyArea;
  // final int count;

  final int selfAttestedLevel;
  String courseCompetencyLevel;

  final rawDetails;

  RecommendedCompetencyCardModel(
      {this.type,
      this.id,
      this.name,
      this.description,
      this.status,
      this.source,
      this.bookmark,
      this.competencyType,
      // this.count,
      this.competencyArea,
      this.selfAttestedLevel,
      this.courseCompetencyLevel,
      this.rawDetails});

  factory RecommendedCompetencyCardModel.fromJson(Map<String, dynamic> json) {
    return RecommendedCompetencyCardModel(
      type: json['type'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      source: json['source'],
      competencyType: json['additionalProperties']['competencyType'],
      competencyArea: json['additionalProperties']['competencyArea'],

      // selfAttestedLevel: json['competencySelfAttestedLevel'],
      // courseCompetencyLevel: json['selectedLevelLevel'],

      rawDetails: json,
    );
  }
}
