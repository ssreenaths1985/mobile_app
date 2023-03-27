import 'package:flutter/material.dart';
import './../../../constants/index.dart';
import './../../../ui/widgets/index.dart';

class CarouselList extends StatefulWidget {
  @override
  _CarouselListState createState() => _CarouselListState();
}

class _CarouselListState extends State<CarouselList> {
  int currentPage = 0;
  // DiscussionCardCarousel discussionCardCarousel;

  Widget updateIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: CAROUSEL_IMAGES.map(
        (discussionCardCarousel) {
          var index = CAROUSEL_IMAGES.indexOf(discussionCardCarousel);
          return Container(
            width: 6.0,
            height: 6.0,
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index
                  ? AppColors.primaryThree
                  : Color(0xFFA6AEBD),
            ),
          );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: 248,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              itemBuilder: (context, index) {
                return Opacity(
                  opacity: currentPage == index ? 1.0 : 0.8,
                  child: CarouselCard(
                      discussionCardCarousel: CAROUSEL_IMAGES[index].image),
                );
              },
              itemCount: CAROUSEL_IMAGES.length,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: updateIndicators(),
          ),
        ],
      ),
    );
  }
}
