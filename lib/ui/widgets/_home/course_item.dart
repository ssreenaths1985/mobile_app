import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:karmayogi_mobile/localization/index.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import './../../../constants/index.dart';
import './../../../models/_models/course_model.dart';

class CourseItem extends StatefulWidget {
  final Course course;
  final bool displayProgress;
  final double progress;
  final bool isProgram;
  final bool isMandatory;
  final bool isVertical;
  final bool isFeatured;

  CourseItem(
      {@required this.course,
      this.displayProgress = false,
      this.progress = 0,
      this.isProgram = false,
      this.isMandatory = false,
      this.isVertical = false,
      this.isFeatured = false});

  @override
  _CourseItemState createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  @override
  void initState() {
    super.initState();
  }

  generateCourse() {
    var imageExtension;
    if (widget.course.appIcon != null) {
      imageExtension =
          widget.course.appIcon.substring(widget.course.appIcon.length - 3);
    }
    var imgExtension;
    if (widget.course.raw['content'] != null &&
        widget.course.raw['content']['posterImage'] != null) {
      imgExtension = widget.course.raw['content']['posterImage']
          .substring(widget.course.raw['content']['posterImage'].length - 3);
    }
    var courseWidgets = Column(
      children: <Widget>[],
    );
    courseWidgets.children.add(ClipRRect(
        //  borderRadius: BorderRadius.all(Radius.circular(40)),
        child: widget.course.appIcon != null
            ? Stack(fit: StackFit.passthrough, children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    child: imageExtension != 'svg'
                        ? Image.network(
                            widget.course.appIcon,
                            // fit: BoxFit.cover,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 125,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/img/image_placeholder.jpg',
                              width: double.infinity,
                              height: 125,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : Image.asset(
                            'assets/img/image_placeholder.jpg',
                            width: double.infinity,
                            height: 125,
                            fit: BoxFit.fitWidth,
                          )),
                (widget.course.creatorIcon != null && !widget.isFeatured)
                    ? Positioned(
                        top: 16,
                        right: 16,
                        child: InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(widget.course.creatorIcon),
                                    fit: BoxFit.fitWidth),
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
                    : !widget.isFeatured
                        ? Positioned(
                            top: 16,
                            right: 16,
                            child: InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: widget.course.creatorLogo != ''
                                            ? NetworkImage(
                                                widget.course.creatorLogo)
                                            : AssetImage(
                                                'assets/img/igot_creator_icon.png'),
                                        fit: BoxFit.fitWidth),
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
                        : Center()
              ])
            : widget.course.raw['content'] != null
                ? Stack(fit: StackFit.passthrough, children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      child: widget.course.raw['content']['posterImage'] != null
                          ? imgExtension != 'svg'
                              ? Image.network(
                                  Helper.convertToPortalUrl(widget
                                      .course.raw['content']['posterImage']),
                                  // fit: BoxFit.cover,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: 125,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/img/image_placeholder.jpg',
                                    width: double.infinity,
                                    height: 125,
                                    fit: BoxFit.fitWidth,
                                  ),
                                )
                              : Image.asset(
                                  'assets/img/image_placeholder.jpg',
                                  width: double.infinity,
                                  height: 125,
                                  fit: BoxFit.fitWidth,
                                )
                          : Image.asset(
                              'assets/img/image_placeholder.jpg',
                              width: double.infinity,
                              height: 125,
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                    (widget.course.raw['content']['creatorLogo'] != null &&
                            !widget.isFeatured)
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
                                          Helper.convertToPortalUrl(widget
                                              .course
                                              .raw['content']['creatorLogo'])),
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
                        : !widget.isFeatured
                            ? Positioned(
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
                                          fit: BoxFit.fitWidth),
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
                            : Center()
                  ])
                : Image.asset(
                    'assets/img/image_placeholder.jpg',
                    width: double.infinity,
                    height: 125,
                    fit: BoxFit.fitWidth,
                  )));
    courseWidgets.children.add(
      Container(
        // height: 24,
        // width: 90,
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.topLeft,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(color: AppColors.grey08),
        //   borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        //   // shape: BoxShape.circle,
        // ),
        child: Center(
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // assets/img/course_icon.svg
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SvgPicture.asset(
                  'assets/img/course_icon.svg',
                  width: 16.0,
                  height: 16.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  widget.course.contentType != null
                      ? widget.course.contentType.toUpperCase()
                      : '',
                  style: GoogleFonts.lato(
                    color: AppColors.greys60,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    courseWidgets.children.add(Container(
      height: 43,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        widget.course.name != null
            ? widget.course.name
            : widget.course.raw['courseName'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
        widget.course.description != null ? widget.course.description : '',
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
    (widget.isMandatory == true &&
            widget.course.contentType == EnglishLang.mandatoryCourseGoal)
        ? courseWidgets.children.add(Container(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
              child: Text(
                "Deadline: " +
                    ((widget.course.raw['batch'] != null &&
                            widget.course.raw['batch']['endDate'] != null)
                        ? DateFormat.yMMMd()
                            .format(DateTime.parse(
                                widget.course.raw['batch']['endDate']))
                            .toString()
                        : ''),
                style: GoogleFonts.lato(
                  color: AppColors.greys60,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
            )))
        : Center();
    courseWidgets.children.add(Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Container(
          // Padding(
          //     padding: const EdgeInsets.only(left: 16, top: 5),
          //     child: Row(
          //       children: <Widget>[
          //         Padding(
          //           padding: const EdgeInsets.only(right: 5),
          //           child: Text(
          //             widget.course.rating.toString(),
          //             style: GoogleFonts.lato(
          //               color: AppColors.primaryOne,
          //               fontWeight: FontWeight.w700,
          //               fontSize: 14.0,
          //             ),
          //           ),
          //         ),
          //         RatingBar.builder(
          //           initialRating: widget.course.rating,
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
          //         ),
          //       ],
          //     )),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 20, top: 5),
              child: Row(
                children: <Widget>[
                  widget.course.duration != null
                      ? Text(
                          widget.isFeatured
                              ? ('LEARNING HOURS: \t \t' +
                                  Helper.getTimeFormat(widget.course.duration))
                              : Helper.getTimeFormat(widget.course.duration),
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontWeight: FontWeight.w700,
                            fontSize: widget.isFeatured ? 12 : 14.0,
                          ),
                        )
                      : (widget.course.raw['content'] != null &&
                              widget.course.raw['content']['duration'] != null)
                          ? Text(
                              Helper.getTimeFormat(
                                  widget.course.raw['content']['duration']),
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                              ),
                            )
                          : Text(''),
                ],
              )),
          Spacer(),
          widget.course.raw['completionPercentage'] != null
              ? Container(
                  padding: EdgeInsets.only(right: 16, top: 5),
                  child: Text(
                      widget.course.raw['completionPercentage'].toString() +
                          ' %',
                      style: GoogleFonts.lato(
                        color: AppColors.greys60,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                      )),
                )
              : Center(),
        ],
      ),
    ));
    if (widget.displayProgress) {
      courseWidgets.children.add(Padding(
        padding: EdgeInsets.only(top: 22, bottom: 0),
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
    // print(widget.course.raw['content']['duration']);
    return Container(
      width: 292.0,
      // height: 270.0,
      margin: widget.isVertical
          ? EdgeInsets.only(bottom: 24)
          : EdgeInsets.only(left: 10, bottom: 10),
      padding: EdgeInsets.only(bottom: widget.isVertical ? 16 : 0),
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
