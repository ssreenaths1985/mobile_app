class CourseConfig {
  final String title;
  final String description;
  final Map requestBody;

  CourseConfig({this.title, this.description, this.requestBody});

  factory CourseConfig.fromJson(Map<String, dynamic> json) {
    return CourseConfig(
        title: json['title'],
        description: json['description'],
        requestBody: json['request']);
  }
}
