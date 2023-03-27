import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/constants/index.dart';
// import 'package:karmayogi_mobile/env/env.dart';
// import '../../feedback/constants.dart';
import './../../constants/_constants/app_routes.dart';
import '../../models/index.dart';
import './../../localization/index.dart';

const HUBS = const [
  Hub(
      id: 1,
      title: EnglishLang.learn,
      description: EnglishLang.learnSubtitle,
      icon: Icons.school_rounded,
      iconColor: Color.fromRGBO(0, 116, 182, 1),
      comingSoon: false,
      url: AppUrl.learningHub,
      svgIcon: 'assets/img/Learn.svg',
      svg: true),
  Hub(
      id: 2,
      title: EnglishLang.discuss,
      description: EnglishLang.discussSubtitle,
      icon: Icons.forum,
      iconColor: Color.fromRGBO(0, 116, 182, 1),
      comingSoon: false,
      url: AppUrl.discussionHub,
      svgIcon: 'assets/img/Discuss.svg',
      svg: true),
  Hub(
      id: 3,
      title: EnglishLang.network,
      description: EnglishLang.networkSubtitle,
      icon: Icons.supervisor_account,
      iconColor: Color.fromRGBO(0, 116, 182, 1),
      comingSoon: false,
      url: AppUrl.networkHub,
      svgIcon: 'assets/img/Network.svg',
      svg: true

      // url: AppUrl.comingSoonPage,
      ),
  Hub(
      id: 4,
      title: EnglishLang.careers,
      description: EnglishLang.careersSubtitle,
      icon: Icons.business_center_rounded,
      iconColor: Color.fromRGBO(0, 116, 182, 1),
      comingSoon: false,
      url: AppUrl.careersHub,
      // url: AppUrl.comingSoonPage,
      svgIcon: 'assets/img/Careers.svg',
      svg: true),
  Hub(
      id: 5,
      title: EnglishLang.competencies,
      description: EnglishLang.competenciesSubtitle,
      icon: Icons.extension_rounded,
      iconColor: Color.fromRGBO(0, 116, 182, 1),
      comingSoon: false,
      // url: AppUrl.competenciesPage,
      url: AppUrl.competencyHub,
      svgIcon: 'assets/img/competencies.svg',
      svg: true),
  Hub(
      id: 6,
      title: EnglishLang.events,
      description: EnglishLang.eventsSubtitle,
      icon: Icons.extension_rounded,
      iconColor: Color.fromRGBO(0, 116, 182, 1),
      comingSoon: false,
      // url: AppUrl.competenciesPage,
      url: AppUrl.eventsHub,
      svgIcon: 'assets/img/events.svg',
      svg: true),
  // Hub(
  //   id: 6,
  //   title: 'My Profile',
  //   description: 'Discuss',
  //   icon: Icons.face,
  //   iconColor: Color.fromRGBO(0, 116, 182, 1),
  //   url: '/profilePage',
  // ),
];

const DO_MORE = const [
  Hub(
      id: 1,
      title: EnglishLang.knowledgeResources,
      description: EnglishLang.knowledgeResourcesSubtitle,
      icon: Icons.menu_book,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      comingSoon: false,
      url: AppUrl.knowledgeResourcesPage,
      svgIcon: 'assets/img/Discuss.svg',
      svg: false),
  // Hub(
  //     id: 2,
  //     title: EnglishLang.dashboard,
  //     description: EnglishLang.dashboardSubtitle,
  //     icon: Icons.bar_chart_outlined,
  //     iconColor: Color.fromRGBO(0, 0, 0, 0.6),
  //     comingSoon: false,
  //     url: AppUrl.dashboardPage,
  //     svgIcon: 'assets/img/Discuss.svg',
  //     svg: false),
  // Hub(
  //     id: 3,
  //     title: EnglishLang.microSurveys,
  //     description: EnglishLang.microSurveysSubtitle,
  //     icon: Icons.book,
  //     iconColor: Color.fromRGBO(0, 0, 0, 0.6),
  //     comingSoon: false,
  //     url: FeedbackPageRoute.surveyDetails,
  //     svgIcon: 'assets/img/Discuss.svg',
  //     svg: false
  //     // url: FeedbackPageRoute.surveyDetails,
  //     ),
  Hub(
      id: 2,
      title: EnglishLang.interests,
      description: EnglishLang.interestsSubtitle,
      icon: Icons.thumb_up,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      comingSoon: false,
      url: AppUrl.interestsPage,
      svgIcon: 'assets/img/Discuss.svg',
      svg: false),
  Hub(
      id: 3,
      title: EnglishLang.settings,
      description: EnglishLang.settingsSubtitle,
      icon: Icons.settings,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      comingSoon: false,
      url: AppUrl.settingsPage,
      svgIcon: 'assets/img/Discuss.svg',
      svg: false),
];

