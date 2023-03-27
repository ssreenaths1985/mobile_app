class Category {
  final int cid;
  final String title;
  final String description;
  final int discussions;
  final int posts;

  Category({
    this.cid,
    this.title,
    this.description,
    this.discussions,
    this.posts,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      cid: json['cid'],
      title: json['name'],
      description: json['description'],
      discussions: json['totalTopicCount'],
      posts: json['totalPostCount'],
    );
  }
}
