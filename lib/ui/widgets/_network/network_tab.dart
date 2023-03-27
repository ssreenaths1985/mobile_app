import './../../../localization/index.dart';

class NetworkTab {
  final String title;

  NetworkTab({
    this.title,
  });

  static List<NetworkTab> get items => [
        NetworkTab(
          title: EnglishLang.home,
        ),
        NetworkTab(
          title: EnglishLang.myConnections,
        ),
        NetworkTab(
          title: EnglishLang.requests,
        ),
        NetworkTab(
          title: EnglishLang.myMdo,
        ),
        NetworkTab(
          title: EnglishLang.recommended,
        ),
      ];
}
