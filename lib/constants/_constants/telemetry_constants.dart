class TelemetryEvent {
  static const String start = 'START';
  static const String end = 'END';
  static const String impression = 'IMPRESSION';
  static const String audit = 'AUDIT';
  static const String interact = 'INTERACT';
}

class TelemetryEntity {
  static const String start = 'User';
}

class TelemetryType {
  static const String page = 'Page';
  static const String public = 'Public';
  static const String viewer = 'Viewer';
  static const String player = 'Player';
}

class TelemetrySubType {
  static const String courseCard = 'card-courseCard';
  static const String contentCard = 'card-contentCard';
  static const String userCard = 'card-userCard';
  static const String discussionCard = 'card-discussionCard';
  static const String tagCard = 'card-tagCard';
  static const String categoryCard = 'card-categoryCard';
  static const String upVoteIcon = 'icon-upVoteIcon';
  static const String downVoteIcon = 'icon-downVoteIcon';
  static const String bookmarkIcon = 'icon-bookmarkIcon';
  static const String nextPageButton = 'button-nextPageButton';
  static const String previousPageButton = 'button-previousPageButton';
  static const String lastPageButton = 'button-lastPageButton';
  static const String firstPageButton = 'button-firstPageButton';
  static const String pauseButton = 'button-pauseButton';
  static const String playButton = 'button-playButton';
  static const String learnSearch = 'card-learnSearch';
  static const String sideMenu = 'side-menu';
  static const String courseTab = 'course_tab';
  static const String competencyTab = 'competency-tab';
  static const String profileEditTab = 'profile-edit-tab';
  static const String click = 'click';
  static const String submit = 'submit';
  static const String competencyHome = 'yourCompetencies-menu';
  static const String allCompetencies = 'allCompetencies-menu';
  static const String recommendedTab = 'recommended-tab';
  static const String recommendedFromFracTab = 'recommendedFromFrac-tab';
  static const String recommendedFromWatTab = 'recommendedFromWat-tab';
  static const String addedByYouTab = 'addedByYou-tab';
  static const String overviewTab = 'overview-tab';
  static const String contentTab = 'content-tab';
  static const String discussionTab = 'discussion-tab';
  static const String learnersTab = 'learners-tab';
  static const String personalDetailsTab = 'personalDetails-tab';
  static const String academicsTab = 'academics-tab';
  static const String professionalDetailsTab = 'professionalDetails-tab';
  static const String certificationSkillsTab = 'certificationSkills-tab';
  static const String eventsTab = 'events-tab';
  static const String allTab = 'all-tab';
  static const String hostedByMyMDOTab = 'hostedByMyMdo-tab';
}

class TelemetryMode {
  static const String view = 'View';
  static const String play = 'Play';
}

