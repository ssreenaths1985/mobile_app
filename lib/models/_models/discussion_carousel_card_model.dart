class DiscussionCarouselCard {
  final String userName;
  final String initials;
  final String time;
  final String discussionName;
  final int votes;
  final int comments;
  final List tags;
  final bool showVideo;
  final bool showCarousel;

  const DiscussionCarouselCard(
      {this.userName,
      this.initials,
      this.time,
      this.discussionName,
      this.votes,
      this.comments,
      this.tags,
      this.showVideo,
      this.showCarousel});
}
