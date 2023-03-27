// import 'dart:developer';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/env/env.dart';
import 'package:karmayogi_mobile/respositories/_respositories/badge_repository.dart';
import 'package:karmayogi_mobile/respositories/_respositories/event_repository.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:karmayogi_mobile/ui/screens/_screens/onboarding_screen.dart';
import 'package:karmayogi_mobile/update_password.dart';
// import 'package:karmayogi_mobile/web_view.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
// import './login.dart';
import './util/speech_recognizer.dart';
import './util/index.dart';
import './constants/index.dart';
import './respositories/index.dart';
// import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'ui/widgets/index.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LandingPage extends StatefulWidget {
  final bool isFromUpdateScreen;

  const LandingPage({Key key, this.isFromUpdateScreen = false})
      : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

void setErrorBuilder() {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorPage();
  };
}

class _LandingPageState extends State<LandingPage> {
  final client = HttpClient();
  final _storage = FlutterSecureStorage();
  String _code;
  String _parichayCode;
  String _parichayToken;
  String _token;
  StreamSubscription<Uri> _linkSubscription;

  @override
  void initState() {
    super.initState();
    if (!widget.isFromUpdateScreen) {
      // print('I am here////,,,');
      _initAppLinks();
    }
    _checkCode();
    _initUniqueIdentifierState();
  }

  Future<void> _initAppLinks() async {
    // print('Calling init link');
    AppLinks _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getLatestAppLink();
    // print('Connecting to app link');
    if (appLink != null) {
      // print('getInitialAppLink: $appLink');
      // openAppLink(appLink);
      if (appLink.toString().startsWith(
          "${Env.portalBaseUrl}/auth/realms/sunbird/login-actions/action-token")) {
        // print('Navigating');
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UpdatePassword(
              initialUrl: appLink.toString(),
            ),
          ),
        );
      }
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      // print('onAppLink: $uri');
      if (uri.toString().startsWith(
          "${Env.portalBaseUrl}/auth/realms/sunbird/login-actions/action-token")) {
        // print('Navigating');
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UpdatePassword(
              initialUrl: uri.toString(),
            ),
          ),
        );
      }
      // openAppLink(uri);
    });
  }

  Future<void> _checkCode() async {
    String code = await _storage.read(key: Storage.code);
    String parichayCode = await _storage.read(key: Storage.parichayCode);
    String parichayToken = await _storage.read(key: Storage.parichayAuthToken);
    String token = await _storage.read(key: Storage.authToken);
    setState(() {
      _code = code;
      _parichayCode = parichayCode;
      _parichayToken = parichayToken;
      _token = token;
    });
  }

  Future<void> _initUniqueIdentifierState() async {
    String identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    identifier = sha256.convert(utf8.encode(identifier)).toString();
    _storage.write(key: Storage.deviceIdentifier, value: identifier);
    // print('identifier: $identifier');
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
    // _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    setErrorBuilder();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginRespository()),
        ChangeNotifierProvider.value(value: DiscussRepository()),
        ChangeNotifierProvider.value(value: CategoryRepository()),
        ChangeNotifierProvider.value(value: NetworkRespository()),
        ChangeNotifierProvider.value(value: SpeechRecognizer()),
        ChangeNotifierProvider.value(value: NotificationRespository()),
        ChangeNotifierProvider.value(value: KnowledgeResourceRespository()),
        ChangeNotifierProvider.value(value: LearnRepository()),
        ChangeNotifierProvider.value(value: CompetencyRepository()),
        ChangeNotifierProvider.value(value: ProfileRepository()),
        ChangeNotifierProvider.value(value: EventRepository()),
        ChangeNotifierProvider.value(value: BadgeRepository()),

        // ChangeNotifierProvider(
        //     create: (_) => NetworkRespository(NetworkService(client))),
      ],
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBackground,
            primaryColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme:
                AppBarTheme(color: Colors.white, foregroundColor: Colors.black),
            dividerColor: Colors.transparent),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: Routes.generateRoute,
        onUnknownRoute: Routes.errorRoute,
        home: ((_code != null && _token != null) ||
                (_parichayCode != null &&
                    (_parichayToken != null && _token != null)))
            ? CustomTabs(
                customIndex: 0,
              )
            : UpgradeAlert(
                upgrader: Upgrader(
                    showIgnore: false,
                    showLater: false,
                    shouldPopScope: () => false,
                    canDismissDialog: false,
                    durationUntilAlertAgain: const Duration(days: 1),
                    dialogStyle: Platform.isIOS
                        ? UpgradeDialogStyle.cupertino
                        : UpgradeDialogStyle.material),
                child: OnboardingScreen()),
      ),
    );
  }
}
