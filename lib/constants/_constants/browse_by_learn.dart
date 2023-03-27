import 'package:karmayogi_mobile/constants/index.dart';
import './../../models/index.dart';
import './../../localization/index.dart';

const BROWSEBY = const [
  BrowseBy(
      id: 1,
      title: EnglishLang.exploreByTopic,
      description: EnglishLang.browseTopics,
      comingSoon: false,
      svgImage: 'assets/img/browse-by-topic.svg',
      url: AppUrl.browseByTopicPage),
  BrowseBy(
      id: 2,
      title: EnglishLang.exploreByCompetency,
      description: EnglishLang.browseCompetency,
      comingSoon: false,
      svgImage: 'assets/img/browse-by-competency.svg',
      url: AppUrl.browseByCompetencyPage),
  BrowseBy(
      id: 3,
      title: EnglishLang.exploreByProvider,
      description: EnglishLang.browseProvider,
      comingSoon: false,
      svgImage: 'assets/img/browse-by-provider.svg',
      url: AppUrl.browseByProviderPage),
  BrowseBy(
      id: 4,
      title: EnglishLang.curatedCollections,
      description: EnglishLang.browseCuratedCollections,
      comingSoon: false,
      svgImage: 'assets/img/browse-by-provider.svg',
      url: AppUrl.curatedCollectionsPage),
];
