import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants/index.dart';
import './../../ui/widgets/index.dart';

class CustomDrawer extends StatelessWidget {
  final String title;

  CustomDrawer({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Container(
          //   height: 150.0,
          //   child: DrawerHeader(
          //     margin: EdgeInsets.only(top: 20.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.all(5.0),
          //           child: Text(
          //             'Garima Jain',
          //             style: GoogleFonts.lato(
          //               color: Colors.black87,
          //               fontSize: 16.0,
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.all(5.0),
          //           child: Text(
          //             'View profile',
          //             style: GoogleFonts.lato(
          //               color: Colors.lightBlue[400],
          //               fontWeight: FontWeight.w700,
          //               fontSize: 14.0,
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //     decoration: BoxDecoration(
          //       color: Colors.grey[200],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(22.0, 15.0, 22.0, 5.0),
          //   child: Text(
          //     'Hubs',
          //     style: GoogleFonts.lato(
          //         color: Colors.black54,
          //         fontSize: 12.0,
          //         fontWeight: FontWeight.normal),
          //   ),
          // ),
          InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new CustomTabs(
                      customIndex: 0,
                    ))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 30.0, 22.0, 1.0),
              child: ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 45,
                  child: Image.asset(
                    'assets/img/igot_icon.png',
                  ),
                ),
                title: Text(
                  'Karmayogi',
                  style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.pushNamed(context, AppUrl.discussPage),
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 1.0, 22.0, 1.0),
              child: ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 45,
                  child: Icon(
                    Icons.chat_bubble,
                    color: Color.fromRGBO(0, 116, 182, 1),
                  ),
                ),
                title: Text(
                  'Discuss',
                  style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.pushNamed(context, AppUrl.networkHomePage),
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 1.0, 22.0, 1.0),
              child: ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 45,
                  child: Icon(
                    Icons.supervisor_account,
                    color: Color.fromRGBO(0, 116, 182, 1),
                  ),
                ),
                title: Text(
                  'Network',
                  style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.pushNamed(context, AppUrl.learnPage),
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 1.0, 22.0, 1.0),
              child: ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 45,
                  child: Icon(
                    Icons.school,
                    color: Color.fromRGBO(0, 116, 182, 1),
                  ),
                ),
                title: Text(
                  'Learn',
                  style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.pushNamed(context, AppUrl.careersPage),
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 1.0, 22.0, 1.0),
              child: ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 45,
                  child: Icon(
                    Icons.work,
                    color: Color.fromRGBO(0, 116, 182, 1),
                  ),
                ),
                title: Text(
                  'Careers',
                  style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0),
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.pushNamed(context, AppUrl.competenciesPage),
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 1.0, 22.0, 1.0),
              child: ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 45,
                  child: Icon(
                    Icons.extension,
                    color: Color.fromRGBO(0, 116, 182, 1),
                  ),
                ),
                title: Text(
                  'Competencies',
                  style: GoogleFonts.lato(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
