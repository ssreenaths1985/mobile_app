import 'package:flutter/material.dart';
import './../../../constants/index.dart';

// ignore: must_be_immutable
class CarouselCard extends StatelessWidget {
  String discussionCardCarousel;
  CarouselCard({this.discussionCardCarousel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
      child: Center(
          child: Container(
        decoration: BoxDecoration(
          color: AppColors.white70,
          image: DecorationImage(
              image: AssetImage(discussionCardCarousel), fit: BoxFit.cover),
        ),
      )),
    );
  }
}