// ignore: non_constant_identifier_names
final EXTERNAL_LINKS = [
  // Hub(
  //   id: 1,
  //   title: EnglishLang.fracDictionary,
  //   description: EnglishLang.fracDictionarySubtitle,
  //   icon: 'assets/img/igot_icon.png',
  //   iconColor: Color.fromRGBO(246, 153, 83, 1),
  //   url: Env.fracDictionaryUrl,
  // ),
  Hub(
      id: 1,
      title: EnglishLang.karmayogiWebPortal,
      description: EnglishLang.karmayogiWebPortalSubtitle,
      icon: 'assets/img/igot_icon.png',
      iconColor: Color.fromRGBO(246, 153, 83, 1),
      url: AppUrl.webAppUrl),
  // Hub(
  //   id: 1,
  //   title: 'Give feedback',
  //   description: 'Responsive web version of Karmayogi Bharat.',
  //   icon: 'assets/img/round_feedback.png',
  //   iconColor: Color.fromRGBO(246, 153, 83, 1),
  //   url: '',
  // ),
];

const DASHBOARD_HUBS = const [
  Hub(
    id: 1,
    title: EnglishLang.discussions,
    description: '',
    icon: Icons.forum,
    iconColor: Color.fromRGBO(0, 0, 0, 0.6),
  ),
  Hub(
    id: 2,
    title: EnglishLang.connections,
    description: '',
    icon: Icons.supervisor_account,
    iconColor: Color.fromRGBO(0, 0, 0, 0.6),
  ),
  Hub(
    id: 2,
    title: EnglishLang.karmaPoints,
    description: '',
    icon: Icons.history_rounded,
    iconColor: Color.fromRGBO(0, 0, 0, 0.6),
  ),
];

const AT_A_GLANCE = const [
  Hub(
      id: 1,
      title: EnglishLang.courses,
      description: '',
      icon: null,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      points: 14,
      svgIcon: 'assets/img/video.svg'),
  Hub(
      id: 2,
      title: EnglishLang.discussions,
      description: '',
      icon: null,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      points: 111,
      svgIcon: 'assets/img/Discuss.svg'),
  Hub(
      id: 3,
      title: EnglishLang.competencies,
      description: '',
      icon: null,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      points: 25,
      svgIcon: 'assets/img/competencies.svg'),
  Hub(
      id: 4,
      title: EnglishLang.connections,
      description: '',
      icon: null,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      points: 23,
      svgIcon: 'assets/img/Network.svg'),
  Hub(
      id: 5,
      title: EnglishLang.coinsSpent,
      description: '',
      icon: null,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      points: 540,
      svgIcon: 'assets/img/Coin.svg'),
  Hub(
      id: 6,
      title: EnglishLang.karmaEarned,
      description: '',
      icon: null,
      iconColor: Color.fromRGBO(0, 0, 0, 0.6),
      points: 48,
      svgIcon: 'assets/img/Karma.svg'),
];
