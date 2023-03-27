import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Row title;
  final Widget child;
  final AppBar appBar;

  const CustomAppBar({Key key, this.title, this.child, this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: title,
      leading: child,
      titleSpacing: 0.0,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
