import 'package:flutter/material.dart';
import './../../../constants/_constants/color_constants.dart';

class SilverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SilverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
        child: _tabBar,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: AppColors.grey08,
            blurRadius: 6.0,
            spreadRadius: 0,
            offset: Offset(
              3,
              3,
            ),
          ),
        ]));
  }

  @override
  bool shouldRebuild(SilverAppBarDelegate oldDelegate) {
    return false;
  }
}
