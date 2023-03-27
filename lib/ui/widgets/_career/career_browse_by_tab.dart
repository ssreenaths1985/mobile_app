import './../../../localization/index.dart';

class CareerBrowseByTab {
  final String title;

  CareerBrowseByTab({
    this.title,
  });

  static List<CareerBrowseByTab> get items => [
        CareerBrowseByTab(
          title: EnglishLang.browseByMDO,
        ),
        CareerBrowseByTab(
          title: EnglishLang.browseByLocation,
        ),
        CareerBrowseByTab(
          title: EnglishLang.careerBrowseByCompetency,
        ),
      ];
}
