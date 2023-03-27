import 'package:equatable/equatable.dart';

class KnowledgeResource extends Equatable {
  final String id;
  final String source;
  final String name;
  final String description;
  final String documentType;
  final bool bookmark;
  final urls;
  final files;
  final krFiles;
  final raw;

  const KnowledgeResource(
      {this.id,
      this.source,
      this.name,
      this.description,
      this.documentType,
      this.bookmark,
      this.urls,
      this.files,
      this.krFiles,
      this.raw});

  factory KnowledgeResource.fromJson(Map<String, dynamic> json) {
    return KnowledgeResource(
        id: json['id'],
        source: json['source'],
        name: json['name'],
        description: json['description'],
        documentType: json['type'],
        bookmark: json['bookmark'],
        urls: json['additionalProperties'] != null
            ? json['additionalProperties']['URL']
            : [],
        files: json['additionalProperties'] != null
            ? json['additionalProperties']['files']
            : [],
        krFiles: json['additionalProperties'] != null
            ? json['additionalProperties']['krFiles']
            : [],
        raw: json);
  }

  @override
  List<Object> get props => [
        source,
        name,
        description,
        documentType,
        bookmark,
        urls,
        files,
      ];
}
