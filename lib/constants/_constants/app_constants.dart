import 'package:karmayogi_mobile/env/env.dart';

const String APP_VERSION = '2.7.10';
const String APP_NAME = 'iGOT Karmayogi';
const String APP_ENVIRONMENT = Environment.sunbird;
const String TELEMETRY_ID = 'api.sunbird.telemetry';
const String DEFAULT_CHANNEL = 'igot';
// ignore: non_constant_identifier_names
String TELEMETRY_PDATA_ID = Env.telemetryPdataId;
const String TELEMETRY_PDATA_PID = 'karmayogi-mobile-android';
const String TELEMETRY_EVENT_VERSION = '3.0';
const String APP_DOWNLOAD_FOLDER = '/storage/emulated/0/Download';
const String PAGE_LOADER = 'assets/animations/karma_loader_latest.riv';
const String ASSESSMENT_FITB_QUESTION_INPUT =
    '<input style=\"border-style:none none solid none\" />';

// ignore: non_constant_identifier_names
String PARICHAY_CODE_VERIFIER = Env.parichayCodeVerifier;
// ignore: non_constant_identifier_names
String PARICHAY_CLIENT_ID = Env.parichayClientId;
// ignore: non_constant_identifier_names
String PARICHAY_CLIENT_SECRET = Env.parichayClientSecret;

// ignore: non_constant_identifier_names
String PARICHAY_KEYCLOAK_CLIENT_SECRET = Env.parichayKeycloakSecret;

// ignore: non_constant_identifier_names
String X_CHANNEL_ID = Env.xChannelId;

// ignore: non_constant_identifier_names
String SOURCE_NAME = Env.sourceName;

String mdoID;
String mdo;
bool isSPVAdmin = false;
bool isMDOAdmin = false;

class VegaConfiguration {
  static bool isEnabled = false;
}

class Client {
  static const String androidClientId = 'android';
  static const String parichayClientId = 'parichay-oAuth-mobile';
}

class Roles {
  static const String spv = 'SPV_ADMIN';
  static const String mdo = 'MDO_ADMIN';
}

class Environment {
  static const String eagle = 'eagle';
  static const String sunbird = 'sunbird';
  static const String dev = '.env.dev';
  static const String stage = '.env.stage';
  static const String preProd = '.env.preprod';
  static const String bm = '.env.bm';
  static const String prod = '.env.prod';
}

class ChartType {
  static const String profileViews = 'profileViews';
  static const String platformUsage = 'platformUsage';
}

class AppDatabase {
  static const String name = 'igot_karmayogi';
  static const String deletedNotificationsTable = 'deleted_notifications';
  static const String telemetryEventsTable = 'telemetry_events';
  static const String feedbackTable = 'user_feedback';
}

class AcademicDegree {
  static const String graduation = 'graduation';
  static const String postGraduation = 'postGraduation';
}

class DegreeType {
  static const String xStandard = 'X_STANDARD';
  static const String xiiStandard = 'XII_STANDARD';
  static const String graduate = 'GRADUATE';
  static const String postGraduate = 'POSTGRADUATE';
}

class NotificationType {
  static const String error = 'error';
  static const String success = 'success';
}

class EMimeTypes {
  static const String collection = 'application/vnd.ekstep.content-collection';
  static const String html = 'application/vnd.ekstep.html-archive';
  static const String ilp_fp = 'application/ilpfp';
  static const String iap = 'application/iap-assessment';
  static const String m4a = 'audio/m4a';
  static const String mp3 = 'audio/mpeg';
  static const String mp4 = 'video/mp4';
  static const String m3u8 = 'application/x-mpegURL';
  static const String interaction = 'video/interactive';
  static const String pdf = 'application/pdf';
  static const String quiz = 'application/quiz';
  static const String dragDrop = 'application/drag-drop';
  static const String htmlPicker = 'application/htmlpicker';
  static const String webModule = 'application/web-module';
  static const String webModuleExercise = 'application/web-module-exercise';
  static const String youtube = 'video/x-youtube';
  static const String handsOn = 'application/integrated-hands-on';
  static const String rdbmsHandsOn = 'application/rdbms';
  static const String classDiagram = 'application/class-diagram';
  static const String channel = 'application/channel';
  static const String collectionResource = 'resource/collection';
  // Added on UI Onl;
  static const String certification = 'application/certification';
  static const String playlist = 'application/playlist';
  static const String unknown = 'application/unknown';
  static const String externalLink = 'text/x-url';
  static const String youtubeLink = 'video/x-youtube';
  static const String assessment = 'application/json';
  static const String newAssessment = 'application/vnd.sunbird.questionset';
  static const String survey = 'application/survey';
}

class EDisplayContentTypes {
  static const String assessment = 'ASSESSMENT';
  static const String audio = 'AUDIO';
  static const String certification = 'CERTIFICATION';
  static const String channel = 'Channel';
  static const String classDiagram = 'CLASS_DIAGRAM';
  static const String course = 'COURSE';
  static const String dDefault = 'DEFAULT';
  static const String dragDrop = 'DRAG_DROP';
  static const String externalCertification = 'EXTERNAL_CERTIFICATION';
  static const String externalCourse = 'EXTERNAL_COURSE';
  static const String goals = 'GOALS';
  static const String handsOn = 'HANDS_ON';
  static const String iap = 'IAP';
  static const String instructorLed = 'INSTRUCTOR_LED';
  static const String interactiveVideo = 'INTERACTIVE_VIDEO';
  static const String knowledgeArtifact = 'KNOWLEDGE_ARTIFACT';
  static const String module = 'MODULE';
  static const String pdf = 'PDF';
  static const String html = 'HTML';
  static const String playlist = 'PLAYLIST';
  static const String program = 'PROGRAM';
  static const String quiz = 'QUIZ';
  static const String resource = 'RESOURCE';
  static const String rdbmsHands_on = 'RDBMS_HANDS_ON';
  static const String video = 'VIDEO';
  static const String webModule = 'WEB_MODULE';
  static const String webPage = 'WEB_PAGE';
  static const String youtube = 'YOUTUBE';
  static const String knowledgeBoard = 'Knowledge Board';
  static const String learningJourney = 'Learning Journeys';
}

class Azure {
  static const String host = 'https://karmayogi.nic.in/';
  static const String bucket = 'content-store';
}

// class SunbirdDev {
//   static const String host = 'https://igot.blob.core.windows.net/';
//   static const String bucket = 'content';
// }

// class SunbirdStage {
//   static const String host = 'https://igot-stage.in/assets/public/';
//   static const String bucket = 'content';
// }

// class SunbirdPreProd {
//   static const String host = 'https://static.karmayogiprod.nic.in/igot/';
//   static const String bucket = 'content';
// }

class QuestionTypes {
  static const String singleAnswer = 'singleAnswer';
  static const String multipleAnswer = 'multipleAnswer';
}

class AssessmentQuestionType {
  static const String radioType = 'mcq-sca';
  static const String checkBoxType = 'mcq-mca';
  static const String matchCase = 'mtf';
  static const String fitb = 'fitb';
}

class Vega {
  static const String userEmail = 'mahuli@varsha.com';
  static const String endpoint = 'Vega';
}

class IntentType {
  static const String direct = 'direct';
  static const String discussions = 'discussions';
  static const String competencyList = 'competencylist';
  static const String contact = 'contact';
  static const String course = 'course';
  static const String tags = 'tags';
  static const String learners = 'learners';
  static const String visualisation = 'visualisations';
}

class PrimaryCategory {
  static const String practiceAssessment = "Practice Question Set";
  static const String finalAssessment = "Course Assessment";
}
