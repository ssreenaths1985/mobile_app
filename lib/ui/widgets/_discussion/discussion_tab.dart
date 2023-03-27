import './../../../localization/index.dart';

class DiscussionTab {
  final String title;

  DiscussionTab({
    this.title,
  });

  static List<DiscussionTab> get items => [
        DiscussionTab(
          title: EnglishLang.allDiscussions,
        ),
        DiscussionTab(
          title: EnglishLang.categories,
        ),
        DiscussionTab(
          title: EnglishLang.tags,
        ),
        DiscussionTab(title: EnglishLang.myDiscussions),
      ];
}
