import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/_models/login_user_details.dart';
import 'package:karmayogi_mobile/signup.dart';
import 'package:karmayogi_mobile/ui/widgets/custom_tabs.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constants/_constants/telemetry_constants.dart';
import './../../util/telemetry.dart';
import 'dart:developer' as developer;
import '../../models/index.dart';
import '../../services/index.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import './../../util/telemetry_db_helper.dart';

class LoginRespository with ChangeNotifier {
  Login _loginDetails;
  Login _parichayLoginDetails;
  LoginUser _parichayLoginInfo;
  Wtoken _wtokenDetails;
  String _errorMessage;
  TelemetryService telemetryService = TelemetryService();

  final _storage = FlutterSecureStorage();

  Future<dynamic> loadData(String email, String password) async {
    try {
      final loginInfo = await LoginService.getLoggedIn(email, password);
      // print("Basic user info $loginInfo");
      _loginDetails = Login.fromJson(loginInfo);
    } catch (_) {
      return _;
    }
    if (_loginDetails.accessToken != null) {
      _storage.write(key: Storage.authToken, value: _loginDetails.accessToken);
      _storage.write(
          key: Storage.refreshToken, value: _loginDetails.refreshToken);

      // print(_loginDetails.accessToken);
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(_loginDetails.accessToken.toString());
      // print(decodedToken['sub']);
      String userId = decodedToken['sub'].split(':')[2];
      // print(userId);
      _storage.write(key: Storage.userId, value: userId);

      final basicUserInfo = await LoginService.getBasicUserInfo();
      // print("Basic user info $basicUserInfo");
      // final wtokenInfo = await LoginService.getWtoken();
      // developer.log(wtokenInfo.toString());
      _wtokenDetails = Wtoken.fromJson(basicUserInfo);
      // print('basicUserInfo:' + basicUserInfo.toString());
      // print(wtokenInfo['rootOrg']['rootOrgId']);
      // developer.log(_wtokenDetails.wid.toString());
      if (_wtokenDetails != null) {
        _storage.write(key: Storage.wid, value: _wtokenDetails.wid);
        _storage.write(key: Storage.userName, value: _wtokenDetails.userName);
        _storage.write(key: Storage.firstName, value: _wtokenDetails.firstName);
        _storage.write(key: Storage.lastName, value: _wtokenDetails.lastName);
        _storage.write(key: Storage.deptName, value: _wtokenDetails.deptName);
        _storage.write(key: Storage.deptId, value: _wtokenDetails.deptId);
        _storage.write(key: Storage.email, value: _wtokenDetails.email);
        // _storage.write(key: 'cookie', value: _wtokenDetails.cookie);
        // Create session in NodeBB
        if (_wtokenDetails.userName != '') {
          // print('NodeBB');
          Map nodebb = await LoginService.createNodeBBSession(
              _wtokenDetails.userName,
              _wtokenDetails.wid,
              _wtokenDetails.firstName,
              _wtokenDetails.lastName);
          // print('nodebb: ' + nodebb.toString());
          if (nodebb['nodebbUserId'] != null) {
            // print('Yuy: ' + nodebb['nodebbUserId'].toString());
            _storage.write(
                key: Storage.nodebbAuthToken, value: nodebb['nodebbAuthToken']);
            _storage.write(
                key: Storage.nodebbUserId,
                value: nodebb['nodebbUserId'].toString());
            // print('Node bb uuid ${nodebb['nodebbUserId'].toString()}');
            // print('Node bb uuid ${_wtokenDetails.userName}');
          }
          // String deviceIdentifier = await Telemetry.getDeviceIdentifier();
          // String userId = await Telemetry.getUserId();
          // // print('userId : $userId');
          // String userSessionId = await Telemetry.generateUserSessionId();
          // // print('userSessionId : $userSessionId');
          // String messageIdentifier = await Telemetry.generateUserSessionId();
          // // print('messageIdentifier : $messageIdentifier');
          // String departmentId = await Telemetry.getUserDeptId();
          // // print('departmentId : $departmentId');
          // Map eventData = Telemetry.getAuditTelemetryEvent(
          //   deviceIdentifier,
          //   userId,
          //   departmentId,
          //   userSessionId,
          //   messageIdentifier,
          // );
          // List allEventsData = [];
          // allEventsData.add(eventData);
          // var telemetryEventData =
          //     TelemetryEventModel(userId: userId, eventData: eventData);
          // await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
          // telemetryService.triggerEvent(allEventsData);
        }
      }
    }

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Kindly enter the credentials';
    }

