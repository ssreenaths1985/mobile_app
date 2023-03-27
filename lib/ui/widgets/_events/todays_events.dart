import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/_constants/color_constants.dart';
import '../../../util/faderoute.dart';
import '../../pages/_pages/events/event_details_page.dart';

class TodaysEvents extends StatefulWidget {
  final events;
  const TodaysEvents({Key key, this.events}) : super(key: key);

  @override
  State<TodaysEvents> createState() => _TodaysEventsState();
}

class _TodaysEventsState extends State<TodaysEvents> {
  _formatTime(time) {
    return time.substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Today's event",
              style: GoogleFonts.lato(
                color: AppColors.greys87,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          widget.events.length > 0
              ? Container(
                  height: 100,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 5, bottom: 15),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.events.length,
                    // itemCount: 1,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            FadeRoute(
                                page: EventDetailsPage(
                              eventId: widget.events[index].identifier,
                            ))),
                        child: Container(
                          margin: EdgeInsets.only(left: 16),
                          width: 175,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.greys87,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(4.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.events[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text(
                                  '${_formatTime(widget.events[index].startTime)} - ${_formatTime(widget.events[index].endTime)}',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  )),
                              widget.events[index].status != null
                                  ? Text(widget.events[index].status.toString(),
                                      style: GoogleFonts.lato(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ))
                                  : Center(),
                            ],
                          ),
                        ),
                      );
                      // CourseItem(
                      // course: _continueLearningcourses[index]);
                    },
                  ))
              : Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'No events',
                    style: GoogleFonts.lato(color: AppColors.greys87),
                  ),
                ),
        ],
      ),
    );
  }
}
