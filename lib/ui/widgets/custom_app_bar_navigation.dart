import 'package:flutter/material.dart';
import '../../constants/index.dart';

class CustomAppBarNavigation extends StatelessWidget
    implements PreferredSizeWidget {
  final Row title;
  final Widget tabBar;
  final AppBar appBar;

  const CustomAppBarNavigation({Key key, this.title, this.appBar, this.tabBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.greys60),
      backgroundColor: Colors.white,
      title: title,
      bottom: tabBar,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
