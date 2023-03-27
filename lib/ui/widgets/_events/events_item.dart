import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:intl/intl.dart';

class EventsItem extends StatelessWidget {
  final event;
  const EventsItem({Key key, this.event}) : super(key: key);

  formateDate(date) {
    return DateFormat("MMMM d, y").format(DateTime.parse(date));
  }

  formateTime(time) {
    return time.substring(0, 5);
  }

  generateEvent() {
    var eventWidgets = Column(
      children: <Widget>[],
    );
    eventWidgets.children.add(ClipRRect(
        //  borderRadius: BorderRadius.all(Radius.circular(40)),
        child: Stack(fit: StackFit.passthrough, children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        child: event.eventIcon != null
            ? (Image.network(
                event.eventIcon,
                fit: BoxFit.cover,
                // fit: BoxFit.fill,
                width: double.infinity,
                height: 150,
              ))
            : Image.asset(
                'assets/img/image_placeholder.jpg',
                width: double.infinity,
                height: 150,
                fit: BoxFit.fitWidth,
              ),
      ),
      // Positioned(
      //   top: 16,
      //   right: 16,
      //   child: InkWell(
      //       onTap: () {},
      //       child: Container(
      //         margin: EdgeInsets.all(8),
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //               image: AssetImage('assets/img/igot_icon.png'),
      //               fit: BoxFit.cover),
      //           color: Colors.white,
      //           borderRadius: BorderRadius.all(const Radius.circular(4.0)),
      //           // shape: BoxShape.circle,
      //           boxShadow: [
      //             BoxShadow(
      //               color: AppColors.grey08,
      //               blurRadius: 3,
      //               spreadRadius: 0,
      //               offset: Offset(
      //                 3,
      //                 3,
      //               ),
      //             ),
      //           ],
      //         ),
      //         height: 48,
      //         width: 48,
      //       )),
      // )
    ])));
    eventWidgets.children.add(
      Container(
        // height: 24,
        // width: 90,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
        alignment: Alignment.topLeft,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(color: AppColors.grey08),
        //   borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        //   // shape: BoxShape.circle,
        // ),
        child: Text(
          event.source != null ? event.source : 'iGOT',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(
            color: AppColors.greys60,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
    eventWidgets.children.add(Container(
      height: 43,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        event.name != null ? event.name : '',
        maxLines: 1,
        style: GoogleFonts.lato(
          color: AppColors.greys87,
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          height: 1.5,
        ),
      ),
    ));
    eventWidgets.children.add(Container(
      // constraints: BoxConstraints(minHeight: 60),
      height: 30,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        formateDate(event.startDate) + ' ' + formateTime(event.startTime),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.lato(
          color: AppColors.primaryThree,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          height: 1.5,
        ),
      ),
    ));
    eventWidgets.children.add(Container(
      // constraints: BoxConstraints(minHeight: 60),
      height: 50,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        event.description != null ? event.description : '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.lato(
          color: AppColors.greys60,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          height: 1.5,
        ),
      ),
    ));
    eventWidgets.children.add(Container(
      // constraints: BoxConstraints(minHeight: 60),
      // height: 30,
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        '+' + event.creatorDetails.length.toString(),
        style: GoogleFonts.lato(
          color: AppColors.primaryThree,
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
    // eventWidgets.children.add(Container(
    //   child: Row(
    //     children: <Widget>[
    //       // Container(
    //       Padding(
    //           padding: const EdgeInsets.only(left: 16, top: 5),
    //           child: Row(
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.only(right: 5),
    //                 child: Text(
    //                   widget.course.rating.toString(),
    //                   style: GoogleFonts.lato(
    //                     color: AppColors.primaryOne,
    //                     fontWeight: FontWeight.w700,
    //                     fontSize: 14.0,
    //                   ),
    //                 ),
    //               ),
    //               RatingBar.builder(
    //                 initialRating: widget.course.rating,
    //                 minRating: 1,
    //                 direction: Axis.horizontal,
    //                 allowHalfRating: true,
    //                 itemCount: 5,
    //                 itemSize: 20,
    //                 itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
    //                 itemBuilder: (context, _) => Icon(
    //                   Icons.star,
    //                   color: AppColors.primaryOne,
    //                 ),
    //                 onRatingUpdate: (rating) {
    //                   // print(rating);
    //                 },
    //               )
    //             ],
    //           )),
    //       Spacer(),
    //       Padding(
    //           padding: const EdgeInsets.only(right: 20),
    //           child: Row(
    //             children: <Widget>[
    //               widget.course.duration != null
    //                   ? Text(
    //                       Helper.getTimeFormat(widget.course.duration),
    //                       style: GoogleFonts.lato(
    //                         color: AppColors.greys60,
    //                         fontWeight: FontWeight.w700,
    //                         fontSize: 14.0,
    //                       ),
    //                     )
    //                   : Text(''),
    //             ],
    //           )),
    //     ],
    //   ),
    // ));

    return eventWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 350.0,
      // margin: EdgeInsets.only(left: 10, bottom: 10),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
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
      child: generateEvent(),
    );
  }
}
