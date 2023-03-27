import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/feedback/models/information_card_model.dart';

class FeedbackDatabase {
  static const String name = 'igot_karmayogi';
  static const String userFeedbackTable = 'user_feedback';
}

class FeedbackColors {
  static const Color background = Colors.white;
  static const Color black87 = Color.fromRGBO(0, 0, 0, 0.87);
  static const Color black60 = Color.fromRGBO(0, 0, 0, 0.60);
  static const Color black40 = Color.fromRGBO(0, 0, 0, 0.40);
  static const Color black16 = Color.fromRGBO(0, 0, 0, 0.16);
  static const Color black08 = Color.fromRGBO(0, 0, 0, 0.08);
  static const Color black04 = Color.fromRGBO(0, 0, 0, 0.04);
  static const Color textFieldHint = Color.fromRGBO(0, 0, 0, 0.40);
  static const Color textFieldBorder = Color.fromRGBO(0, 0, 0, 0.16);
  static const Color textFieldDescText = Color.fromRGBO(0, 0, 0, 0.60);
  static const Color ratedColor = Color.fromRGBO(246, 153, 83, 1);
  static const Color unRatedColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color customBlue = Color.fromRGBO(39, 117, 184, 1);
  static const Color lightGrey = Color.fromRGBO(245, 245, 245, 1);
  static const Color primaryBlue = Color.fromRGBO(39, 117, 184, 1);
  static const Color primaryBlueBg = Color.fromRGBO(39, 117, 184, 0.1);
  static const Color negativeLight = Color.fromRGBO(209, 57, 36, 1);
  static const Color positiveLight = Color.fromRGBO(29, 137, 35, 1);
  static const Color negativeLightBg = Color.fromRGBO(209, 57, 36, 0.1);
  static const Color positiveLightBg = Color.fromRGBO(29, 137, 35, 0.1);
  static const Color avatarRed = Color.fromRGBO(196, 84, 78, 1);
  static const Color blueCard = Color.fromRGBO(2, 75, 163, 1);
  static const Color avatarGreen = Color.fromRGBO(78, 158, 135, 1);
  static const Color ghostWhite = Color.fromRGBO(248, 244, 249, 1);
}

class FeedbackSmileys {
  static const String oneStar = 'assets/smileys/Smiley_welcome_1.svg';
  static const String twoStar = 'assets/smileys/Smiley_welcome_2.svg';
  static const String threeStar = 'assets/smileys/Smiley_welcome_3.svg';
  static const String fourStar = 'assets/smileys/Smiley_welcome_4.svg';
  static const String fiveStar = 'assets/smileys/Smiley_welcome_5.svg';
}

class FeedbackApiEndpoint {
  static const String baseUrl = 'https://rain.tarento.com';
  static const String getSurveyDetails = '/api/forms/getFormById?id=';
  static const String submitSurvey = '/api/forms/saveFormSubmit';
  static const String submitContentSurvey = '/api/forms/v1/saveFormSubmit';
  static const String getSubmittedFeedback = '/api/forms/getAllApplications';
}

class FeedbackPageRoute {
  static const String microSurveysPage = '/microSurveysPage';
  static const String microSurveyPage = '/microSurveyPage';
  static const String surveyDetails = '/surveyDetails';
  static const String surveyResults = '/surveyResults';
}

class QuestionType {
  static const String radio = 'radio';
  static const String checkbox = 'checkbox';
  static const String rating = 'rating';
  static const String text = 'text';
  static const String email = 'email';
  static const String textarea = 'textarea';
  static const String numeric = 'numeric';
  static const String date = 'date';
  static const String boolean = 'boolean';
  static const String heading = 'heading';
}

class MicroSurveyType {
  static const String microSurveyType1 = 'Micro survey scenario 1';
  static const String microSurveyType2 = 'Micro survey scenario 2';
  static const String microSurveyType3 = 'Micro survey scenario 3';
}

const MICRO_SURVEY_ID = '1617090681344';
// const MICRO_SURVEY_ID = '1623155373000';

const SCENARIO_1_SUMMARY = const [
  InformationCardModel(
      scenarioNumber: 1,
      icon: Icons.timer,
      information: 'Total 5 mins',
      iconColor: AppColors.primaryThree),
  InformationCardModel(
      scenarioNumber: 2,
      icon: Icons.list,
      information: '3 questions',
      iconColor: AppColors.primaryThree),
  // InformationCardModel(
  //     scenarioNumber: 3,
  //     icon: Icons.replay,
  //     information: 'Retake available after 1 month',
  //     iconColor: AppColors.primaryThree)
];

const SCENARIO_2_SUMMARY = const [
  InformationCardModel(
      scenarioNumber: 2,
      icon: Icons.timer,
      information: '60 seconds per question',
      iconColor: AppColors.primaryThree),
  InformationCardModel(
      scenarioNumber: 2,
      icon: Icons.list,
      information: '3 questions',
      iconColor: AppColors.primaryThree),
  InformationCardModel(
      scenarioNumber: 2,
      icon: Icons.replay,
      information: 'Retake avaialble after 1 month',
      iconColor: AppColors.primaryThree)
];

const SCENARIO_3_SUMMARY = const [
  InformationCardModel(
      scenarioNumber: 3,
      icon: Icons.timer,
      information: 'No time limit',
      iconColor: AppColors.primaryThree),
  InformationCardModel(
      scenarioNumber: 3,
      icon: Icons.list,
      information: '3 questions',
      iconColor: AppColors.primaryThree),
  InformationCardModel(
      scenarioNumber: 3,
      icon: Icons.timer,
      information: 'Unlimited takes allowed',
      iconColor: AppColors.primaryThree)
];

const SCENARIO_1_INFO = const [
  // InformationCardModel(
  //     scenarioNumber: 1,
  //     icon: Icons.info,
  //     information: 'No negative mark',
  //     iconColor: AppColors.greys60),
  InformationCardModel(
      scenarioNumber: 1,
      icon: Icons.info,
      information: 'If time runs out answers will be autosubmitted',
      iconColor: AppColors.greys60),
  InformationCardModel(
      scenarioNumber: 1,
      icon: Icons.info,
      information: 'Skipped questions can be attempted again',
      iconColor: AppColors.greys60)
];

const SCENARIO_2_INFO = const [
  InformationCardModel(
      scenarioNumber: 2,
      icon: Icons.info,
      information: 'No negative mark',
      iconColor: AppColors.greys60),
  InformationCardModel(
      scenarioNumber: 2,
      icon: Icons.info,
      information: 'If time runs out answers will be autosubmitted',
      iconColor: AppColors.greys60),
  InformationCardModel(
      scenarioNumber: 2,
      icon: Icons.info,
      information: 'Unanswered will be considered as incorrect',
      iconColor: AppColors.greys60)
];

const SCENARIO_3_INFO = const [
  InformationCardModel(
      scenarioNumber: 3,
      icon: Icons.info,
      information: 'The scores will not be stored or shared',
      iconColor: AppColors.greys60)
];
