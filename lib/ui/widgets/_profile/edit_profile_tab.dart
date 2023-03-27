import './../../../localization/index.dart';

class EditProfileTab {
  final String title;

  EditProfileTab({
    this.title,
  });

  static List<EditProfileTab> get items => [
        EditProfileTab(
          title: EnglishLang.personalDetails,
        ),
        EditProfileTab(
          title: EnglishLang.academics,
        ),
        EditProfileTab(
          title: EnglishLang.professionalDetails,
        ),
        EditProfileTab(
          title: EnglishLang.certificationAndSkills,
        ),
      ];
}
