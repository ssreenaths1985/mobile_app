import './../../../localization/index.dart';

class CareerTab {
  final String title;

  CareerTab({
    this.title,
  });

  static List<CareerTab> get items => [
        CareerTab(
          title: EnglishLang.careersHome,
        ),
        CareerTab(
          title: EnglishLang.fromYourMDO,
        ),
        CareerTab(
          title: EnglishLang.yourPosition,
        ),
        CareerTab(
          title: EnglishLang.following,
        ),
      ];
}
