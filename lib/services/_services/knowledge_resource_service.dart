import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import './../../constants/index.dart';
import './../../services/index.dart';
import './../../util/helper.dart';
// import 'dart:developer' as developer;

class KnowledgeResourceService extends BaseService {
  KnowledgeResourceService(HttpClient client) : super(client);

  /// Return list of people as you may know as response
  static Future<dynamic> getKnowledgeResources() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: 'wid');

    final response = await http.get(
      Uri.parse(ApiUrl.fracBaseUrl + ApiUrl.getKnowledgeResources),
      headers: Helper.knowledgeResourceGetHeaders(token),
    );
    // developer.log(Helper.knowledgeResourceGetHeaders(token).toString());
    // print(ApiUrl.knowledgeResourceBaseURL +
    //     ApiUrl.getKnowledgeResources +
    //     ": " +
    //     response.body);
    Map knowledgeResources = json.decode(response.body);

    return knowledgeResources;
  }

  // Returns all positions available
  static Future<dynamic> getAllPositions() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: 'wid');

    final response = await http.get(
      Uri.parse(ApiUrl.fracBaseUrl + ApiUrl.getKnowledgeResourcesPositions),
      headers: Helper.knowledgeResourceGetHeaders(token),
    );

    Map positions = json.decode(response.body);

    return positions;
  }

  static Future<dynamic> bookmarkKnowledgeResource(id, status) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: 'wid');
    String url = ApiUrl.fracBaseUrl + ApiUrl.bookmarkKnowledgeResource;
    Map<String, dynamic> data = {
      'id': id,
      'type': 'KNOWLEDGERESOURCE',
      'bookmark': status,
    };
    var body = json.encode(data);
    Response response;
    response = await post(Uri.parse(url),
        headers: Helper.knowledgeResourcePostHeaders(token), body: body);
    // print(ApiUrl.knowledgeResourceBaseURL +
    //     ApiUrl.bookmarkKnowledgeResource +
    //     ':' +
    //     response.body);
    return response;
  }

  static Future<dynamic> filerByPositionKnowledgeResource(id) async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: Storage.authToken);
    // String wid = await _storage.read(key: 'wid');
    String url = ApiUrl.fracBaseUrl + ApiUrl.knowledgeResourcesFilterByPosition;
    Map<String, dynamic> data = {
      "type": "KNOWLEDGERESOURCE",
      "mappings": [
        {"type": "POSITION", "id": id, "relation": "parent"}
      ]
    };
    var body = json.encode(data);
    Response response;
    response = await post(Uri.parse(url),
        headers: Helper.knowledgeResourcePostHeaders(token), body: body);
    Map knowledgeResources = json.decode(response.body);
    // print(response.body);
    return knowledgeResources;
  }
}
