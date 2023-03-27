import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../ui/pages/index.dart';
import './../../../ui/widgets/index.dart';

class NotificationScreen extends StatefulWidget {
  static const route = AppUrl.notificationsPage;
  final ValueChanged<bool> updateNotificationsCount;
  final int index;

  NotificationScreen({Key key, this.updateNotificationsCount, this.index})
      : super(key: key);

  @override
  NotificationScreenState createState() {
    return NotificationScreenState();
  }
}

class NotificationScreenState extends State<NotificationScreen> {
  void callParentMethod(bool status) {
    widget.updateNotificationsCount(true);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => Stack(
              children: [
                Positioned(
                    child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      height: 195.0,
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 15),
                                child: Text(
                                  'Do you want to exit the application?',
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(true),
                                child: roundedButton('Yes, exit', Colors.white,
                                    AppColors.primaryThree),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 15),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(false),
                                child: roundedButton('No, take me back',
                                    AppColors.primaryThree, Colors.white),
                              ),
                            ),
                          ])),
                ))
              ],
            ));
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        border: bgColor == Colors.white
            ? Border.all(color: AppColors.grey40)
            : Border.all(color: bgColor),
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.montserrat(
            decoration: TextDecoration.none,
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
    return loginBtn;
  }

  @override
  Widget build(BuildContext context) {
    return widget.index == 3
        ? WillPopScope(
            child: Scaffold(
              // App bar
              appBar: CustomAppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 4.0),
                      child: Text(
                        'Notifications',
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: AppColors.greys60,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextSearchPage()));
                        }),
                  ],
                ),
                appBar: AppBar(),
              ),

              // // Drawer
              // drawer: CustomDrawer(),

              // Content of the screen
              body: ComingSoon(
                isBottomBarItem: true,
              ),
            ),
            onWillPop: _onBackPressed)
        : Center();
  }
}
