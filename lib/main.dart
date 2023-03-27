import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/services/_services/local_notification_service.dart';
import 'package:karmayogi_mobile/splash_screen.dart';
// import 'package:upgrader/upgrader.dart';
import './landing_page.dart';
import './constants/index.dart';
// import 'dart:developer' as developer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Only call clearSavedSettings() during testing to reset internal values.
  // await Upgrader.clearSavedSettings();
  // REMOVE the above line for release builds

  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  LocalNotificationService.getDeviceTokenToSendNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MaterialApp(
    home: AnimatedSplashScreen(
        duration: 2000,
        splashIconSize: double.infinity,
        splashTransition: SplashTransition.fadeTransition,
        splash: SplashScreen(),
        nextScreen: LandingPage()),
    routes: <String, WidgetBuilder>{
      AppUrl.landingPage: (BuildContext context) => LandingPage(
            isFromUpdateScreen: false,
          )
    },
  ));
}

Future<void> backgroundHandler(RemoteMessage message) async {
  // print(message.data.toString());
  // developer.log(message.notification.android.imageUrl.toString());
  // print(message.notification.title);
}


// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LandingPage(),
//     );
//   }
// }
