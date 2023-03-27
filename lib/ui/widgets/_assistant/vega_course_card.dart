import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import './../../../constants/index.dart';
// import './../../../models/_models/course_model.dart';

class VegaCourseCard extends StatefulWidget {
  final course;
  final bool displayProgress;
  final double progress;

  VegaCourseCard(
      {@required this.course, this.displayProgress = false, this.progress = 0});

  @override
  _VegaCourseCardState createState() => _VegaCourseCardState();
}

class _VegaCourseCardState extends State<VegaCourseCard> {
  // double _progress;

  @override
  void initState() {
    super.initState();
    if (widget.displayProgress) {
      _getCourseProgress();
    }
  }

  void _getCourseProgress() async {
    // print(widget.course.raw);
    // double progress = await Provider.of<LearnRepository>(context, listen: false).getCourseProgress(
    //     widget.course.raw['courseId'], widget.course.raw['batchId']);
    // setState(() {
    //   _progress = progress;
    // });
  }

  generateCourse() {
    var courseWidgets = Column(
      children: <Widget>[],
    );
    courseWidgets.children.add(ClipRRect(
        //  borderRadius: BorderRadius.all(Radius.circular(40)),
        child: widget.course['posterImage'] != null &&
                widget.course['posterImage'] != ''
            ? Stack(fit: StackFit.passthrough, children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  child: Image.network(
                    widget.course['posterImage'],
                    // fit: BoxFit.cover,
                    fit: BoxFit.fill,
                    width: 292,
                    height: 125,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/img/image_placeholder.jpg',
                      width: 292,
                      height: 125,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                widget.course['creatorIcon'] != null &&
                        widget.course['creatorIcon'] != ''
                    ? Positioned(
                        top: 16,
                        right: 16,
                        child: InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.course['creatorIcon']),
                                    fit: BoxFit.cover),
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(4.0)),
                                // shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey08,
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                    offset: Offset(
                                      3,
                                      3,
                                    ),
                                  ),
                                ],
                              ),
                              height: 48,
                              width: 48,
                            )),
                      )
                    : Positioned(
                        top: 16,
                        right: 16,
                        child: InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: widget.course['creatorLogo'] != '' &&
                                            widget.course['creatorLogo'] != null
                                        ? NetworkImage(
                                            widget.course['creatorLogo'])
                                        : AssetImage(
                                            'assets/img/igot_creator_icon.png'),
                                    fit: BoxFit.cover),
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(4.0)),
                                // shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey08,
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                    offset: Offset(
                                      3,
                                      3,
                                    ),
                                  ),
                                ],
                              ),
                              height: 48,
                              width: 48,
                            )),
                      )
              ])
            : widget.course['content'] != null
                ? Stack(fit: StackFit.passthrough, children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      child: Image.network(
                        widget.course['content']['posterImage'],
                        // fit: BoxFit.cover,
                        fit: BoxFit.fill,
                        width: 292,
                        height: 125,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/img/image_placeholder.jpg',
                          width: 292,
                          height: 125,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    widget.course['content']['creatorLogo'] != null
                        ? Positioned(
                            top: 16,
                            right: 16,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(widget
                                          .course['content']['creatorLogo']),
                                      fit: BoxFit.scaleDown),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                  // shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.grey08,
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                      offset: Offset(
                                        3,
                                        3,
                                      ),
                                    ),
                                  ],
                                ),
                                height: 48,
                                width: 48,
                              ),
                            ),
                          )
                        : Positioned(
                            top: 16,
                            right: 16,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/img/igot_creator_icon.png'),
                                      fit: BoxFit.scaleDown),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                  // shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.grey08,
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                      offset: Offset(
                                        3,
                                        3,
                                      ),
                                    ),
                                  ],
                                ),
                                height: 48,
                                width: 48,
                              ),
                            ),
                          )
                  ])
                : Image.asset(
                    'assets/img/image_placeholder.jpg',
                    width: 292,
                    height: 125,
                    fit: BoxFit.fitWidth,
                  )));
    courseWidgets.children.add(Container(
      height: 43,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        widget.course['name'] != null
            ? widget.course['name']
            : widget.course['courseName'],
        maxLines: 1,
        style: GoogleFonts.lato(
          color: AppColors.greys87,
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          height: 1.5,
        ),
      ),
    ));
    courseWidgets.children.add(Container(
      // constraints: BoxConstraints(minHeight: 60),
      height: 70,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        widget.course['description'] != null
            ? widget.course['description']
            : '',
        maxLines: 3,
        style: GoogleFonts.lato(
          color: AppColors.greys60,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          height: 1.5,
        ),
      ),
    ));
    // courseWidgets.children.add(Container(
    //   alignment: Alignment.topLeft,
    //   padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    //   child: Row(
    //     children: <Widget>[
    //       Container(
    //         margin: EdgeInsets.only(right: 10),
    //         padding: EdgeInsets.fromLTRB(20, 5, 20, 6),
    //         decoration: BoxDecoration(
    //           color: AppColors.grey08,
    //           border: Border.all(color: AppColors.grey08),
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20),
    //               topRight: Radius.circular(10),
    //               bottomLeft: Radius.circular(20),
    //               bottomRight: Radius.circular(10)),
    //         ),
    //         child: Text(
    //           'Tag 1',
    //           style: GoogleFonts.lato(
    //             color: AppColors.greys87,
    //             fontSize: 12.0,
    //           ),
    //         ),
    //       ),
    //       Container(
    //         margin: EdgeInsets.only(right: 10),
    //         padding: EdgeInsets.fromLTRB(20, 5, 20, 6),
    //         decoration: BoxDecoration(
    //           color: AppColors.grey08,
    //           border: Border.all(color: AppColors.grey08),
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20),
    //               topRight: Radius.circular(10),
    //               bottomLeft: Radius.circular(20),
    //               bottomRight: Radius.circular(10)),
    //         ),
    //         child: Text(
    //           'Tag 2',
    //           style: GoogleFonts.lato(
    //             color: AppColors.greys87,
    //             fontSize: 12.0,
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // ));
    courseWidgets.children.add(Container(
      child: Row(
        children: <Widget>[
          // Container(
          // Padding(
          //     padding: const EdgeInsets.only(left: 16, top: 5),
          //     child: Row(
          //       children: <Widget>[
          //         Padding(
          //           padding: const EdgeInsets.only(right: 5),
          //           child: Text(
          //             '0.0',
          //             style: GoogleFonts.lato(
          //               color: AppColors.primaryOne,
          //               fontWeight: FontWeight.w700,
          //               fontSize: 14.0,
          //             ),
          //           ),
          //         ),
          //         RatingBar.builder(
          //           initialRating: 0.0,
          //           minRating: 1,
          //           direction: Axis.horizontal,
          //           allowHalfRating: true,
          //           itemCount: 5,
          //           itemSize: 20,
          //           itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
          //           itemBuilder: (context, _) => Icon(
          //             Icons.star,
          //             color: AppColors.primaryOne,
          //           ),
          //           onRatingUpdate: (rating) {
          //             // print(rating);
          //           },
          //         )
          //       ],
          //     )),
          Spacer(),
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: <Widget>[
                  widget.course['duration'] != null
                      ? Text(
                          Helper.getTimeFormat(widget.course['duration']),
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                          ),
                        )
                      : Text(''),
                ],
              )),
        ],
      ),
    ));
    if (widget.displayProgress) {
      courseWidgets.children.add(Padding(
        padding: EdgeInsets.only(top: 19, bottom: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          child: LinearProgressIndicator(
            minHeight: 8,
            backgroundColor: AppColors.grey16,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryThree,
            ),
            value: widget.progress,
          ),
        ),
      ));
    }
    return courseWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292.0,
      // height: 250,
      margin: EdgeInsets.only(left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey08,
            blurRadius: 6.0,
            spreadRadius: 0,
            offset: Offset(
              3,
              3,
            ),
          ),
        ],
        border: Border.all(color: AppColors.grey08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: generateCourse(),
    );
  }
}
