import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/models/_models/login_user_details.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import './../../constants/index.dart';
import './../../services/index.dart';
// import 'dart:developer' as developer;

class LoginService extends BaseService {
  LoginService(HttpClient client) : super(client);

  /// Return login auth token as response
  static Future<dynamic> getLoggedIn(String username, String password) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: '*/*',
    };

    Map body = {
      'client_id': 'admin-cli',
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.keyCloakLogin),
        headers: headers,
        body: body);
    // print(response.body);
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  /// Return login auth token as response
  static Future<dynamic> doLogin(String code) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: '*/*',
    };

    Map body = {
      'redirect_uri': ApiUrl.baseUrl + '/oauth2callback',
      'code': code,
      'grant_type': 'authorization_code',
      'client_id': 'android'
    };

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.keyCloakLogin),
        headers: headers,
        body: body);
    // print(response.body);
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  /// Return wtoken of the logged user
  static Future<dynamic> getWtoken() async {
    final _storage = FlutterSecureStorage();

    String token = await _storage.read(key: Storage.authToken);

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer ' + '$token',
      HttpHeaders.acceptHeader: '*/*',
      'hostpath': ApiUrl.baseUrl,
      'org': 'dopt',
      'rootorg': 'igot',
    };

    final response = await http.get(Uri.parse(ApiUrl.baseUrl + ApiUrl.wToken),
        headers: headers);

    Map wTokenResponse;
    if (APP_ENVIRONMENT == Environment.eagle) {
      wTokenResponse = json.decode(response.body);
    } else {
      String cookie = response.headers['set-cookie'].split(';')[0];
      // developer.log(cookie);
      var body = jsonDecode(response.body);
      body['result']['response']['cookie'] = cookie + ';';
      wTokenResponse = body['result']['response'];
    }
    // developer.log(wTokenResponse.toString());
    return wTokenResponse;
  }

  /// Return basic user information of the logged in user
  static Future<dynamic> getBasicUserInfo() async {
    final _storage = FlutterSecureStorage();

    String token = await _storage.read(key: Storage.authToken);
    String userId = await _storage.read(key: Storage.userId);
    String authorizationKey = 'bearer ' + ApiUrl.apiKey;
    //  print(token);
    // print(userId);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authorizationKey,
      'x-authenticated-user-token': token,
    };
    // print(ApiUrl.keycloakBaseUrlDev + ApiUrl.basicUserInfo + userId.toString());
    final response = await http.get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.basicUserInfo + userId),
        headers: headers);

    var body = jsonDecode(response.body);
    // developer.log('User info: ' + body.toString());
    Map wTokenResponse;
    wTokenResponse = body['result']['response'];

    // Map wTokenResponse;
    // if (APP_ENVIRONMENT == Environment.eagle) {
    //   wTokenResponse = json.decode(response.body);
    // } else {
    //   String cookie = response.headers['set-cookie'].split(';')[0];
    //   // developer.log(cookie);
    //   var body = jsonDecode(response.body);
    //   body['result']['response']['cookie'] = cookie + ';';
    //   wTokenResponse = body['result']['response'];
    // }
    // developer.log(wTokenResponse.toString());
    return wTokenResponse;
  }

  ///To update the DB w.r.t. login time
  static Future<dynamic> updateLogin() async {
    final _storage = FlutterSecureStorage();

    String token = await _storage.read(key: Storage.authToken);
    String userId = await _storage.read(key: Storage.userId);
    String orgId = await _storage.read(key: Storage.deptId);
    String authorizationKey = 'bearer ' + ApiUrl.apiKey;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authorizationKey,
      'x-authenticated-user-token': token,
    };

    Map data = {"userId": "$userId", "orgId": "$orgId"};
    // print(data);
    var body = jsonEncode(data);

    final response = await http.put(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.updateLogin),
        headers: headers,
        body: body);

    var res = jsonDecode(response.body);
    return res;
  }

  /// Return nodebb auth token as response
  static Future<Map> createNodeBBSession(
      String userName, String wid, String firstname, String lastname) async {
    final _storage = FlutterSecureStorage();
    String authorizationKey = 'bearer ' + ApiUrl.apiKey;
    String token = await _storage.read(key: Storage.authToken);
    String fullname = firstname + lastname;

    Map<String, String> headers = {
      'rootorg': 'igot',
      'content-type': 'application/json',
      'org': 'dopt',
      'Authorization': authorizationKey,
      'X-authenticated-User-Token': token
    };

    Map data = {
      "request": {
        "username": '$userName',
        "identifier": '$wid',
        "fullname": '$fullname'
      }
    };

    String body = json.encode(data);
    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.createNodeBBSession),
        headers: headers,
        body: body);
    // print(
    //     'Request url: ${ApiUrl.keycloakBaseUrlDev + ApiUrl.createNodeBBSession}');
    // print('Request headers: $body');
    // print('Response: ${response.body}');
    var responseBody = jsonDecode(response.body);
    Map responseData = {
      'nodebbAuthToken': response.headers['nodebb_auth_token'],
      'nodebbUserId': responseBody['result']['userId']['uid']
    };
    // print(responseData);
    // developer
    //     .log('NodeBB: ' + response.headers['nodebb_auth_token'].toString());
    return responseData;
  }

  // For Parichay
  /// Return login auth token as response
  static Future<dynamic> doParichayLogin(String code, context) async {
    final _storage = FlutterSecureStorage();
    String redirectUrl = await _storage.read(key: Storage.redirectUrl);
    Map<String, String> headers = {'Content-type': 'application/json'};

    // print('Code in login service: $code');

    Map data = {
      'client_id': PARICHAY_CLIENT_ID,
      'client_secret': PARICHAY_CLIENT_SECRET,
      'code': code,
      'code_verifier': PARICHAY_CODE_VERIFIER,
      'grant_type': 'authorization_code',
      'redirect_uri': ApiUrl.parichayLoginRedirectUrl,
    };

    var body = jsonEncode(data);

    // developer.log('Request body to get token: $body');

    final response = await http.post(
        Uri.parse(ApiUrl.parichayBaseUrl + ApiUrl.getParichayToken),
        headers: headers,
        body: body);
    // developer.log('Getting token response: ' + response.body.toString());
    if (response.statusCode == 200) {
      Map convertedResponse = json.decode(response.body);
      return convertedResponse;
    } else {
      return Helper.showErrorScreen(context, response.body.toString(),
          statusCode: response.statusCode);
    }
  }

  /// Return basic user information of the logged in user in Parichay
  static Future<dynamic> getParichayUserInfo() async {
    final _storage = FlutterSecureStorage();

    String parichayToken = await _storage.read(key: Storage.parichayAuthToken);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "$parichayToken",
    };
    // print(ApiUrl.keycloakBaseUrlDev + ApiUrl.basicUserInfo + userId.toString());
    final response = await http.get(
        Uri.parse(ApiUrl.parichayBaseUrl + ApiUrl.getParichayUserInfo),
        headers: headers);
    // developer.log('User info: ' + response.body.toString());

    var body = jsonDecode(response.body);
    return body;
  }

  /// Return basic user information of the Parichay user with his email
  static Future<dynamic> getUserDetailsByEmailId(String email) async {
    Map data = {
      "request": {
        "filters": {"email": "$email"},
        "fields": ["userId", "status", "channel", "rootOrgId", "organisations"]
      }
    };

    var body = jsonEncode(data);
    // print(ApiUrl.keycloakBaseUrlDev + ApiUrl.basicUserInfo + userId.toString());
    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getUserDetails),
        headers: Helper.signUpPostHeaders(),
        body: body);
    // developer.log('User details: ' + response.body.toString());

    var content = jsonDecode(response.body);
    // developer.log(wTokenResponse.toString());
    return content;
  }

  /// Return keycloak login auth token as response
  static Future<dynamic> getKeyCloakToken(String email, context) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: '*/*',
    };

    Map body = {
      'client_id': Client.parichayClientId,
      'client_secret': PARICHAY_KEYCLOAK_CLIENT_SECRET,
      'grant_type': 'password',
      'scope': 'offline_access',
      'username': '$email'
    };

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.keyCloakLogin),
        headers: headers,
        body: body);
    // print(response.body);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      Map convertedResponse = json.decode(response.body);
      // developer.log('KeyCloak: ' + convertedResponse.toString());
      return convertedResponse;
    } else {
      Helper.showErrorScreen(context, response.body.toString());
      // throw response.statusCode.toString();
    }
  }

  /// calling signUp API if the user doesn't exist
  static Future<dynamic> doSignUp(LoginUser userDetails) async {
    // print(
    //     'To create account: ${userDetails.email} ${userDetails.firstName} ${userDetails.lastName}');

    Map data = {
      "request": {
        "email": "${userDetails.email}",
        "emailVerified": true,
        "firstName": "${userDetails.firstName}",
        "lastName": "${userDetails.lastName}"
      }
    };

    var body = jsonEncode(data);

    final response = await http.post(Uri.parse(ApiUrl.baseUrl + ApiUrl.signUp),
        headers: Helper.signUpPostHeaders(), body: body);
    // print(response.body);
    Map convertedResponse = json.decode(response.body);
    // developer.log('Signup: ' + convertedResponse.toString());

    // return convertedResponse;
  }
}
