import 'package:karmayogi_mobile/models/_models/vega_help_model.dart';

const VEGA_HELP_ITEMS_SPV = const [
  VegaHelpItem(
      heading: "Leaderboard",
      description: "Get leaderboards across the platform",
      intents: [
        "Top courses by course completion",
        "Top courses by user ratings",
        "Top MDOs by live courses",
        "Top MDOs by users onboard",
        "Top MDOs by course completions",
        "CBP provider leaderboard",
        "Top 10 posts"
      ]),
  VegaHelpItem(
      heading: "User engagement",
      description: "Get user engagement insights",
      intents: [
        "User flow by hubs",
        "Average time spent during each login",
        "Average time spent by each user"
        // "Average time spent daily",
        // "Average time spent weekly",
        // "Average time spent monthly",
      ]),
  VegaHelpItem(
      heading: "Overview",
      description: "Get overview insights",
      intents: [
        "Total courses added",
        "Total courses started",
        "Total courses completed",
        "Total users onboard",
        "Total mdos onboard"
      ]),
  VegaHelpItem(
      heading: "Course overview",
      description: "Get insights for course by status",
      intents: ["Courses Live", "Courses in draft", "Courses under review"]),
  VegaHelpItem(
      heading: "Connections",
      description: "Get connection details",
      intents: ["My connections", "Connection requests"]),
];

const VEGA_HELP_ITEMS_MDO = const [
  VegaHelpItem(
      heading: "Leaderboard",
      description: "Get leaderboards across the platform",
      intents: [
        "Top courses by course completion",
        "Top courses by user ratings",
        "Top MDOs by live courses",
        "Top MDOs by users onboard",
        "Top MDOs by course completions",
        "CBP provider leaderboard",
        "Top 10 posts",
        "Top performers of my mdo",
        "Top courses of my mdo"
      ]),
  VegaHelpItem(
      heading: "User engagement",
      description: "Get user engagement insights",
      intents: [
        "User flow by hubs",
        "Average time spent during each login",
        "Average time spent by each user"
        // "Average time spent daily",
        // "Average time spent weekly",
        // "Average time spent monthly",
      ]),
  VegaHelpItem(
      heading: "Overview",
      description: "Get overview insights",
      intents: [
        "Total courses added",
        "Total courses started",
        "Total courses completed",
        "Total users onboard",
        "Total mdos onboard"
      ]),
  VegaHelpItem(
      heading: "Course overview",
      description: "Get insights for course by status",
      intents: ["Courses Live", "Courses in draft", "Courses under review"]),
  VegaHelpItem(
      heading: "MDO ranks",
      description: "Get MDO position by factors",
      intents: [
        "My rank in live courses",
        "My rank in course completions",
        "My rank in users onboard"
      ]),
  VegaHelpItem(
      heading: "Connections",
      description: "Get connection details",
      intents: ["My connections", "Connection requests"]),
];
