import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import './../../../constants/index.dart';
import './../../../ui/pages/_pages/home_page.dart';
import './../../../ui/widgets/_home/home_silver_list.dart';
import './../../../ui/widgets/index.dart';
import './../../../ui/pages/_pages/text_search_results/text_search_page.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/homeScreen';
  final int index;

  HomeScreen({Key key, this.index}) : super(key: key);

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // print('${widget.index} is called...');
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
                                onTap: () async {
                                  String userId = await Telemetry.getUserId();
                                  await TelemetryDbHelper.triggerEvents(userId,
                                      forceTrigger: true);
                                  // Navigator.of(context).pop(true);
                                  try {
                                    SystemNavigator.pop();
                                  } catch (e) {
                                    // print(e);
                                    Navigator.of(context).pop(true);
                                  }
                                },
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
    return widget.index == 0
        ? WillPopScope(
            child: Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  HomeAppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Image.asset(
                                'assets/img/igot_icon.png',
                                width: 110,
                                // height: 28,
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 8.0, top: 5.5),
                            //   child: Text(
                            //     APP_NAME,
                            //     style: GoogleFonts.montserrat(
                            //       color: Colors.black87,
                            //       fontSize: 16.0,
                            //       fontWeight: FontWeight.w600,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: AppColors.greys60,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TextSearchPage()));
                              }),
                        ),
                      ],
                    ),
                  ),
                  HomeSilverList(
                    child: Container(
                      color: Color.fromRGBO(241, 244, 244, 1),
                      child: widget.index == 0
                          ? HomePage(index: widget.index)
                          : Center(),
                    ),
                  )
                ],
              ),
            ),
            onWillPop: _onBackPressed,
          )
        : Center();
  }
}
