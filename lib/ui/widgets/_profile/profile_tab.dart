import './../../../localization/index.dart';

class ProfileTab {
  final String title;

  ProfileTab({
    this.title,
  });

  static List<ProfileTab> get items => [
        ProfileTab(
          title: EnglishLang.profile,
        ),
        ProfileTab(
          title: EnglishLang.myDiscussions,
        ),
        ProfileTab(
          title: EnglishLang.savedPosts,
        ),
      ];
}
