import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'dart:convert';
import 'dart:async';
import './../../models/index.dart';
import './../../constants/index.dart';
import './../../util/helper.dart';

class SuggestionService {
  final String suggestionsUrl = ApiUrl.baseUrl + ApiUrl.getSuggestions;
  final _storage = FlutterSecureStorage();

  Future<List<Suggestion>> getSuggestions() async {
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String department = await _storage.read(key: Storage.deptName);

    Map data = {
      'size': 50,
      'offset': 0,
      'search': [
        {
          'field': 'employmentDetails.departmentName',
          'values': ['$department']
        }
      ]
    };
    var body = json.encode(data);

    Response res = await post(Uri.parse(suggestionsUrl),
        headers: Helper.postHeaders(token, wid), body: body);

    // print('suggestion: ' + res.body.toString());
    if (res.statusCode == 200) {
      var contents = jsonDecode(res.body);
      // print(contents);
      List<dynamic> body = contents['result']['data'][0]['results'];
      // print(body.length);
      List<Suggestion> suggestions = body
          .map(
            (dynamic item) => Suggestion.fromJson(item),
          )
          .toList();
      return suggestions;
    } else {
      throw 'Can\'t get suggestions.';
    }
  }
}
