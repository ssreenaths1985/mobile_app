import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/_models/profile_model.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:karmayogi_mobile/services/_services/local_notification_service.dart';
// import 'package:karmayogi_mobile/util/speech_recognizer.dart';
// import 'package:karmayogi_mobile/ui/pages/index.dart';
// import 'package:karmayogi_mobile/ui/pages/_pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:upgrader/upgrader.dart';
// import '../../respositories/_respositories/login_respository.dart';
import './../../ui/pages/_pages/ai_assistant_page.dart';
import './../../ui/screens/index.dart';
import './../../ui/widgets/index.dart';
// import './../../util/speech_recognizer.dart';
import './../../respositories/_respositories/notification_repository.dart';
import './../../constants/index.dart';
// import './../../util/telemetry.dart';
// import 'dart:developer' as developer;

class CustomTabs extends StatefulWidget {
  final int customIndex;
  final String token;

  CustomTabs({Key key, this.customIndex, this.token}) : super(key: key);

  @override
  _CustomTabsState createState() => _CustomTabsState();

  static void setTabItem(BuildContext context) {
    _CustomTabsState state =
        context.findAncestorStateOfType<_CustomTabsState>();
    state?.setTabItems();
  }
}

class _CustomTabsState extends State<CustomTabs>
    with SingleTickerProviderStateMixin {
  StreamSubscription _connectivitySubscription;
  bool _isDeviceConnected = false;
  bool _isSetAlert = false;

  int _currentIndex;
  int _unSeenNotificationsCount = 0;
  TabController _controller;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<Profile> _profileDetails;
  bool _pageInitialized = false;
  // SpeechRecognizer _speechRecognizer;

  @override
  void initState() {
    super.initState();
    // Provider.of<LoginRespository>(context, listen: false).clearData();
    _doActionOnNotification();

    _getConnectivity();
    _getUnSeenNotificationsCount();
  }

  setTabItems() {
    _controller = TabController(
        length: !VegaConfiguration.isEnabled
            ? CustomBottomNavigation.itemsWithVegaDisabled.length
            : CustomBottomNavigation.items.length,
        vsync: this,
        initialIndex: widget.customIndex > 0 ? widget.customIndex : 0);
    if (widget.customIndex > 0) {
      setState(() {
        _currentIndex = widget.customIndex;
      });
    } else {
      setState(() {
        _currentIndex = 0;
      });
    }
    _controller.addListener(() {
      _getUnSeenNotificationsCount();
    });
  }

  @override
  void didChangeDependencies() {
    _getProfileDetails().then((data) => setTabItems());
    super.didChangeDependencies();
  }

  Future<dynamic> _getProfileDetails() async {
    if (!_pageInitialized) {
      //Should be uncomment when vega go to the prod 100-102
      // _profileDetails =
      //     await Provider.of<ProfileRepository>(context, listen: false)
      //         .getProfileDetailsById('');
      setState(() {
        //Should be uncomment when vega go to the prod 105-121
        // if (_profileDetails.first.roles.contains(Roles.spv) ||
        //     _profileDetails.first.roles.contains(Roles.mdo)) {
        //   VegaConfiguration.isEnabled = true;
        //   if (_profileDetails.first.roles.contains(Roles.mdo)) {
        //     mdoID = _profileDetails.first.rawDetails['rootOrgId'];
        //     mdo = _profileDetails.first.department;
        //     isMDOAdmin = true;
        //     isSPVAdmin = false;
        //   } else {
        //     mdoID = '';
        //     mdo = '';
        //     isSPVAdmin = true;
        //     isMDOAdmin = false;
        //   }
        // } else {
        //   VegaConfiguration.isEnabled = false;
        // }
        _pageInitialized = true;
      });
    }
  }

  _doActionOnNotification() {
    //This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        // print("FirebaseMessaging.instance.getInitialMessage");
        // if (message != null) {
        //   print("New Notification");
        //   // if (message.data['_id'] != null) {
        //   //   Navigator.of(context).push(
        //   //     MaterialPageRoute(
        //   //       builder: (context) => DemoScreen(
        //   //         id: message.data['_id'],
        //   //       ),
        //   //     ),
        //   //   );
        //   // }
        // }
      },
    );

    // 2. This method only call when App in for-ground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        // print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          // print(message.notification.title);
          // print(message.notification.body);
          // print("message.data11 ${message.data}");
          LocalNotificationService.createAndDisplayNotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        // print("FirebaseMessaging.onMessageOpenedApp.listen");
        // print(message.data.toString());
        // developer.log(message.toString());
        // if (message.notification != null) {
        //   print('Hello');
        //   print(
        //       'Action: ' + message.notification.android.clickAction.toString());
        //   print('Hey');
        //   print(message.notification.body);
        //   print("message.data22 ${message.data['event']}");
        // }
      },
    );
  }

  _getConnectivity() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      _isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!_isDeviceConnected && !_isSetAlert) {
        _showDialogBox();
        setState(() {
          _isSetAlert = true;
        });
      }
    });
  }

  _showDialogBox() => {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/img/No_network.svg',
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(EnglishLang.noConnection)
                    ],
                  ),
                  content: Text(
                    EnglishLang.noConnectionDescription,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context, EnglishLang.cancel);
                          setState(() {
                            _isSetAlert = false;
                          });
                          _isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!_isDeviceConnected) {
                            _showDialogBox();
                            setState(() {
                              _isSetAlert = true;
                            });
                          }
                        },
                        child: Text(EnglishLang.retry))
                  ],
                ))
      };

  @override
  void dispose() {
    _controller.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
    // _getUserSessionId();
  }

  // Future<void> _getUserSessionId() async {
  //   var ssid = await Telemetry.getUserSessionId();
  //   print('ssid: $ssid');
  // }

  Future<void> _getUnSeenNotificationsCount() async {
    try {
      var unSeenNotificationsCount =
          await Provider.of<NotificationRespository>(context, listen: false)
              .getUnSeenNotificationsCount();
      setState(() {
        _unSeenNotificationsCount = int.parse(unSeenNotificationsCount);
      });
    } catch (err) {
      return err;
    }
  }

  // void searchResults(String searchKey) async {
  //   // print('$searchKey');
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => AiAssistantPage(searchKeyword: searchKey)));
  // }

  void _updateUnSeenNotificationsCount(bool status) {
    _getUnSeenNotificationsCount();
  }

  @override
  Widget build(BuildContext context) {
    // print('Index: ${widget.customIndex} , $_currentIndex');
    return FutureBuilder(
        future: _getProfileDetails(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
            // Page content
            body: UpgradeAlert(
              upgrader: Upgrader(
                  showIgnore: false,
                  showLater: false,
                  shouldPopScope: () => false,
                  canDismissDialog: false,
                  durationUntilAlertAgain: const Duration(days: 1),
                  dialogStyle: Platform.isIOS
                      ? UpgradeDialogStyle.cupertino
                      : UpgradeDialogStyle.material),
              child: PageTransitionSwitcher(
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
                child: VegaConfiguration.isEnabled
                    ? IndexedStack(
                        index: _currentIndex,
                        key: ValueKey<int>(_currentIndex),
                        // children: [
                        //   for (final tabItem in CustomBottomNavigation.items)
                        //     tabItem.index == 0
                        //         ? HomeScreen(
                        //             index: _currentIndex,
                        //           )
                        //         : tabItem.index == 1
                        //             ? HubScreen(index: _currentIndex)
                        //             : tabItem.index == 2
                        //                 ? ProfileScreen(index: _currentIndex)
                        //                 : tabItem.page,
                        // ],
                        children: [
                          for (final tabItem in CustomBottomNavigation.items)
                            tabItem.index == 0
                                ? HomeScreen(
                                    index: _currentIndex,
                                  )
                                : tabItem.index == 1
                                    ? HubScreen(index: _currentIndex)
                                    : _currentIndex == 2
                                        // ? AssistantScreen(index: _currentIndex)
                                        ? AiAssistantPage(
                                            searchKeyword: '...',
                                            index: tabItem.index,
                                          )
                                        : tabItem.index == 3
                                            ? NotificationScreen(
                                                updateNotificationsCount:
                                                    _updateUnSeenNotificationsCount,
                                                index: _currentIndex)
                                            : tabItem.index == 4
                                                ? ProfileScreen(
                                                    index: _currentIndex)
                                                : tabItem.page,
                        ],
                      )
                    : IndexedStack(
                        index: _currentIndex,
                        key: ValueKey<int>(_currentIndex),
                        children: [
                          for (final tabItem
                              in CustomBottomNavigation.itemsWithVegaDisabled)
                            tabItem.index == 0
                                ? HomeScreen(
                                    index: _currentIndex,
                                  )
                                : tabItem.index == 1
                                    ? HubScreen(index: _currentIndex)
                                    : tabItem.index == 2
                                        ? ProfileScreen(index: _currentIndex)
                                        : tabItem.page,
                        ],
                      ),
              ),
            ),

            // Bottom navigation bar
            bottomNavigationBar: SafeArea(
              child: DefaultTabController(
                length: !VegaConfiguration.isEnabled
                    ? CustomBottomNavigation.itemsWithVegaDisabled.length
                    : CustomBottomNavigation.items.length,
                child: Container(
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
                      unselectedLabelColor: AppColors.greys60,
                      labelColor: AppColors.primaryThree,
                      labelStyle: GoogleFonts.lato(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                      unselectedLabelStyle: GoogleFonts.lato(
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                      ),
                      onTap: (int index) => setState(() {
                        _currentIndex = index;
                        // if (index == 2) {
                        //   Future.delayed(Duration.zero, () async {
                        //     _speechRecognizer =
                        //         Provider.of<SpeechRecognizer>(context, listen: false);
                        //     _speechRecognizer.initialize(searchResults);
                        //     _speechRecognizer.listen();
                        //   });
                        // }
                        // if (index == 0) {
                        //   // Navigator.of(context).push(
                        //   //     MaterialPageRoute(builder: (context) => HomePage()));
                        //   // setState(() {});
                        //   Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (BuildContext context) => super.widget));
                        // }
                      }),
                      tabs: [
                        for (final tabItem in !VegaConfiguration.isEnabled
                            ? CustomBottomNavigation.itemsWithVegaDisabled
                            : CustomBottomNavigation.items)
                          tabItem.index == _currentIndex
                              ? Stack(children: <Widget>[
                                  SizedBox(
                                    height: 60.0,
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 3.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 4,
                                                  left: 8,
                                                  right: 8),
                                              child: SvgPicture.asset(
                                                tabItem.svgIcon,
                                                width: 24.0,
                                                height: 24.0,
                                              ),
                                            ),
                                            Text(
                                              tabItem.title,
                                              style: GoogleFonts.lato(
                                                  color: AppColors.primaryThree,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                  ),
                                  (tabItem.index == 3 &&
                                          _unSeenNotificationsCount > 0)
                                      ? Positioned(
                                          // draw a red marble
                                          top: 5,
                                          right: 0,
                                          child: Container(
                                            height: 20,
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    AppColors.negativeLight,
                                                child: Center(
                                                  child: Text(
                                                    _unSeenNotificationsCount
                                                        .toString(),
                                                    style: GoogleFonts.lato(
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )),
                                          ),
                                        )
                                      : Positioned(
                                          child: Text(''),
                                        ),
                                ])
                              : Stack(children: <Widget>[
                                  SizedBox(
                                    height: 60.0,
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 3.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 4,
                                                  left: 8,
                                                  right: 8),
                                              child: SvgPicture.asset(
                                                tabItem.unselectedSvgIcon,
                                                width: 24.0,
                                                height: 24.0,
                                              ),
                                            ),
                                            Text(
                                              tabItem.title,
                                              style: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                  ),
                                  (tabItem.index == 3 &&
                                          _unSeenNotificationsCount > 0)
                                      ? Positioned(
                                          // draw a red marble
                                          top: 5,
                                          right: 0,
                                          child: Container(
                                            height: 20,
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    AppColors.negativeLight,
                                                child: Center(
                                                  child: Text(
                                                    _unSeenNotificationsCount
                                                        .toString(),
                                                    style: GoogleFonts.lato(
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )),
                                          ),
                                        )
                                      : Positioned(
                                          child: Text(''),
                                        ),
                                ])
                      ],
                      controller: _controller,
                    ),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: AppColors.grey08,
                        blurRadius: 6.0,
                        spreadRadius: 0,
                        offset: Offset(
                          0,
                          -3,
                        ),
                      ),
                    ])),
              ),
            ),

            // Drawer
            key: _drawerKey,
            // drawer: CustomDrawer(),
          );
        });
  }
}