class TelemetryPageIdentifier {
  // Homepage
  static const String homePageId = '/home';
  static const String homePageUri = 'page/home';
  // Learn hub
  static const String learnPageId = '/learn';
  static const String learnPageUri = 'page/learn';
  static const String allTopicsPageId = '/app/taxonomy/home';
  static const String allTopicsPageUri = 'app/taxonomy/home';
  static const String allCollectionsPageId = '/app/curatedCollections/home';
  static const String allCollectionsPageUri = 'app/curatedCollections/home';
  static const String topicCoursesPageId = '/app/taxonomy/:topic';
  static const String topicCoursesPageUri = 'app/taxonomy/:topic';
  static const String courseDetailsPageId = '/app/toc/:do_ID/overview';
  static const String courseDetailsPageUri = 'app/toc/:do_ID/overview';
  static const String publicCourseDetailsPageId = '/public/toc/:do_ID/overview';
  static const String publicCourseDetailsPageUri = 'public/toc/:do_ID/overview';
  static const String htmlPlayerPageId = '/viewer/html/:resourceId';
  static const String htmlPlayerPageUri = 'viewer/html/:resourceId';
  static const String pdfPlayerPageId = '/viewer/pdf/:resourceId';
  static const String pdfPlayerPageUri =
      'viewer/pdf/:resourceId?primaryCategory=Learning%20Resource&collectionId=:collectionId&collectionType=Course&batchId=:batchId';
  static const String audioPlayerPageId = '/viewer/audio/:resourceId';
  static const String audioPlayerPageUri =
      'viewer/audio/:resourceId?primaryCategory=Learning%20Resource&collectionId=:collectionId&collectionType=Course&batchId=:batchId';
  static const String videoPlayerPageId = '/viewer/video/:resourceId';
  static const String videoPlayerPageUri =
      'viewer/video/:resourceId?primaryCategory=Learning%20Resource&collectionId=:collectionId&collectionType=Course&batchId=:batchId';
  static const String assessmentPlayerPageId = '/viewer/quiz/:resourceId';
  static const String assessmentPlayerPageUri =
      'viewer/quiz/:resourceId?primaryCategory=Learning%20Resource&collectionId=:collectionId&collectionType=Course&batchId=:batchId';
  static const String youtubePlayerPageId = '/viewer/youtube/:resourceId';
  static const String youtubePlayerPageUri =
      'viewer/youtube/:resourceId?primaryCategory=Learning%20Resource&collectionId=:collectionId&collectionType=Course&batchId=:batchId';
  // Discuss hub
  static const String discussionsPageId = '/app/discussion-forum';
  static const String discussionsPageUri = 'app/discussion-forum?page=home';
  static const String addDiscussionPageId = '/app/discussion-forum/add';
  static const String addDiscussionPageUri = 'app/discussion-forum/add';
  static const String discussionDetailsPageId =
      '/app/discussion-forum/topic/:discussionId/:discussionName';
  static const String discussionDetailsPageUri =
      'app/discussion-forum/topic/:discussionId/:discussionName?page=home';
  static const String categoriesPageId = '/app/discussion-forum/categories';
  static const String categoriesPageUri =
      'app/discussion-forum/categories?page=home';
  static const String filterByCategoryPageId =
      '/app/discussion-forum/category/:categoryId';
  static const String filterByCategoryPageUri =
      'app/discussion-forum/category/:categoryId?page=home';
  static const String tagsPageId =
      '/app/discussion/discussion-forum/discussion-forum/tags/tag-discussions';
  static const String tagsPageUri =
      'app/discussion-forum/tags/tag-discussions?page=home&tagname=tags';
  static const String filterByTagsPageId =
      '/app/discussion-forum/all-discussions';
  static const String filterByTagsPageUri =
      'app/discussion-forum/all-discussions?page=home&tagname=:tagName';
  static const String myDiscussionsPageId =
      '/app/discussion-forum/my-discussion';
  static const String myDiscussionsPageUri =
      'app/discussion-forum/my-discussion?page=home';
  // Network hub
  static const String networkHomePageId = '/app/network-v2/home';
  static const String networkHomePageUri = 'app/network-v2/home';
  static const String myConnectionsPageId = '/app/network-v2/my-connection';
  static const String myConnectionsPageUri = 'app/network-v2/my-connection';
  static const String connectionRequestsPageId =
      '/app/network-v2/connection-requests';
  static const String connectionRequestsPageUri =
      'app/network-v2/connection-requests';
  static const String myMdoPageId = '/app/network-v2/my-mdo';
  static const String myMdoPageUri = 'app/network-v2/my-mdo';
  // Competency hub
  static const String competencyHomePageId = '/app/competencies/home';
  static const String competencyHomePageUri = 'app/competencies/home';
  static const String allCompetenciesPageId = '/app/competencies/all/list';
  static const String allCompetenciesPageUri = '/app/competencies/all/list';
  static const String browseByAllCompetenciesPageId =
      '/app/learn/browse-by/competency/all-competencies';
  static const String browseByAllCompetenciesPageUri =
      'app/learn/browse-by/competency/all-competencies';
  static const String browseByCompetencyCoursesPageId =
      '/app/learn/browse-by/competency/:competencyName';
  static const String browseByCompetencyCoursesPageUri =
      'app/learn/browse-by/competency/:competencyName';
  static const String browseByAllProviderPageId =
      '/app/learn/browse-by/provider/all-providers';
  static const String browseByAllProviderPageUri =
      'app/learn/browse-by/provider/all-providers';
  static const String browseByProviderCoursesPageId =
      '/app/learn/browse-by/provider/:providerName/all-CBP';
  static const String browseByProviderCoursesPageUri =
      'app/learn/browse-by/provider/:providerName/all-CBP';
  // Career hub
  static const String careerHomePageId = '/app/careers/home';
  static const String careerHomePageUri = 'app/careers/home';
  static const String careerDetailsPageId =
      '/app/careers/home/:topicId/:topicName';
  static const String careerDetailsPageUri =
      'app/careers/home/:topicId/:topicName';

  // Event hub
  static const String eventHomePageId = '/app/event-hub/app/event-hub/home';
  static const String eventHomePageUri = 'app/event-hub/home';
  static const String eventDetailsPageId =
      '/app/event-hub/app/event-hub/home/:eventId';
  static const String eventDetailsPageUri =
      'app/event-hub/app/event-hub/home/:eventId';
  // Profile
  static const String userProfilePageId = '/app/person-profile/:userId';
  static const String userProfilePageUri = 'app/person-profile/:userId';
  static const String myProfilePageId = '/app/person-profile/me';
  static const String myProfilePageUri = 'app/person-profile/me';
  static const String profileSettingsPageId = '/app/profile/settings';
  static const String profileSettingsPageUri = 'app/profile/settings';
  static const String userProfileDetailsPageId = '/app/user-profile/details';
  static const String userProfileDetailsPageUri = 'app/user-profile/details';
  // Search
  static const String globalSearchPageId = '/app/globalsearch';
  static const String globalSearchPageUri = 'app/globalsearch?q=network';
  // Interests
  static const String welcomePageId = '/app/profile-v3/welcome';
  static const String welcomePageUri = 'app/setup/welcome';
  static const String rolesPageId = '/app/profile-v3/roles';
  static const String rolesPageUri = 'app/setup/roles';
  static const String topicsPageId = '/app/profile-v3/topics';
  static const String topicsPageUri = 'app/setup/topics';
  static const String currentCompetenciesPageId =
      '/app/profile-v3/current-competencies';
  static const String currentCompetenciesPageUri =
      'app/setup/current-competencies';
  static const String desiredCompetenciesPageId =
      '/app/profile-v3/desired-competencies';
  static const String desiredCompetenciesPageUri =
      'app/setup/desired-competencies';
  static const String platformWalkThroughPageId =
      '/app/profile-v3/platform-walkthrough';
  static const String platformWalkThroughPageUri =
      'app/setup/platform-walkthrough';
}
