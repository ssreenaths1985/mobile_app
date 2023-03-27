import './../../models/index.dart';

const CAROUSEL_IMAGES = const [
  DiscussionCardCarousel(image: 'assets/img/1.png'),
  DiscussionCardCarousel(image: 'assets/img/2.png'),
  DiscussionCardCarousel(image: 'assets/img/3.png'),
  DiscussionCardCarousel(image: 'assets/img/4.png'),
  DiscussionCardCarousel(image: 'assets/img/5.png'),
  // DiscussionCardCarousel(image: 'assets/img/6.png'),
];

const CARAOUSEL_DISCUSSION = const [
  DiscussionCarouselCard(
    initials: 'SA',
    userName: 'Shreya Agarwal',
    time: '2h',
    discussionName: '10x Thinking',
    votes: 24,
    comments: 12,
    tags: ['planning', 'design'],
    showCarousel: true,
    showVideo: false,
  ),
  DiscussionCarouselCard(
      initials: 'PK',
      userName: 'Priyanka Kanojia',
      time: '3 months',
      discussionName: 'Agile methodology',
      votes: 12,
      comments: 9,
      tags: ['productivity'],
      showCarousel: false,
      showVideo: true),
];
