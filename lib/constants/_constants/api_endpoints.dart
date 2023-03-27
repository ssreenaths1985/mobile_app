import 'package:karmayogi_mobile/env/env.dart';

class ApiUrl {
  // Mocky
  // static const tempBaseUrl = 'https://run.mocky.io/v3/';

  static String baseUrl = Env.portalBaseUrl;
  static String fracBaseUrl = Env.fracBaseUrl;
  static String apiKey = Env.apiKey;

  // Login
  static String loginRedirectUrl = '$baseUrl/oauth2callback';
  // static const loginRedirectUrl = 'https://igot-stage.in/oauth2callback';

  static String parichayBaseUrl = Env.parichayBaseUrl;
  static String preProdBaseUrl = 'https://karmayogi.nic.in';
  static String revokeToken = '/pnv1/salt/api/oauth2/revoke';

  static String parichayAuthLoginUrl = '$parichayBaseUrl/pnv1/oauth2/authorize';
  static String parichayLoginRedirectUrl =
      '$baseUrl/apis/public/v8/parichay/callback';

  static String loginWebUrl = '$baseUrl/auth';
  static String signUpWebUrl = '$baseUrl/public/signup';
  static String loginShortUrl =
      '/auth/realms/sunbird/protocol/openid-connect/auth';
  static String loginUrl =
      '/auth/realms/sunbird/protocol/openid-connect/auth?redirect_uri=$loginRedirectUrl&response_type=code&scope=offline_access&client_id=android';
  static const keyCloakLogin =
      '/auth/realms/sunbird/protocol/openid-connect/token';
  static const keyCloakLogout =
      '/auth/realms/sunbird/protocol/openid-connect/logout';
  static const getParichayToken = '/pnv1/salt/api/oauth2/token';
  // pnv1/salt/api/oauth2/token'
  static const refreshToken = '/api/auth/v1/refresh/token';
  static const createNodeBBSession = '/api/discussion/user/v1/create';
  // static const basicUserInfo = '/api/user/v2/read/';
  static const basicUserInfo = '/api/user/v5/read/';
  static const getUserDetails = '/api/private/user/v1/search';
  static const getParichayUserInfo = '/pnv1/salt/api/oauth2/userdetails';
  static const updateLogin = '/api/user/v1/updateLogin';
  static const signUp = '/api/user/v1/ext/signup';

  // Not in use
  static const wToken = '/apis/proxies/v8/api/user/v2/read';

  // Discussion hub new
  static const trendingDiscussion = '/api/discussion/popular?page=';
  static const recentDiscussion = '/api/discussion/recent';
  static const trendingTags = '/api/discussion/tags';
  static const discussionDetail = '/api/discussion/topic/';
  static const categoryList = '/api/discussion/categories';
  static const myDiscussions = '/api/discussion/user/';
  static const filterDiscussionsByTag = '/api/discussion/tags/';
  static const courseDiscussions = '/api/discussion/forum/v2/read';
  static const courseDiscussionList = '/api/discussion/category/list';

  // Post APIs currently not working
  static const replyDiscussion = '/api/discussion/v2/topics/';
  static const saveDiscussion = '/api/discussion/v2/topics';
  static const deleteDiscussion = '/api/discussion/v2/topics/';
  static const vote = '/api/discussion/v2/posts/';
  static const savedPosts = '/api/discussion/user/';
  static const bookmark = '/api/discussion/v2/posts/';
  static const updatePost = '/api/discussion/v2/posts/';
  static const filterDiscussionsByCategory = '/api/discussion/category/';

  // APIs not provided yet
  static const getCareerOpenings = '/api/discussion/category/1';
  static const getCareers = '/api/nodebb/api/category/1';

  /// Network hub new
  static const getSuggestions = '/api/connections/profile/find/recommended';

  // Network hub

  static const getProfileDetails =
      '/apis/protected/v8/user/profileRegistry/getUserRegistryById';
  static const getProfileDetailsByUserId = '/api/user/v1/read/';
  static const updateProfileDetailsWithoutPatch = '/api/user/private/v1/update';
  static const updateProfileDetails = '/api/user/v1/extPatch';
  static const generateOTP = '/api/otp/v1/generate';
  static const verifyOTP = '/api/otp/v1/verify';
  static const getInReviewFields = '/api/workflow/getUserWFApplicationFields';
  // static const updateUserProfileDetails =
  //     '/apis/protected/v8/user/profileDetails/updateUser';
  static const getCurrentCourse =
      '/apis/protected/v8/content/lex_auth_013125450758234112286?hierarchyType=detail';
  static const getBadges = '/apis/protected/v8/user/badge';
  static const getNationalities = '/assets/static-data/nationality.json';
  static const getCuratedHomeConfig =
      '/assets/configurations/feature/curated-home.json';
  static const getLearnHubConfig = '/assets/configurations/page/learn.json';
  static const getHomeConfig = '/assets/configurations/page/home.json';
  static const getMasterCompetencies =
      '/assets/common/master-competencies.json';
  static const getProfileEditConfig =
      '/assets/configurations/feature/edit-profile.json';
  static const getLanguages = '/assets/static-data/languages.json';
  static const getProfilePageMeta =
      '/apis/protected/v8/user/profileRegistry/getProfilePageMeta';
  static const getDepartments = '/assets/static-data/govtOrg.json';
  static const getDegrees = '/assets/static-data/degrees.json';
  static const getIndustries = '/assets/static-data/industries.json';
  static const getDesignationsAndGradePay =
      '/assets/static-data/designation.json';
  static const getServicesAndCadre = '/assets/static-data/govtOrg.json';
  static const getBatchList = '/apis/proxies/v8/learner/course/v1/batch/list';
  static const autoEnrollBatch = '/api/v1/autoenrollment';
  static const getEnrollDetails = '/api/user/autoenrollment/';

