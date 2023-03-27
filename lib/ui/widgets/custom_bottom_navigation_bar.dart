import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants/index.dart';
import './../../ui/widgets/index.dart';
import './../../ui/screens/index.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int customIndex;
  final String token;

  CustomBottomNavigationBar({Key key, this.customIndex, this.token})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex;

  // GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (widget.customIndex > 0) {
      setState(() {
        _currentIndex = widget.customIndex;
      });
    } else {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Page content
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        duration: Duration(milliseconds: 500),
        child: IndexedStack(
          index: _currentIndex,
          key: ValueKey<int>(_currentIndex),
          children: [
            for (final tabItem in CustomBottomNavigation.items)
              tabItem.index == 0
                  ? HomeScreen(
                      index: _currentIndex,
                    )
                  : tabItem.index == 1
                      ? HubScreen(index: _currentIndex)
                      : tabItem.index == 2
                          ? AssistantScreen(index: _currentIndex)
                          : tabItem.index == 3
                              ? NotificationScreen(index: _currentIndex)
                              : tabItem.index == 4
                                  ? ProfileScreen(index: _currentIndex)
                                  : Center(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) => setState(() => _currentIndex = index),
          selectedFontSize: 10.0,
          selectedItemColor: AppColors.primaryThree,
          selectedLabelStyle: GoogleFonts.lato(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: GoogleFonts.lato(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          unselectedItemColor: AppColors.greys60,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            for (final tabItem in CustomBottomNavigation.items)
              BottomNavigationBarItem(
                icon: tabItem.icon,
                label: tabItem.title,
              )
          ],
          currentIndex: _currentIndex),
    );
  }
}
