import './../../../localization/index.dart';

class CompetencyTypesTab {
  final String title;

  CompetencyTypesTab({
    this.title,
  });

  static List<CompetencyTypesTab> get items => [
        CompetencyTypesTab(
          title: EnglishLang.recommendedFromFrac,
        ),
        CompetencyTypesTab(
          title: EnglishLang.recommendedFromWAT,
        ),
        CompetencyTypesTab(
          title: EnglishLang.addedByYou,
        ),
        // CompetencyTypesTab(
        //   title: EnglishLang.desired,
        // ),
      ];
}
