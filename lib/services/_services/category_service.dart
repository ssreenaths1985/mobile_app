import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import './../../constants/index.dart';
import './../../services/index.dart';
import './../../util/helper.dart';

class CategoryService extends BaseService {
  CategoryService(HttpClient client) : super(client);

  /// Return list of categories as response
  static Future<dynamic> getCategoryList() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    String wid = await _storage.read(key: Storage.wid);
    String nodebbUserId = await _storage.read(key: Storage.nodebbUserId);

    final response = await http.get(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.categoryList + '?_uid=$nodebbUserId'),
        headers: Helper.discussionGetHeaders(token, wid));

    Map categoryListResponse = json.decode(response.body);

    return categoryListResponse;
  }
}
