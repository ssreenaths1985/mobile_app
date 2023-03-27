import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import './../../constants/index.dart';
import './../../services/index.dart';
import './../../util/helper.dart';
// import 'dart:developer' as developer;

class NetworkService extends BaseService {
  NetworkService(HttpClient client) : super(client);

  /// Return list of people as you may know as response
  static Future<dynamic> getPeopleYouMayKnow() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.peopleYouMayKnow),
      headers: Helper.getHeaders(token, wid),
    );
    // print('PYMK: ' + response.body);
    Map peopleYouMayKnowResponse = json.decode(response.body);
    return peopleYouMayKnowResponse;
  }

  /// Return list of people as you may know as response
  static Future<dynamic> getConnectionRequests() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.connectionRequest),
      headers: Helper.getHeaders(token, wid),
    );
    // print(ApiUrl.baseUrl +
    //     ApiUrl.connectionRequest +
    //     ': ${response.body}');
    Map connectionRequestResponse = json.decode(response.body);

    return connectionRequestResponse;
  }

  /// Return list of people as you may know as response
  static Future<dynamic> postConnectionRequest(
      String connectionId, profileDetailsFrom, profileDetailsTo) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      'connectionId': connectionId,
      'userIdFrom': wid,
      'userNameFrom': profileDetailsFrom.first.firstName,
      'userDepartmentFrom': profileDetailsFrom.first.department,
      'userIdTo': connectionId,
      'userNameTo': profileDetailsTo.first.firstName,
      'userDepartmentTo': profileDetailsTo.first.department
    };

    String body = json.encode(data);

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.postConnectionReq),
        headers: Helper.postHeaders(token, wid),
        body: body);
    // print('Connect: ' + response.body.toString());

    Map postCRResponse = json.decode(response.body);

    return postCRResponse;
  }

  /// Return list of established connections
  static Future<dynamic> getMyConnections() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.getMyConnections),
      headers: Helper.getHeaders(token, wid),
    );
    // print(ApiUrl.getMyConnections + ": " + response.body);
    Map myConnectionsResponse = json.decode(response.body);

    return myConnectionsResponse;
  }

  /// Return list of all people from the users MDO
  static Future<dynamic> getAllPeopleFromMDO() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String deptName = await _storage.read(key: Storage.deptName);

    Map data = {
      'size': 50,
      'offset': 0,
      'search': [
        {
          'field': 'employmentDetails.departmentName',
          'values': ['$deptName']
        }
      ]
    };

    String body = json.encode(data);

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.fromMyMDO),
        headers: Helper.postHeaders(token, wid),
        body: body);
    // print('${ApiUrl.fromMyMDO}: ' + response.body);
    Map allPeopleFromMDO = json.decode(response.body);

    return allPeopleFromMDO;
  }

  /// Post connection accept / reject status
  static Future<dynamic> postAcceptReject(
      String status, String connectionId, String connectionDepartment) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String deptName = await _storage.read(key: Storage.deptName);

    Map data = {
      'userIdFrom': '$wid',
      'userNameFrom': '$wid',
      'userDepartmentFrom': '$deptName',
      'userIdTo': '$connectionId',
      'userNameTo': '$connectionId',
      'userDepartmentTo': '$connectionDepartment',
      'status': '$status',

      // 'connectionId': '$connectionId',
      // 'status': '$status',
    };

    String body = json.encode(data);

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.connectionRejectAccept),
        headers: Helper.postHeaders(token, wid),
        body: body);
    // print("Connection request response $response");

    Map postAcceptRejectResponse = json.decode(response.body);

    // print("Connection request response ${postAcceptRejectResponse.toString()}");

    return postAcceptRejectResponse;
  }

  /// Return list of people as you may know as response
  static Future<dynamic> getUsersListByIds(List userIds) async {
    // print('getUsersListByIds...');
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    Map data = {
      "request": {
        "filters": {"userId": userIds}
      }
    };

    String body = json.encode(data);

    final response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.getUsersById),
        headers: Helper.postHeaders(token, wid),
        body: body);

    // print(ApiUrl.baseUrl + ApiUrl.getUsersById);
    // print(data);
    // print(response.body);
    Map usersList = json.decode(response.body);

    return usersList;
  }

  /// Return list of users with search text
  static Future<dynamic> getUsersListByText(String searchText) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.getUsersByText + searchText),
      headers: Helper.getHeaders(token, wid),
    );

    Map usersList = jsonDecode(response.body);

    return usersList;
  }

  /// Return list of connections requested by the user
  static Future<dynamic> getRequestedConnections() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);

    final response = await http.get(
      Uri.parse(ApiUrl.baseUrl + ApiUrl.getRequestedConnections),
      headers: Helper.getHeaders(token, wid),
    );
    // print('Test: ' + response.body.toString());

    return json.decode(response.body);
  }
}
