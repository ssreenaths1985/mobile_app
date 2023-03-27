import 'package:flutter/material.dart';
import '../../../constants/index.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Row title;
  final AppBar appBar;
  final SliverAppBar silverAppBar;

  const HomeAppBar({Key key, this.title, this.appBar, this.silverAppBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.scaffoldBackground,
      // backgroundColor: Colors.pink,
      elevation: 0,
      title: title,
      floating: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
