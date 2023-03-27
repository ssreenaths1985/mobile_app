import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import 'dart:convert';

class DiscussRepository with ChangeNotifier {
  List<Discuss> _recentDiscussions = [];
  List<Discuss> _discussions = [];
  List<Discuss> _userDiscussions = [];
  List<Discuss> _courseDiscussions = [];
  PaginationDiscuss _pageDetails;
  List<Discuss> _trendingDiscussions = [];
  List<TrendingTag> _trendingTags = [];
  DiscussionDetail _discussionDetail;
  var _replyDiscussionResponse;

  /// Process recent discussions
  Future<dynamic> getRecentDiscussions(int pageNo) async {
    try {
      final recentDiscussionInfo =
          await DiscussService.getRecentDiscussion(pageNo);

      _recentDiscussions = [
        for (final item in recentDiscussionInfo['topics'])
          Discuss.fromJson(item)
      ];
      var filtered = _recentDiscussions
          .where((element) => ((element.user['uid'] != 0 && element.cid != 1)));
      _recentDiscussions = filtered.toList();
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _recentDiscussions;
  }

  /// Process filtered discussions by category
  Future<dynamic> getFilteredDiscussionsByCategory(
      int categoryId, int pageNo) async {
    try {
      final recentDiscussionInfo =
          await DiscussService.getFilteredDiscussionsByCategory(
              categoryId, pageNo);

      _recentDiscussions = [
        for (final item in recentDiscussionInfo['topics'])
          Discuss.fromJson(item)
      ];
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _recentDiscussions;
  }

  /// Process filtered discussions by category
  Future<dynamic> getFilteredDiscussionsByTag(String tag, int pageNo) async {
    try {
      final recentDiscussionInfo =
          await DiscussService.getFilteredDiscussionsByTag(tag, pageNo);

      _recentDiscussions = [
        for (final item in recentDiscussionInfo['topics'])
          Discuss.fromJson(item)
      ];
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _recentDiscussions;
  }

  /// Process recent discussions
  Future<dynamic> getPopularDiscussions(int pageNo) async {
    try {
      final popularDiscussionInfo =
          await DiscussService.getPopularDiscussion(pageNo);

      _recentDiscussions = [
        for (final item in popularDiscussionInfo['topics'])
          Discuss.fromJson(item)
      ];
      var filtered = _recentDiscussions
          .where((element) => ((element.user['uid'] != 0 && element.cid != 1)));
      _recentDiscussions = filtered.toList();
    } catch (_) {
      return _;
    }

    return _recentDiscussions;
  }

  /// Process recent discussions
  Future<dynamic> getSavedDiscussions(int pageNo) async {
    try {
      final recentDiscussionInfo =
          await DiscussService.getSavedDiscussions(pageNo);

      _recentDiscussions = [
        for (final item in recentDiscussionInfo['posts']) Discuss.fromJson(item)
      ];
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _recentDiscussions;
  }

  /// Process my discussions
  Future<dynamic> getMyDiscussions() async {
    try {
      final recentDiscussionInfo = await DiscussService.getMyDiscussion();
      _recentDiscussions = [
        for (final item in recentDiscussionInfo['posts']) Discuss.fromJson(item)
      ];
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _recentDiscussions;
  }

  /// Process my best discussions
  Future<dynamic> getMyBestDiscussions() async {
    try {
      final recentDiscussionInfo = await DiscussService.getMyDiscussion();
      _discussions = [
        for (final item in recentDiscussionInfo['bestPosts'])
          Discuss.fromJson(item)
      ];
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _discussions;
  }

  /// Process my upvoted discussions
  Future<dynamic> getUpvotedDiscussions() async {
    try {
      final upvotedDiscussionInfo = await DiscussService.getUpvotedDiscussion();
      _discussions = [
        for (final item in upvotedDiscussionInfo['posts'])
          Discuss.fromJson(item)
      ];
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _discussions;
  }

  /// Process my downvoted discussions
  Future<dynamic> getDownvotedDiscussions() async {
    try {
      final downvotedDiscussionInfo =
          await DiscussService.getDownvotedDiscussion();
      _discussions = [
        for (final item in downvotedDiscussionInfo['posts'])
          Discuss.fromJson(item)
      ];
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _discussions;
  }

  /// Process my discussions
  Future<List<Discuss>> getCourseDiscussions(courseId) async {
    try {
      final courseDiscussions =
          await DiscussService.getDiscussionsOfCourse(courseId);

      _courseDiscussions = [
        for (final item in courseDiscussions['result'][0]['topics'])
          Discuss.fromJson(item)
      ];

      return _courseDiscussions;
    } catch (_) {
      return _;
    }
  }

  /// Process user discussions
  Future<dynamic> getUserDiscussions(userName) async {
    try {
      final userDiscussionInfo =
          await DiscussService.getUserDiscussion(userName);
      // print(wid.toString());
      if (userDiscussionInfo['latestPosts'] != null) {
        _userDiscussions = [
          for (final item in userDiscussionInfo['latestPosts'])
            Discuss.fromJson(item)
        ];
      }
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }
    // print(_userDiscussions.toString());
    return _userDiscussions;
  }

  /// Process user discussions
  Future<dynamic> getUserBestDiscussions(wid) async {
    try {
      final userDiscussionInfo = await DiscussService.getUserDiscussion(wid);
      if (userDiscussionInfo['bestPosts'] != null) {
        _userDiscussions = [
          for (final item in userDiscussionInfo['bestPosts'])
            Discuss.fromJson(item)
        ];
      }
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }

    return _userDiscussions;
  }

  /// Process discussions page counts
  Future<dynamic> getDiscussionPageCount(int pageNo) async {
    try {
      final discussionPageInfo =
          await DiscussService.getRecentDiscussion(pageNo);

      _pageDetails =
          PaginationDiscuss.fromJson(discussionPageInfo['pagination']);
    } catch (_) {
      return _;
    }

    return _pageDetails;
  }

  /// Process discussions by category page counts
  Future<dynamic> getDiscussionByCategoryPageCount(
      int categoryId, int pageNo) async {
    try {
      final discussionPageInfo =
          await DiscussService.getFilteredDiscussionsByCategory(
              categoryId, pageNo);

      _pageDetails =
          PaginationDiscuss.fromJson(discussionPageInfo['pagination']);
    } catch (_) {
      return _;
    }

    return _pageDetails;
  }

  /// Process discussions by category page counts
  Future<dynamic> getDiscussionByTagPageCount(String tag, int pageNo) async {
    try {
      final discussionPageInfo =
          await DiscussService.getFilteredDiscussionsByTag(tag, pageNo);

      _pageDetails =
          PaginationDiscuss.fromJson(discussionPageInfo['pagination']);
    } catch (_) {
      return _;
    }

    return _pageDetails;
  }

  /// Process discussions page counts
  Future<dynamic> getPopularDiscussionPageCount(int pageNo) async {
    try {
      final discussionPageInfo =
          await DiscussService.getPopularDiscussion(pageNo);

      _pageDetails =
          PaginationDiscuss.fromJson(discussionPageInfo['pagination']);
    } catch (_) {
      return _;
    }

    return _pageDetails;
  }

  /// Process discussions page counts
  Future<dynamic> getSavedDiscussionPageCount(int pageNo) async {
    try {
      final discussionPageInfo =
          await DiscussService.getSavedDiscussions(pageNo);

      _pageDetails =
          PaginationDiscuss.fromJson(discussionPageInfo['pagination']);
    } catch (_) {
      return _;
    }

    return _pageDetails;
  }

  /// Process trending discussions
  Future<dynamic> getTrendingDiscussions(pageNo) async {
    try {
      var trendingDiscussionInfo =
          await DiscussService.getTrendingDiscussions(pageNo);
      trendingDiscussionInfo['topics'][0]['topicCount'] =
          trendingDiscussionInfo['topicCount'];
      trendingDiscussionInfo['topics'][0]['nextStart'] =
          trendingDiscussionInfo['nextStart'];
      _trendingDiscussions = [
        for (final item in trendingDiscussionInfo['topics'])
          Discuss.fromJson(
            item,
          )
      ];
    } catch (_) {
      return _;
    }

    return _trendingDiscussions;
  }

  /// Process trending discussions
  Future<dynamic> getTrendingTags() async {
    try {
      final trendingTagsInfo = await DiscussService.getTrendingTags();

      _trendingTags = [
        for (final item in trendingTagsInfo['tags']) TrendingTag.fromJson(item)
      ];
    } catch (_) {
      return _;
    }

    return _trendingTags;
  }

  Future<dynamic> getDiscussionById(tid, pageNo, sort) async {
    try {
      final discussionDetailInfo =
          await DiscussService.getDiscussionDetail(tid, pageNo, sort);

      _discussionDetail = DiscussionDetail.fromJson(discussionDetailInfo);
    } catch (_) {
      return _;
    }

    return _discussionDetail;
  }

  Future<dynamic> replyDiscussion(tid, content) async {
    try {
      final discussionDetailInfo = await DiscussService.postReply(tid, content);

      _replyDiscussionResponse = discussionDetailInfo['code'];
      // print(" Reply to a discussion response code: ${discussionDetailInfo['code']}");
    } catch (_) {
      return _;
    }

    return _replyDiscussionResponse;
  }

  Future<dynamic> replyComment(pid, tid, content) async {
    try {
      final discussionDetailInfo =
          await DiscussService.postComment(pid, tid, content);

      _replyDiscussionResponse = discussionDetailInfo['code'];
    } catch (_) {
      return _;
    }

    return _replyDiscussionResponse;
  }

  Future<dynamic> saveDiscussion(
      int tid, int cid, String title, String content, List<String> tags) async {
    try {
      final discussionDetailInfo =
          await DiscussService.postDiscussion(tid, cid, title, content, tags);

      _replyDiscussionResponse = discussionDetailInfo['code'];
    } catch (_) {
      return _;
    }

    return _replyDiscussionResponse;
  }

  /// Process recent discussions
  Future<dynamic> bookmarkDiscussion(int pid, bool status) async {
    try {
      Response res = await DiscussService.bookmarkDiscussion(pid, status);
      if (res.statusCode == 200) {
        var contents = jsonDecode(res.body);
        return contents['code'];
      } else {
        throw 'Can\'t bookmark.';
      }
      // _recentDiscussions[0]['topicCount'] = recentDiscussionInfo['topicCount'];
    } catch (_) {
      return _;
    }
  }

  Future<dynamic> deleteDiscussion(int pid) async {
    var _deleteDiscussionResponse;
    try {
      final statusInfo = await DiscussService.deleteDiscussion(pid);
      _deleteDiscussionResponse = statusInfo['code'];
    } catch (_) {
      return _;
    }
    return _deleteDiscussionResponse;
  }
}
