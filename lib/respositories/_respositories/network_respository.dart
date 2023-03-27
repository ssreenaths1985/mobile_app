import 'package:flutter/widgets.dart';
import './../../models/index.dart';
import './../../services/index.dart';
// import 'dart:developer' as developer;

class NetworkRespository with ChangeNotifier {
  ConnectionRequest _crList;
  ConnectionRequest _pymkList;
  List<Network> _allUsersList = [];
  ConnectionRequest _myConnectionsList;

  /// Process people you may know
  Future<dynamic> getPymkList() async {
    List _usersList;
    try {
      final pymkInfo = await NetworkService.getPeopleYouMayKnow();
      _pymkList = ConnectionRequest.fromJson(pymkInfo['result']);
      List userIds = [];
      // print(_pymkList.data.length);
      if (_pymkList.data.length > 0) {
        for (var data in _pymkList.data) {
          userIds.add(data['id']);
        }
        _usersList = await getUsersNames(userIds);
      }
    } catch (_) {
      return _;
    }
    return _usersList;
  }

  /// Process connection request
  Future<dynamic> getCrList() async {
    try {
      final crInfo = await NetworkService.getConnectionRequests();

      _crList = ConnectionRequest.fromJson(crInfo['result']);
    } catch (_) {
      return _;
    }

    return _crList;
  }

  /// Process connection request
  Future<List> getUsersNames(List userIds) async {
    List _usersList;
    try {
      var temp = await NetworkService.getUsersListByIds(userIds);
      // developer.log(temp['result']['response']['content'].toString());
      _usersList = temp['result']['response']['content'];
    } catch (_) {
      return _;
    }

    return _usersList;
  }

  /// Process established connections
  Future<dynamic> getEstablishedConnectionList() async {
    try {
      final connectionsInfo = await NetworkService.getMyConnections();

      _myConnectionsList =
          ConnectionRequest.fromJson(connectionsInfo['result']);
    } catch (_) {
      return _;
    }

    return _myConnectionsList;
  }

  /// Process all people from user MDO
  Future<dynamic> getAllUsersFromMDO() async {
    try {
      final allUsersInfo = await NetworkService.getAllPeopleFromMDO();

      _allUsersList = [
        for (final item in allUsersInfo['result']['data'])
          Network.fromJson(item)
      ];

      // _allUsersList = ConnectionRequestsModel.fromJson(allUsersInfo['result']);
    } catch (_) {
      return _;
    }

    return _allUsersList[0].results;
  }

  /// get all users by search text
  Future<List> getUsersByText(searchText) async {
    List _usersList;
    try {
      var usersInfo = await NetworkService.getUsersListByText(searchText);

      _usersList = usersInfo['result']['response']['content'];

      // _allUsersList = ConnectionRequestsModel.fromJson(allUsersInfo['result']);
      // print(_usersList.runtimeType.toString());
    } catch (_) {
      return _;
    }

    return _usersList;
  }

  Future<List<dynamic>> getRequestedConnections() async {
    List<dynamic> data;
    try {
      final response = await NetworkService.getRequestedConnections();

      data = response['result']['data'];
      // print('Data: ' + data.toString());
    } catch (_) {
      return _;
    }

    return data;
  }
}
