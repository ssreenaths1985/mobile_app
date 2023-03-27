import 'package:flutter/material.dart';
import '../pages/_pages/ai_assistant_page.dart';
import './../../ui/screens/index.dart';

class CustomBottomNavigation {
  final Widget page;
  final String title;
  final Icon icon;
  final String svgIcon;
  final String unselectedSvgIcon;
  final int index;

  CustomBottomNavigation(
      {this.page,
      this.title,
      this.icon,
      this.svgIcon,
      this.unselectedSvgIcon,
      this.index});

  static List<CustomBottomNavigation> get items => [
        CustomBottomNavigation(
            page: HomeScreen(),
            title: 'Home',
            icon: Icon(
              Icons.home,
            ),
            svgIcon: 'assets/img/home_blue.svg',
            unselectedSvgIcon: 'assets/img/home.svg',
            index: 0),
        CustomBottomNavigation(
            page: HubScreen(),
            title: 'Explore',
            icon: Icon(
              Icons.apps,
            ),
            svgIcon: 'assets/img/grid_blue.svg',
            unselectedSvgIcon: 'assets/img/grid.svg',
            index: 1),
        CustomBottomNavigation(
            // page: AssistantScreen(),
            page: AiAssistantPage(
              searchKeyword: "...",
            ),
            title: 'Vega',
            icon: Icon(
              Icons.track_changes,
            ),
            svgIcon: 'assets/img/karma_yogi.svg',
            unselectedSvgIcon: 'assets/img/karma_yogi_grey.svg',
            index: 2),
        CustomBottomNavigation(
            page: NotificationScreen(),
            title: 'Notifications',
            icon: Icon(
              Icons.notifications,
            ),
            svgIcon: 'assets/img/notifications_blue.svg',
            unselectedSvgIcon: 'assets/img/notifications.svg',
            index: 3),
        CustomBottomNavigation(
            page: ProfileScreen(),
            title: 'Profile',
            icon: Icon(
              Icons.account_circle,
            ),
            svgIcon: 'assets/img/account_box_blue.svg',
            unselectedSvgIcon: 'assets/img/account_box.svg',
            index: 4)
      ];

  static List<CustomBottomNavigation> get itemsWithVegaDisabled => [
        CustomBottomNavigation(
            page: HomeScreen(),
            title: 'Home',
            icon: Icon(
              Icons.home,
            ),
            svgIcon: 'assets/img/home_blue.svg',
            unselectedSvgIcon: 'assets/img/home.svg',
            index: 0),
        CustomBottomNavigation(
            page: HubScreen(),
            title: 'Explore',
            icon: Icon(
              Icons.apps,
            ),
            svgIcon: 'assets/img/grid_blue.svg',
            unselectedSvgIcon: 'assets/img/grid.svg',
            index: 1),
        CustomBottomNavigation(
            page: ProfileScreen(),
            title: 'Profile',
            icon: Icon(
              Icons.account_circle,
            ),
            svgIcon: 'assets/img/account_box_blue.svg',
            unselectedSvgIcon: 'assets/img/account_box.svg',
            index: 2)
      ];
}
