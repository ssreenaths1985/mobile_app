import './../../../localization/index.dart';

class CareerDetailsTab {
  final String title;

  CareerDetailsTab({
    this.title,
  });

  static List<CareerDetailsTab> get items => [
        CareerDetailsTab(
          title: EnglishLang.positionInfo,
        ),
        CareerDetailsTab(
          title: EnglishLang.opening,
        ),
        CareerDetailsTab(
          title: EnglishLang.about,
        ),
        CareerDetailsTab(
          title: EnglishLang.people,
        ),
        CareerDetailsTab(
          title: EnglishLang.competencies,
        ),
        CareerDetailsTab(
          title: EnglishLang.relatedCourses,
        ),
      ];
}
