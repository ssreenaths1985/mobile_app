class BrowseCompetencyCardModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final String competencyType;
  final String competencyArea;
  final int count;
  final String status;
  final int selfAttestedLevel;
  String courseCompetencyLevel;
  final String source;
  final List levels;
  final int competencyCBPCompletionLevel;
  final String competencySelfAttestedLevelName;
  final String competencySelfAttestedLevelValue;
  final rawDetails;

  BrowseCompetencyCardModel(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.competencyType,
      this.count,
      this.competencyArea,
      this.status,
      this.selfAttestedLevel,
      this.courseCompetencyLevel,
      this.source,
      this.levels,
      this.competencyCBPCompletionLevel,
      this.competencySelfAttestedLevelName,
      this.competencySelfAttestedLevelValue,
      this.rawDetails});

  factory BrowseCompetencyCardModel.fromJson(Map<String, dynamic> json) {
    return BrowseCompetencyCardModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      competencyType: json['competencyType'] != null
          ? json['competencyType']
          : json['additionalProperties'] != null
              ? json['additionalProperties']['competencyType']
              : '',
      count: json['contentCount'],
      competencyArea: json['competencyArea'] != null
          ? json['competencyArea']
          : json['additionalProperties'] != null
              ? json['additionalProperties']['competencyArea']
              : '',
      status: json['status'],
      selfAttestedLevel: json['competencySelfAttestedLevel'].runtimeType ==
              String
          ? (json['competencySelfAttestedLevel'].length == 1
              ? int.parse(json['competencySelfAttestedLevel'])
              : (json['competencySelfAttestedLevelValue'].split(' ').length == 2
                  ? int.parse(json['competencySelfAttestedLevelValue']
                      .toString()
                      .split('')
                      .last)
                  : null))
          : json['competencySelfAttestedLevel'],
      courseCompetencyLevel: json['selectedLevelLevel'],
      source: json['source'],
      levels: json['children'],
      competencyCBPCompletionLevel:
          json['competencyCBPCompletionLevel'].runtimeType == String
              ? int.parse(json['competencyCBPCompletionLevel'])
              : json['competencyCBPCompletionLevel'],
      competencySelfAttestedLevelName: json['competencySelfAttestedLevelName'],
      competencySelfAttestedLevelValue:
          json['competencySelfAttestedLevelValue'],
      rawDetails: json,
    );
  }
}