    if (_loginDetails.accessToken == null &&
        email.isNotEmpty &&
        password.isNotEmpty) {
      _errorMessage = 'Kindly check the credentials';
    }

    return _loginDetails;
  }

  Future<dynamic> fetchOAuthTokens(String code) async {
    try {
      final loginInfo = await LoginService.doLogin(code);
      // print("Basic user info $loginInfo");
      _loginDetails = Login.fromJson(loginInfo);
    } catch (_) {
      return _;
    }
    if (_loginDetails.accessToken != null) {
      _storage.write(key: Storage.authToken, value: _loginDetails.accessToken);
      _storage.write(
          key: Storage.refreshToken, value: _loginDetails.refreshToken);

      // print(_loginDetails.accessToken);
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(_loginDetails.accessToken.toString());
      // print(decodedToken['sub']);
      String userId = decodedToken['sub'].split(':')[2];
      // print(userId);
      _storage.write(key: Storage.userId, value: userId);

      await getBasicUserInfo(_loginDetails.accessToken);
    }
    // await LoginService.updateLogin();

    return _loginDetails;
  }

  Future<dynamic> getBasicUserInfo(String accessToken,
      {bool isParichayUser = false}) async {
    if (accessToken != null) {
      final basicUserInfo = await LoginService.getBasicUserInfo();
      // print("Basic user info $basicUserInfo");
      // final wtokenInfo = await LoginService.getWtoken();
      // developer.log(wtokenInfo.toString());
      _wtokenDetails = Wtoken.fromJson(basicUserInfo);
      // print('basicUserInfo:' + basicUserInfo.toString());
      // print(wtokenInfo['rootOrg']['rootOrgId']);
      // developer.log(_wtokenDetails.wid.toString());
      if (_wtokenDetails != null) {
        _storage.write(key: Storage.wid, value: _wtokenDetails.wid);
        _storage.write(key: Storage.userName, value: _wtokenDetails.userName);
        _storage.write(key: Storage.firstName, value: _wtokenDetails.firstName);
        _storage.write(key: Storage.lastName, value: _wtokenDetails.lastName);
        _storage.write(key: Storage.deptName, value: _wtokenDetails.deptName);
        _storage.write(key: Storage.deptId, value: _wtokenDetails.deptId);
        _storage.write(key: Storage.email, value: _wtokenDetails.email);
        _storage.write(
            key: Storage.designation, value: _wtokenDetails.designation);

        isParichayUser
            ? _storage.write(
                key: Storage.clientId, value: Client.parichayClientId)
            : _storage.write(
                key: Storage.clientId, value: Client.androidClientId);

        // _storage.write(key: 'cookie', value: _wtokenDetails.cookie);
        // Create session in NodeBB
        if (_wtokenDetails.userName != '') {
          // print('NodeBB');
          Map nodebb = await LoginService.createNodeBBSession(
              _wtokenDetails.userName,
              _wtokenDetails.wid,
              _wtokenDetails.firstName,
              _wtokenDetails.lastName);
          // print('nodebb: ' + nodebb.toString());
          if (nodebb['nodebbUserId'] != null) {
            // print('Yuy: ' + nodebb['nodebbUserId'].toString());
            _storage.write(
                key: Storage.nodebbAuthToken, value: nodebb['nodebbAuthToken']);
            _storage.write(
                key: Storage.nodebbUserId,
                value: nodebb['nodebbUserId'].toString());
            // print('Node bb uuid ${nodebb['nodebbUserId'].toString()}');
            // print('Node bb uuid ${_wtokenDetails.userName}');
          }
          String deviceIdentifier = await Telemetry.getDeviceIdentifier();
          String userId = await Telemetry.getUserId();
          // print('userId : $userId');
          String userSessionId = await Telemetry.generateUserSessionId();
          // print('userSessionId : $userSessionId');
          String messageIdentifier = await Telemetry.generateUserSessionId();
          // print('messageIdentifier : $messageIdentifier');
          String departmentId = await Telemetry.getUserDeptId();
          // print('departmentId : $departmentId');
          Map eventData = Telemetry.getStartTelemetryEvent(
            deviceIdentifier,
            userId,
            departmentId,
            TelemetryPageIdentifier.homePageId,
            userSessionId,
            messageIdentifier,
            TelemetryMode.view,
            TelemetryPageIdentifier.homePageId,
          );
          List allEventsData = [];
          allEventsData.add(eventData);
          var telemetryEventData =
              TelemetryEventModel(userId: userId, eventData: eventData);
          await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
          // telemetryService.triggerEvent(allEventsData);
        }
      }
    }
  }

  //For Parichay
  Future<dynamic> fetchParichayToken(String code, context) async {
    try {
      final loginInfo = await LoginService.doParichayLogin(code, context);
      print("Basic user info $loginInfo");
      _parichayLoginDetails = Login.fromJson(loginInfo);
    } catch (_) {
      return _;
    }
    if (_parichayLoginDetails.accessToken != null) {
      await _storage.write(
          key: Storage.parichayAuthToken,
          value: _parichayLoginDetails.accessToken);
      await _storage.write(
          key: Storage.parichayRefreshToken,
          value: _parichayLoginDetails.refreshToken);

      //getting parichay user info
      final basicParichayUserInfo = await LoginService.getParichayUserInfo();
      _parichayLoginInfo = LoginUser.fromJson(basicParichayUserInfo);

      //getting user details from iGOT
      final userDetails =
          await LoginService.getUserDetailsByEmailId(_parichayLoginInfo.email);

      bool isFirstTimeUser = false;

      // print('Count: ' + userDetails['result']['response']['count'].toString());
      // print('Error msg: ' + userDetails['params']['errmsg'].toString());

      if (userDetails['params']['errmsg'] == null ||
          userDetails['params']['errmsg'] == '') {
        if (userDetails['result']['response']['count'] == 0) {
          await LoginService.doSignUp(_parichayLoginInfo);
          isFirstTimeUser = true;
        } else {
          if (userDetails['result']['response']['content'][0]['rootOrgId']
                      .toString() !=
                  '' &&
              userDetails['result']['response']['content'][0]['rootOrgId']
                      .toString() ==
                  X_CHANNEL_ID) {
            isFirstTimeUser = true;
          }
        }

        //calling keycloak api
        final loginInfo = await LoginService.getKeyCloakToken(
            _parichayLoginInfo.email, context);
        _loginDetails = Login.fromJson(loginInfo);

        developer.log('LoginInfo: ' + loginInfo.toString());

        await _storage.write(
            key: Storage.authToken, value: _loginDetails.accessToken);
        await _storage.write(
            key: Storage.refreshToken, value: _loginDetails.refreshToken);

        if (isFirstTimeUser) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignUpPage(
                parichayLoginInfo: _parichayLoginInfo,
                isParichayUser: true,
              ),
            ),
          );
        } else {
          if (_loginDetails.accessToken != null) {
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(_loginDetails.accessToken.toString());
            // print(decodedToken['sub']);
            String userId = decodedToken['sub'].split(':')[2];
            // print(userId);
            await _storage.write(key: Storage.userId, value: userId);

            await getBasicUserInfo(_loginDetails.accessToken,
                isParichayUser: true);
            return Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CustomTabs(
                  customIndex: 0,
                  token: _loginDetails.accessToken,
                ),
              ),
            );
          }
        }
      }
    }
  }

  Future<void> clearData() async {
    final cookieManager = CookieManager();
    cookieManager.clearCookies();
    await _storage.deleteAll();
  }

  // LoginModel getLoginList(int index) => _loginList[index];

  // int get getLoginCount => _loginList?.length;

  // List<LoginModel> get getLoginDetails => _loginList;

  String get errorMessage => _errorMessage;

  // List<WtokenModal> get widDetails => _wtokenDetails;

}
