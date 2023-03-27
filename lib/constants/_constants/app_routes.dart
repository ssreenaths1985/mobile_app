// import 'package:karmayogi_mobile/ui/screens/_screens/browse_by_competency.dart';

// import 'package:karmayogi_mobile/ui/pages/index.dart';

import 'package:karmayogi_mobile/constants/index.dart';

class AppUrl {
  // Login
  static const loginPage = '/loginPage';
  static const onboardingScreen = '/onboardingScreen';

  // Hubs
  static const landingPage = '/landingPage';
  static const homePage = '/homePage';
  static const discussionHub = '/discussionHub';
  static const learningHub = '/learningHub';
  static const networkHub = '/networkHub';
  static const competencyHub = '/competencyHub';
  static const careersHub = '/careerHub';
  static const eventsHub = '/eventsHub';

  // Sub pages
  static const discussPage = '/discussPage';
  static const networkHomePage = '/networkHomePage';
  static const learnPage = '/learnPage';
  static const careersPage = '/careersPage';
  static const competenciesPage = '/competenciesPage';
  static const discussionsPage = '/discussionsPage';
  static const competencyPage = '/competencyPage';
  static const eventsPage = '/eventsPage';

  // Profile pages
  static const profilePage = '/profilePage';
  static const editProfilePage = '/editProfilePage';
  static const dashboardPage = '/dashboardPage';

  // Dashboard pages
  static const dashboardProfilePage = '/dashboardProfilePage';
  static const dashboardCategoriesPage = '/dashboardCategoriesPage';
  static const dashboardTagsPage = '/dashboardTagsPage';
  static const dashboardLeaderBoardPage = '/dashboardLeaderBoardPage';
  static const assistantPage = '/assistantPage';
  static const textSearchResultsPage = '/textSearchResultsPage';

  //Assistant Page
  static const aiAssistantPage = '/aiAssistantPage';

  //Network pages
  static const networkProfilePage = '/networkProfilePage';
  static const comingSoonPage = '/comingSoonPage';
  static const settingsPage = '/settingsPage';
  static const interestsPage = '/interestsPage';
  static const notificationsPage = '/notificationsPage';

  // Brrowse by
  static const browseByCompetencyPage = '/browseByCompetencyPage';
  static const browseByProviderPage = '/browseByProviderPage';
  static const browseByTopicPage = '/browseByTopicPage';
  static const curatedCollectionsPage = '/curatedCollectionsPage';
  static const coursesInCompetency = '/coursesInCompetency';

  //Knowledge Resources Page
  static const knowledgeResourcesPage = '/knowledgeResourcesPage';

  static String webAppUrl = ApiUrl.baseUrl;
  static String fracDictionaryUrl =
      'https://frac-dictionary.${ApiUrl.baseUrl.replaceAll('https://', '')}';
}
