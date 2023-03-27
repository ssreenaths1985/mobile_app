import './../../../localization/index.dart';

class InterestsTab {
  final String title;

  InterestsTab({
    this.title,
  });

  static List<InterestsTab> get items => [
        InterestsTab(
          title: EnglishLang.rolesAndActivities,
        ),
        InterestsTab(
          title: EnglishLang.topics,
        ),
        InterestsTab(
          title: EnglishLang.currentCompetencies,
        ),
        InterestsTab(
          title: EnglishLang.desiredCompetency,
        ),
        InterestsTab(
          title: EnglishLang.platformWalkthrough,
        ),
      ];
}
