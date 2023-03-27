import 'package:karmayogi_mobile/models/_models/course_config_model.dart';

class LearnConfig {
  final CourseConfig continueLearning;
  final CourseConfig mandatoryCourse;
  final CourseConfig recommendedCourse;
  final CourseConfig basedOnInterest;
  final CourseConfig newlyAddedCourse;
  final CourseConfig curatedCollectionConfig;
  final CourseConfig programsConfig;
  final raw;

  LearnConfig(
      {this.continueLearning,
      this.mandatoryCourse,
      this.basedOnInterest,
      this.recommendedCourse,
      this.newlyAddedCourse,
      this.curatedCollectionConfig,
      this.programsConfig,
      this.raw});

  factory LearnConfig.fromJson(Map<String, dynamic> json) {
    return LearnConfig(
        continueLearning: json['continueLearning'],
        mandatoryCourse: json['mandatoryCourse'],
        recommendedCourse: json['recommendedCourse'],
        basedOnInterest: json['recommendedCourse'],
        newlyAddedCourse: json['latestCourses'],
        curatedCollectionConfig: json['curatedCollections'],
        programsConfig: json['programs'],
        raw: json);
  }
}
