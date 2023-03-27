import './../../../localization/index.dart';

class CompetencyTab {
  final String title;

  CompetencyTab({
    this.title,
  });

  static List<CompetencyTab> get items => [
        CompetencyTab(
          title: EnglishLang.yourCompetencies,
        ),
        CompetencyTab(
          title: EnglishLang.allCompetencies,
        ),
        // CompetencyTab(
        //   title: EnglishLang.desiredCompetencies,
        // ),
      ];
}