  // Network hub
  static const peopleYouMayKnow = '/api/connections/profile/find/suggests';
  static const connectionRequest =
      '/api/connections/profile/fetch/requests/received';

  static const postConnectionReq = '/api/connections/add';
  static const getMyConnections = '/api/connections/profile/fetch/established';
  static const connectionRejectAccept = '/api/connections/update';
  static const fromMyMDO = '/api/connections/profile/find/recommended';
  static const getUsersById = '/api/user/v1/search';
  static const getUsersByText = '/api/user/v1/autocomplete/';
  static const getRequestedConnections =
      '/api/connections/profile/fetch/requested';

  // Notifications
  static const notifications =
      '/apis/protected/v8/user/notifications?classification=Information&size=10';
  static const notificationsCount =
      '/apis/protected/v8/user/iconBadge/unseenNotificationCount';
  static const markReadNotifications = '/apis/protected/v8/user/notifications';
  static const notificationPreferenceSettings =
      '/api/data/v1/system/settings/get/notificationPreference';
  static const userNotificationPreference =
      '/api/user/v1/notificationPreference';
  static const markReadNotification = '/apis/protected/v8/user/notifications/';

  // Knowledge Resources
  static const getKnowledgeResources =
      '/fracapis/frac/getAllNodes?type=KNOWLEDGERESOURCE&bookmarks=true';
  static const bookmarkKnowledgeResource = '/fracapis/frac/bookmarkDataNode';
  static const getKnowledgeResourcesPositions =
      '/fracapis/frac/getAllNodes?type=POSITION';
  static const knowledgeResourcesFilterByPosition =
      '/fracapis/frac/filterByMappings';

  // Learn
  static const getListOfCompetencies = '/fracapis/frac/searchNodes';
  static const getAllCompetencies = '/api/searchBy/competency';
  static const getCoursesByCompetencies = '/api/content/v1/search';
  static const getTrendingCourses = '/api/composite/v1/search';
  static const getCoursesByCollection = 'api/v8/action/content/v3/hierarchy/';
  static const getContinueLearningCourses =
      '/api/course/v1/user/enrollment/list/:wid?orgdetails=orgName,email&licenseDetails=name,description,url&fields=contentType,primaryCategory,topic,name,channel,mimeType,appIcon,gradeLevel,resourceType,identifier,medium,pkgVersion,board,subject,trackable,posterImage,duration,creatorLogo,license,version,versionKey&batchDetails=name,endDate,startDate,status,enrollmentType,createdBy,certificates';
  static const getCourseDetails = '/api/course/v1/hierarchy/';
  static const getCourseLearners = '/api/v2/resources/user/cohorts/activeusers';
  static const getCourseAuthors = '/api/v2/resources/user/cohorts/authors';
  static const getCourseProgress = '/apis/proxies/v8/read/content-progres/';
  static const setPdfCookie = '/apis/protected/v8/content/setCookie';
  static const getAllTopics = '/api/v1/catalog/';
  static const updateContentProgress = '/api/course/v1/content/state/update';
  static const readContentProgress = '/api/course/v1/content/state/read';
  static const getCourseCompletionCertificate =
      '/api/certreg/v2/certs/download/';
  static const getUserProgress = '/api/v1/batch/getUserProgress';
  static const getYourRating = '/api/ratings/v1/read/';
  static const getCourseReviewSummery = '/api/ratings/v1/summary/';
  static const postReview = '/api/ratings/v1/upsert';
  static const getCourseReview = '/api/ratings/v1/ratingLookUp';

  // Providers
  static const getListOfProviders = '/api/org/v1/search';
  static const getCoursesByProvider = '/api/composite/v1/search';
  static const getAllProviders = '/api/searchBy/provider';

  // telemetry
  static const getTelemetryUrl = '/api/data/v1/telemetry';
  static const getPublicTelemetryUrl = '/api/data/v1/public/telemetry';
  static const saveAssessment = '/api/v2/user/assessment/submit';

  // Socket connection
  static const socketUrl = 'http://40.113.200.227:4005/user';
  // static const vegaSocketUrl = 'https://vega-console.igot-dev.in/router';
  static String vegaSocketUrl = Env.vegaSocketUrl;
  // static const vegaSocketUrl = 'https://thor-console.tarento.com/router';

  // Competencies
  static const recommendedFromFrac = '/fracapis/frac/filterByMappings';
  static const recommendedFromWat = '/api/v2/workallocation/user/competencies/';
  static const allCompetencies = '/fracapis/frac/searchNodes';
  static const getLevelsForCompetency = '/fracapis/frac/getNodeById';
  static const getCompetencies = '/fracapis/frac/searchNodes';

  //Events
  static const getAllEvents = '/api/composite/v1/search';
  static const readEvent = '/api/event/v4/read/';

  //Registration
  static const getAllPosition = '/assets/configurations/site.config.json';
  static const getAllMinistries = '/api/org/v1/list/ministry';
  static const getAllStates = '/api/org/v1/list/state';
  static const register = '/api/user/registration/v1/register';
  static const registerParichayAccount = '/api/user/basicProfileUpdate';

  //contact
  static const contact = 'https://igot-stage.in/public/contact';

  //Landing page
  static const getLandingPageInfo =
      'https://igotkarmayogi.gov.in/configurations.json';
  static const getFeaturedCourses = '//api/course/v1/explore';
}
