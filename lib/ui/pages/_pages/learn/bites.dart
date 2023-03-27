import 'package:flutter/material.dart';
import './../../../../constants/index.dart';
import './../../../widgets/index.dart';

class BitesPage extends StatefulWidget {
  @override
  _BitesPageState createState() => _BitesPageState();
}

class _BitesPageState extends State<BitesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 100),
        child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: CARAOUSEL_DISCUSSION
                .map((discussioncarouselcard) => InkWell(
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 3),
                        child: Container(
                            width: 100.0,
                            child: DiscussCarouselCard(
                              userName: discussioncarouselcard.userName,
                              initials: discussioncarouselcard.initials,
                              time: discussioncarouselcard.time,
                              discussionName:
                                  discussioncarouselcard.discussionName,
                              votes: discussioncarouselcard.votes,
                              comments: discussioncarouselcard.comments,
                              tags: discussioncarouselcard.tags,
                              showCarousel: discussioncarouselcard.showCarousel,
                              showVideo: discussioncarouselcard.showVideo,
                              // showVideo: true,
                            )),
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
