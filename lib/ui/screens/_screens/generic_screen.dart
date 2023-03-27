import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../ui/widgets/index.dart';

class GenericScreen extends StatefulWidget {
  static const route = '/genericPages';

  final Widget pageContent;
  final String pageTitle;
  final Icon pageIcon;

  const GenericScreen(
      {Key key, this.pageContent, this.pageTitle, this.pageIcon})
      : super(key: key);

  @override
  _GenericScreenState createState() => _GenericScreenState();
}

class _GenericScreenState extends State<GenericScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex;
  TabController _controller;
  // GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(length: CustomBottomNavigation.items.length, vsync: this);
  }

  _navigateUser() {
    switch (_currentIndex) {
      case 0:
        return Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new CustomTabs(
            customIndex: 0,
          ),
        ));

      case 1:
        return Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new CustomTabs(
            customIndex: 1,
          ),
        ));

      case 2:
        return Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new CustomTabs(
            customIndex: 2,
          ),
        ));

      case 3:
        return Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new CustomTabs(
            customIndex: 3,
          ),
        ));

      default:
        return Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new CustomTabs(
            customIndex: 0,
          ),
        ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: CustomAppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.pageIcon,
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 3.0),
              child: Text(
                widget.pageTitle,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        child: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
            child: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.grey[600],
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        appBar: AppBar(),
      ),

      // Drawer
      drawer: CustomDrawer(),

      body: Container(
        color: Color.fromRGBO(241, 244, 244, 1),
        child: widget.pageContent,
      ),
      bottomNavigationBar: DefaultTabController(
        length: CustomBottomNavigation.items.length,
        child: TabBar(
          indicator: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(0, 116, 182, 1),
                width: 2.0,
              ),
            ),
          ),
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.only(top: 0.0),
          unselectedLabelColor: Colors.black45,
          labelColor: Color.fromRGBO(0, 116, 182, 1),
          labelStyle: GoogleFonts.lato(
            fontSize: 10.0,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.lato(
            fontSize: 10.0,
            fontWeight: FontWeight.normal,
          ),
          onTap: (int index) =>
              {setState(() => _currentIndex = index), _navigateUser()},
          tabs: [
            for (final tabItem in CustomBottomNavigation.items)
              SizedBox(
                height: 64.0,
                child: Tab(
                  iconMargin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
                  text: tabItem.title,
                  icon: tabItem.icon,
                ),
              ),
          ],
          controller: _controller,
        ),
      ),
    );
  }
}
