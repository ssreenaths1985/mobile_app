import 'package:flutter/widgets.dart';
import './../../services/_services/knowledge_resource_service.dart';
import '../../models/index.dart';
import 'package:http/http.dart';
import 'dart:convert';

class KnowledgeResourceRespository with ChangeNotifier {
  /// Process all people from user MDO
  Future<List<KnowledgeResource>> getKnowledgeResources() async {
    List<KnowledgeResource> knowledgeResources;

    try {
      final response = await KnowledgeResourceService.getKnowledgeResources();
      knowledgeResources = [
        for (final item in response['responseData'])
          KnowledgeResource.fromJson(item)
      ];
    } catch (_) {
      return _;
    }

    return knowledgeResources;
  }

  Future<List<Position>> getAllPositions() async {
    List<Position> positions;

    try {
      final response = await KnowledgeResourceService.getAllPositions();
      // print(response.toString());
      positions = [
        for (final item in response['responseData']) Position.fromJson(item)
      ];
    } catch (_) {
      return _;
    }
    // print(positions);
    return positions;
  }

  Future<dynamic> bookmarkKnowledgeResource(String id, bool status) async {
    try {
      Response res =
          await KnowledgeResourceService.bookmarkKnowledgeResource(id, status);
      if (res.statusCode == 200) {
        var contents = jsonDecode(res.body);
        contents = contents['statusInfo']['statusCode'];
        // print(contents);
        return contents;
      } else {
        throw 'Can\'t bookmark.';
      }
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }
  }

  Future<List<KnowledgeResource>> filerByPositionKnowledgeResource(
      String id) async {
    List<KnowledgeResource> knowledgeResources;
    try {
      final response =
          await KnowledgeResourceService.filerByPositionKnowledgeResource(id);
      knowledgeResources = [
        for (final item in response['responseData'])
          KnowledgeResource.fromJson(item)
      ];
    } catch (_) {
      return _;
    }

    return knowledgeResources;
  }
}
