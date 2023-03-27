import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'dart:convert';
import 'dart:async';
// import './../../models/index.dart';
import './../../constants/index.dart';
import './../../util/helper.dart';

class VoteService {
  final String postUpVoteUrl = ApiUrl.baseUrl + ApiUrl.vote;
  final _storage = FlutterSecureStorage();

  Future<dynamic> postVote(mainPid, voteType) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String nodebbUserId = await _storage.read(key: Storage.nodebbUserId);

    // String cookie = await _storage.read(key: 'cookie');

    Map data;
    if (voteType == 'upVote') {
      data = {
        'delta': '1',
        '_uid': nodebbUserId,
      };
    } else {
      data = {
        'delta': '-1',
        '_uid': nodebbUserId,
      };
    }
    var body = json.encode(data);

    Response res = await post(
        Uri.parse(postUpVoteUrl + mainPid.toString() + '/vote'),
        headers: Helper.discussionPostHeaders(token, wid),
        body: body);
    // print(res.body);
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents['code'];
    } else {
      throw 'Can\'t post upvote.';
    }
  }

  Future<dynamic> deleteVote(mainPid) async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String nodebbUserId = await _storage.read(key: Storage.nodebbUserId);
    // String cookie = await _storage.read(key: 'cookie');

    Response res = await delete(
        Uri.parse(
            postUpVoteUrl + mainPid.toString() + '/vote?_uid=$nodebbUserId'),
        headers: Helper.discussionPostHeaders(token, wid));
    // print(res.body);
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      return contents['code'];
    } else {
      throw 'Can\'t delete upvote.';
    }
  }
}
