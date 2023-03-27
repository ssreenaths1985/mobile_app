class LandingPageInfo {
  final String karmayogiOnboarded;
  final String registeredMdo;
  final String courses;
  final String availableContent;
  final String courseEnrollments;
  final String activeUsers;
  final raw;

  const LandingPageInfo(
      {this.karmayogiOnboarded,
      this.registeredMdo,
      this.courses,
      this.availableContent,
      this.courseEnrollments,
      this.activeUsers,
      this.raw});

  factory LandingPageInfo.fromJson(Map<String, dynamic> json) {
    return LandingPageInfo(
        karmayogiOnboarded: json['karmayogiOnboarded'] as String,
        registeredMdo: json['registeredMdo'] as String,
        courses: json['courses'],
        availableContent: json['availableContent'],
        courseEnrollments: json['courseEnrollments'],
        activeUsers: json['activeUsers'],
        raw: json);
  }
}
