import 'package:equatable/equatable.dart';

class DiscussionDetail extends Equatable {
  final dynamic timeStamp;
  final String title;
  final Map category;
  final int upVotes;
  final int downVotes;
  final int viewCount;
  final List posts;
  final int tid;
  final int mainPid;
  final int postCount;
  final List tags;
  final Map pagination;

  const DiscussionDetail({
    this.timeStamp,
    this.title,
    this.category,
    this.upVotes,
    this.downVotes,
    this.viewCount,
    this.posts,
    this.tid,
    this.mainPid,
    this.postCount,
    this.tags,
    this.pagination,
  });

  factory DiscussionDetail.fromJson(Map<String, dynamic> json) {
    return DiscussionDetail(
      timeStamp: json['timestamp'],
      title: json['titleRaw'],
      category: json['category'],
      upVotes: json['upvotes'],
      downVotes: json['downvotes'],
      viewCount: json['viewcount'],
      posts: json['posts'],
      tid: json['tid'],
      mainPid: json['mainPid'],
      postCount: json['postcount'],
      tags: json['tags'],
      pagination: json['pagination'],
    );
  }

  @override
  List<Object> get props => [
        timeStamp,
        title,
        category,
        upVotes,
        downVotes,
        viewCount,
        posts,
        tid,
        mainPid,
        postCount,
        tags,
        pagination,
      ];
}
