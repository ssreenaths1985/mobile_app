import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/services/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_signup/contact_us.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';
import '../../../constants/_constants/storage_constants.dart';
// import '../../pages/_pages/settings/notification_settings.dart';
import './../../../respositories/index.dart';
// import './../../../ui/pages/index.dart';
import './../../../util/faderoute.dart';
import './../../../ui/screens/index.dart';
// import './../../../feedback/pages/index.dart';
import './../../../constants/index.dart';
import './../../../util/telemetry.dart';

class SettingsScreen extends StatefulWidget {
  static const route = AppUrl.settingsPage;

  @override
  _SettingsScreenState createState() {
    return new _SettingsScreenState();
  }
}

Future<void> doLogout(context) async {
  final _storage = FlutterSecureStorage();
  String parichayToken = await _storage.read(key: Storage.parichayAuthToken);
  // print('Parichay token: $parichayToken');

  String userId = await Telemetry.getUserId();
  await TelemetryDbHelper.triggerEvents(userId, forceTrigger: true);

  try {
    final keyCloakLogoutResponse = await LogoutService.doKeyCloakLogout();
    if (keyCloakLogoutResponse == 204) {
      if (parichayToken != null) {
        final parichayLogoutResponse = await LogoutService.doParichayLogout();
        if (parichayLogoutResponse == 200) {
          // print('revoke success');
          await Provider.of<LoginRespository>(context, listen: false)
              .clearData();
          Navigator.pushNamedAndRemoveUntil(
              context, AppUrl.onboardingScreen, (r) => false);
        }
      } else {
        await Provider.of<LoginRespository>(context, listen: false).clearData();
        Navigator.pushNamedAndRemoveUntil(
            context, AppUrl.onboardingScreen, (r) => false);
      }
    }
  } catch (e) {
    // await Provider.of<LoginRespository>(context, listen: false).clearData();
    throw e;
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<bool> _onBackPressed(contextMain) {
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
                          height: 190.0,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  child: Text(
                                    'Do you want to logout?',
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                  doLogout(contextMain);
                                },
                                child: roundedButton('Yes, logout',
                                    Colors.white, AppColors.primaryThree),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(true),
                                  child: roundedButton('No, take me back',
                                      AppColors.primaryThree, Colors.white),
                                ),
                              )
                            ],
                          ),
                        )))
              ],
            ));
  }

  Future<bool> _onLangClick() {
    return showDialog(
        context: context,
        builder: (context) => Stack(
              children: [
                Positioned(
                    child: Align(
                        // alignment: FractionalOffset.center,
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          // margin: EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          height: 170.0,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    'Oho!',
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  child: Text(
                                    'Current version only supports English, other Indian languages will be available soon.',
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )),
                              Row(children: [
                                // GestureDetector(
                                //   onTap: () => Navigator.of(context).pop(true),
                                //   child: roundedButton('Yes, exit',
                                //       Colors.white, AppColors.primaryThree),
                                // ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(false),
                                  child: roundedButton(
                                    'Okay',
                                    AppColors.primaryThree,
                                    Colors.white,
                                  ),
                                ),
                              ])
                            ],
                          ),
                        )))
              ],
            ));
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width - 40,
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
            fontWeight: FontWeight.w700),
      ),
    );
    return loginBtn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 244, 244, 1),
      appBar: AppBar(
        titleSpacing: 0,
        leading: BackButton(color: AppColors.greys60),
        // leading: IconButton(
        //   icon: Icon(Icons.settings, color: AppColors.greys60),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: Row(children: [
          Icon(Icons.settings, color: AppColors.greys60),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Settings',
                style: GoogleFonts.montserrat(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ))
        ]),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Color.fromRGBO(241, 244, 244, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/img/settings_w.svg',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, top: 32, bottom: 16),
                child: Text(
                  'General',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0.25),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: SvgPicture.asset(
                          'assets/img/language.svg',
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      InkWell(
                          onTap: () => _onLangClick(),
                          child: Container(
                              width: 278,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Language',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  )
                                ],
                              ))),
                    ],
                  )),
              InkWell(
                  onTap: () => Navigator.push(
                        context,
                        // FadeRoute(page: NotificationSettings()),
                        FadeRoute(
                            page: ComingSoonScreen(
                          removeGoToWeb: true,
                        )),
                      ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: SvgPicture.asset(
                              'assets/img/notifications.svg',
                              width: 25.0,
                              height: 25.0,
                              color: AppColors.greys87,
                            ),
                          ),
                          Container(
                              width: 278,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Notification settings',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ))),
              InkWell(
                onTap: () => (() {}),
                child: Container(
                  padding: const EdgeInsets.only(left: 16, top: 32, bottom: 16),
                  child: Text(
                    'Others',
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        letterSpacing: 0.25),
                  ),
                ),
              ),
              InkWell(
                  onTap: () => Navigator.push(
                        context,
                        FadeRoute(
                            page: ComingSoonScreen(
                          removeGoToWeb: true,
                        )),
                      ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: SvgPicture.asset(
                              'assets/img/share.svg',
                              width: 25.0,
                              height: 25.0,
                              color: AppColors.greys60,
                            ),
                          ),
                          Container(
                              width: 278,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Share application',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ))),
              InkWell(
                  onTap: () => Navigator.push(
                        context,
                        // FadeRoute(page: FeedbackPage()),
                        FadeRoute(
                            page: ComingSoonScreen(
                          removeGoToWeb: true,
                        )),
                      ),
                  // onTap: () => Navigator.push(
                  //       context,
                  //       FadeRoute(page: ComingSoonScreen()),
                  //     ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: SvgPicture.asset(
                              'assets/img/feedback.svg',
                              width: 25.0,
                              height: 25.0,
                              color: AppColors.greys60,
                            ),
                          ),
                          Container(
                              width: 278,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Give feedback',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ))),
              InkWell(
                  onTap: () => Navigator.push(
                        context,
                        FadeRoute(page: ContactUs()),
                      ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: SvgPicture.asset(
                              'assets/img/help.svg',
                              width: 25.0,
                              height: 25.0,
                              color: AppColors.greys60,
                            ),
                          ),
                          Container(
                              width: 278,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Help',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ))),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: SvgPicture.asset(
                          'assets/img/logout.svg',
                          width: 25.0,
                          height: 25.0,
                          color: AppColors.greys87,
                        ),
                      ),
                      InkWell(
                        onTap: () => _onBackPressed(context),
                        child: Container(
                            width: 278,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Sign out',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                  ),
                                )
                              ],
                            )),
                      )
                    ],
                  )),
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Release ' + APP_VERSION,
                  style: GoogleFonts.montserrat(
                      color: AppColors.greys60,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                alignment: Alignment.center,
                child: Text(
                  EnglishLang.copyRightText,
                ),
              ),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: Transform.translate(
      //   offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      //   child: BottomAppBar(
      //     child: Container(
      //         height: 56,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //               Padding(
      //                 padding: const EdgeInsets.all(16.0),
      //                 child: Container(
      //                   height: 48,
      //                   // width: double.infinity,
      //                   child: Text(
      //                     'Karmayogi Bharat',
      //                     style: GoogleFonts.lato(
      //                         color: AppColors.greys87,
      //                         fontSize: 14.0,
      //                         fontWeight: FontWeight.w700),
      //                   ),
      //                 ),
      //               ),
      //           ])),
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
