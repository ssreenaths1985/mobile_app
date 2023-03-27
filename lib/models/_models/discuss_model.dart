import 'package:equatable/equatable.dart';

class Discuss extends Equatable {
  final Map user;
  final dynamic timeStamp;
  final String title;
  final Map category;
  final int upVotes;
  final int downVotes;
  final int tid;
  final List tags;
  final int topicCount;
  final int nextStart;
  final int cid;

  const Discuss(
      {this.user,
      this.timeStamp,
      this.title,
      this.category,
      this.upVotes,
      this.downVotes,
      this.tid,
      this.tags,
      this.topicCount,
      this.nextStart,
      this.cid});

  factory Discuss.fromJson(Map<String, dynamic> json) {
    return Discuss(
        user: json['user'],
        timeStamp: json['timestamp'],
        title: json['titleRaw'] != null
            ? json['titleRaw']
            : json['topic']['title'],
        category: json['category'],
        upVotes: json['upvotes'],
        downVotes: json['downvotes'],
        tid: json['tid'],
        tags: json['tags'],
        topicCount: json['topicCount'],
        nextStart: json['nextStart'],
        cid: json['cid']);
  }

  @override
  List<Object> get props => [
        user,
        timeStamp,
        title,
        category,
        upVotes,
        downVotes,
        tid,
        tags,
        topicCount,
        nextStart,
        cid
      ];
}
