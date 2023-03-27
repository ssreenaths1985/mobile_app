import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_learn/author.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/_models/event_detail_model.dart';

class EventOverview extends StatefulWidget {
  final EventDetail eventDetail;
  EventOverview({Key key, this.eventDetail}) : super(key: key);

  @override
  _EventOverviewState createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
  bool isBigDescription = true;

  bool trimText = false;

  int _maxLength = 100;

  @override
  void initState() {
    super.initState();
    if (widget.eventDetail.description != null) {
      if (widget.eventDetail.description.length > _maxLength) {
        trimText = true;
      }
    }
    // DateTime parseDt = DateTime.parse(widget.course['lastUpdatedOn']);
    // formattedDate = DateFormat.yMMMd().format(parseDt);
    // developer.log('keywords: ' + widget.course['additionalFields'].toString());
  }

  formateDate(date) {
    return DateFormat("MMMM d, y").format(DateTime.parse(date));
  }

  formateTime(time) {
    return time.substring(0, 5);
  }

  isEventCompleted() {
    int timestampNow = DateTime.now().millisecondsSinceEpoch;
    String start = widget.eventDetail.startDate +
        ' ' +
        formateTime(widget.eventDetail.startTime);
    DateTime startDate = DateTime.parse(start);
    int timestampStartEvent = startDate.microsecondsSinceEpoch;
    double eventStartTime = timestampStartEvent / 1000;
    String expiry = widget.eventDetail.endDate +
        ' ' +
        formateTime(widget.eventDetail.endTime);
    DateTime expireDate = DateTime.parse(expiry);
    int timestampExpireEvent = expireDate.microsecondsSinceEpoch;
    double eventExpireTime = timestampExpireEvent / 1000;
    if (timestampNow > eventExpireTime) {
      return EnglishLang.completed;
    } else if (timestampNow <= eventExpireTime &&
        timestampNow >= eventStartTime) {
      return EnglishLang.started;
    } else
      return EnglishLang.notStarted;
  }

  void _toogleReadMore() {
    setState(() {
      trimText = !trimText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(16.0),
          height: 40,
          child: ButtonTheme(
            child: OutlinedButton(
              onPressed: () async {
                if (widget.eventDetail.registrationLink != null &&
                    isEventCompleted() == EnglishLang.started) {
                  await launchUrl(
                      Uri.parse(widget.eventDetail.registrationLink),
                      mode: LaunchMode.externalApplication);
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: isEventCompleted() == EnglishLang.started
                    ? AppColors.primaryThree
                    : Colors.white,
                side: BorderSide(width: 1, color: AppColors.primaryThree),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                // onSurface: Colors.grey,
              ),
              child: Text(
                isEventCompleted() == EnglishLang.completed
                    ? EnglishLang.eventIsCompleted
                    : isEventCompleted() == EnglishLang.notStarted
                        ? EnglishLang.eventIsNotCompleted
                        : EnglishLang.attendLiveEvent,
                style: GoogleFonts.lato(
                    color: isEventCompleted() == EnglishLang.started
                        ? Colors.white
                        : AppColors.primaryThree,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
          child: Text(
            EnglishLang.atAGlance,
            style: GoogleFonts.montserrat(
                decoration: TextDecoration.none,
                color: AppColors.greys87,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(bottom: 15, top: 4),
          padding: const EdgeInsets.fromLTRB(30, 15, 20, 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    formateDate(widget.eventDetail.startDate),
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.none,
                        color: AppColors.greys87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    formateTime(widget.eventDetail.startTime) +
                        ' - ' +
                        formateTime(widget.eventDetail.endTime),
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.none,
                        color: AppColors.primaryThree,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    EnglishLang.eventType,
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.none,
                        color: AppColors.primaryThree,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.eventDetail.eventType,
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.none,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    EnglishLang.hostedBy,
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.none,
                        color: AppColors.primaryThree,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.eventDetail.source,
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.none,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    EnglishLang.lastUpdatedOn +
                        formateDate(widget.eventDetail.lastUpdatedOn),
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.none,
                        color: AppColors.greys60,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 15, top: 4),
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  EnglishLang.description,
                  style: GoogleFonts.montserrat(
                      decoration: TextDecoration.none,
                      color: AppColors.greys87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  (trimText &&
                          widget.eventDetail.description.length > _maxLength)
                      ? widget.eventDetail.description
                              .substring(0, _maxLength - 1) +
                          '...'
                      : widget.eventDetail.description,
                  style: GoogleFonts.montserrat(
                      decoration: TextDecoration.none,
                      color: AppColors.greys87,
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400),
                ),
              ),
              widget.eventDetail.description != null
                  ? (widget.eventDetail.description.length > _maxLength)
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: InkWell(
                                onTap: () => _toogleReadMore(),
                                child: Text(
                                  trimText
                                      ? EnglishLang.readMore
                                      : EnglishLang.showLess,
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primaryThree,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                          ))
                      : Center()
                  : Center()
            ])),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 10, 20),
                child: Text(
                  EnglishLang.presenters,
                  style: GoogleFonts.montserrat(
                      decoration: TextDecoration.none,
                      color: AppColors.greys87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              // for (int j = 0; j < 1; j++)
              //   Author(
              //       name: widget.course['creatorContacts'][j]['name'],
              //       designation: 'Author'),
              // Author(
              //     name: 'Jayasree Talpade',
              //
              //  designation: 'Joint Secretary at Tourism'),
              Container(
                height: widget.eventDetail.creatorDetails.length * 85.0,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.eventDetail.creatorDetails.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Author(
                        name: widget.eventDetail.creatorDetails[index]['name'],
                        designation: 'Host');
                  },
                ),
              )
            ])),
        Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Text(
                  EnglishLang.agenda,
                  style: GoogleFonts.montserrat(
                      decoration: TextDecoration.none,
                      color: AppColors.greys87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Text(
                  widget.eventDetail.learningObjective,
                  style: GoogleFonts.montserrat(
                      decoration: TextDecoration.none,
                      color: AppColors.greys87,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ])),
      ],
    ));
  }
}
