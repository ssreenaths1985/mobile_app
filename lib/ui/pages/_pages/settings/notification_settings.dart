import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/_learn/content_info.dart';
import 'package:provider/provider.dart';
import './../../../../constants/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../respositories/index.dart';
import './../../../../localization/_langs/english_lang.dart';

class NotificationSettings extends StatefulWidget {
  static const route = AppUrl.settingsPage;

  @override
  _NotificationSettingsState createState() {
    return new _NotificationSettingsState();
  }
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isSwitched = false;
  var _notificationSettings;
  Map _userNotificationPreference;
  bool _isPageInitialized = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // if (widget.index == 1) {
    _getNotificationSettings();
    // }
  }

  Future<dynamic> _getNotificationSettings() async {
    if (!_isPageInitialized) {
      try {
        _notificationSettings =
            await Provider.of<NotificationRespository>(context, listen: false)
                .getNotificationPreferenceSettings();
        _userNotificationPreference =
            await Provider.of<NotificationRespository>(context, listen: false)
                .getNotificationPreference();
        // setState(() {});
      } catch (err) {
        return err;
      }
    }
    setState(() {
      _isPageInitialized = true;
    });
    return _notificationSettings;
  }

  Future<void> _saveSettings(Map notificationPreferences) async {
    try {
      final response =
          await Provider.of<NotificationRespository>(context, listen: false)
              .saveNotificationSettings(notificationPreferences);
      var snackbar;
      if (response['params']['errmsg'] == null ||
          response['params']['errmsg'] == '') {
        snackbar = SnackBar(
          content: Text(EnglishLang.notificationSettingsSavedText),
          backgroundColor: AppColors.positiveLight,
        );
      } else {
        snackbar = SnackBar(
          content: Text(response['params']['errmsg']),
          backgroundColor: AppColors.negativeLight,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } catch (err) {
      return err;
    }
    setState(() {
      _isPageInitialized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          titleSpacing: 0,
          // leading: IconButton(
          //   icon: Icon(Icons.settings, color: AppColors.greys60),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          title: Row(children: [
            // Icon(Icons.settings, color: AppColors.greys60),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  EnglishLang.notificationSettings,
                  style: GoogleFonts.montserrat(
                    color: AppColors.greys87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ))
          ]),
          // centerTitle: true,
        ),
        body: FutureBuilder(
            future: _getNotificationSettings(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                // print(snapshot.data.length);
                return SingleChildScrollView(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                                  color: Color.fromRGBO(241, 244, 244, 1),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SectionHeading('Email notification'),
                                        Container(
                                          // margin: const EdgeInsets.only(left: 0),
                                          padding: const EdgeInsets.only(
                                              right: 0, top: 8),
                                          height: 3 * 58.0,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                _notificationSettings.length,
                                            itemBuilder: (BuildContext context,
                                                    int i) =>
                                                _generateCheckbox(
                                                    context,
                                                    index,
                                                    i,
                                                    _notificationSettings[i]),
                                          ),
                                        ),
                                      ]),
                                ))));
              } else {
                return PageLoader();
              }
            }));
  }

  Widget _generateCheckbox(
      BuildContext context, int mainIndex, int eventIndex, Map event) {
    bool activeStatus;
    if (_userNotificationPreference != null &&
        _userNotificationPreference.containsKey(event['id'])) {
      activeStatus = _userNotificationPreference[event['id']];
    }
    return Visibility(
      visible: event['isVisible'],
      child: Container(
          height: 56,
          margin: const EdgeInsets.only(bottom: 2),
          padding: EdgeInsets.only(left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    event['displayName'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                  ContentInfo(
                    infoMessage: event['helpText'],
                  )
                ],
              ),
              Switch.adaptive(
                value: activeStatus,
                onChanged: (value) {
                  setState(() {
                    activeStatus = value;
                    if (_userNotificationPreference != null) {
                      _userNotificationPreference[event['id']] = value;
                    } else {
                      _userNotificationPreference = {event['id']: value};
                    }
                  });
                  _saveSettings(_userNotificationPreference);
                },
                // activeTrackColor: Color.fromRGBO(0, 116, 182, 0.3),
                activeColor: AppColors.primaryThree,
              ),
            ],
          )),
    );
  }
}
