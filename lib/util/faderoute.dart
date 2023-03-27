import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page, String routeName})
      : super(
        settings: RouteSettings(name: routeName),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return page;
        }, transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return new SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}
