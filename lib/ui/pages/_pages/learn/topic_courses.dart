import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/services/index.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/learn/course_details_page.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../localization/_langs/english_lang.dart';

class TopicCourses extends StatefulWidget {
  static const route = AppUrl.coursesInCompetency;
  final String identifier;
  final String name;
  final topic;

  TopicCourses(
    this.identifier,
    this.name,
    this.topic,
  );

  @override
  _TopicCoursesState createState() => _TopicCoursesState();
}

class _TopicCoursesState extends State<TopicCourses> {
  final TelemetryService telemetryService = TelemetryService();
  List<Course> _listOfCourses = [];
  List<Course> _filteredListOfCourses = [];
  bool _pageInitilized = false;

  String _identifier;
  String _name;
  Map _topic;

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _identifier = widget.identifier;
    _name = widget.name;
    _topic = widget.topic;
    _generateTelemetryData();
    // print('Topic: ${widget.topic}');
    // _getListOfCompetencies();
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData1 = Telemetry.getImpressionTelemetryEvent(
      deviceIdentifier,
      userId,
      departmentId,
      TelemetryPageIdentifier.topicCoursesPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.topicCoursesPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  void _generateInteractTelemetryData(String contentId) async {
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        TelemetryPageIdentifier.topicCoursesPageId +
            '_' +
            TelemetrySubType.courseCard,
        userSessionId,
        messageIdentifier,
        contentId,
        contentId);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<dynamic> _getTopicCourses() async {
    _listOfCourses = await Provider.of<LearnRepository>(context, listen: false)
        .getCoursesByTopic(_identifier);
    if (!_pageInitilized) {
      setState(() {
        _filteredListOfCourses = _listOfCourses;
        _pageInitilized = true;
      });
    }
    return _listOfCourses;
  }

  void _sortCourses(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredListOfCourses.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else
        _filteredListOfCourses.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    });
  }

  void _filterTopicCourses(value) {
    setState(() {
      _filteredListOfCourses = _listOfCourses
          .where((course) => course.name.toLowerCase().contains(value))
          .toList();
    });
    // print(_filteredCourseLearners);
  }

  List<Widget> _getTags() {
    List<Widget> tags = [];
    for (int i = 0; i < _topic['children'].length; i++) {
      tags.add(InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   FadeRoute(
          //       page: TopicCourses(
          //           _topic['children'][i]['identifier'],
          //           _topic['children'][i]['name'],
          //           _topic['children'][i])),
          // );
          setState(() {
            _identifier = _topic['children'][i]['identifier'];
            _name = _topic['children'][i]['name'];
            _topic = _topic['children'][i];
            _pageInitilized = false;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          child: Container(
            // height: 24,
            // margin: EdgeInsets.only(
            //   top: 15.0,
            //   bottom: 5.0,
            //   right: 10,
            // ),
            // padding: EdgeInsets.fromLTRB(20, 5, 20, 6),
            decoration: BoxDecoration(
              color: AppColors.grey04,
              border: Border.all(color: AppColors.grey08),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Text(
                _topic['children'][i]['name'],
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 1.0,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    // print('Name of the topic: ${widget.name}');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // elevation: 0,
          titleSpacing: 0,
          // automaticallyImplyLeading: false,
          // leading: Row(children: [
          //   IconButton(
          //       icon: Icon(
          //         Icons.close,
          //         color: AppColors.greys87,
          //       ),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       }),
          //   Text(widget.backToTitle)
          // ]),
          title: Text(
            'Back to \'All topics\'',
            style: GoogleFonts.lato(
                color: AppColors.greys60,
                wordSpacing: 1.0,
                fontSize: 16.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: _getTopicCourses(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Container(
                      // color: Color.fromRGBO(241, 244, 244, 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              color: Colors.white,
                              // height: 56,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                child: Text(
                                  _name,
                                  style: GoogleFonts.montserrat(
                                      color: AppColors.greys87,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.12,
                                      height: 1.5),
                                ),
                              )),
                          Container(
                            padding: const EdgeInsets.fromLTRB(12, 20, 12, 15),
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 25,
                                  child: Text(
                                    'Top "$_name" picks for you',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          Container(
                              height: 322,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _listOfCourses.length >= 3
                                    ? 3
                                    : _listOfCourses.length >= 2
                                        ? 2
                                        : 1,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        _generateInteractTelemetryData(
                                            _listOfCourses[index].id);
                                        Navigator.push(
                                          context,
                                          FadeRoute(
                                              page: CourseDetailsPage(
                                            id: _listOfCourses[index].id,
                                            isContinueLearning: false,
                                          )),
                                        );
                                      },
                                      child: Container(
                                        // padding: const EdgeInsets.only(right: 16),
                                        child: Container(
                                          // width: MediaQuery.of(context).size.width -
                                          //     10,
                                          child: CourseItem(
                                            course: _listOfCourses[index],
                                            displayProgress: false,
                                          ),
                                        ),
                                      ));
                                  // CourseItem(
                                  // course: _continueLearningcourses[index]);
                                },
                              )),
                          _topic['children'] != null
                              ? Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 12, 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                25,
                                        child: Text(
                                          'Explore topics under "$_name"',
                                          style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            letterSpacing: 0.12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Center(),
                          _topic['children'] != null
                              ? Container(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 20),
                                  child: Container(
                                    // height: 24,
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Wrap(
                                        // scrollDirection: Axis.horizontal,
                                        // physics: NeverScrollableScrollPhysics(),
                                        // shrinkWrap: true,
                                        children: _getTags()),
                                  ),
                                )
                              : Center(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: 112,
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Explore all associated CBPs',
                                      style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: 0.12,
                                          height: 1.5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            // width: 316,
                                            height: 48,
                                            child: TextFormField(
                                                onChanged: (value) {
                                                  _filterTopicCourses(value);
                                                },
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.done,
                                                style: GoogleFonts.lato(
                                                    fontSize: 14.0),
                                                decoration: InputDecoration(
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(16.0,
                                                          10.0, 0.0, 10.0),
                                                  // border: OutlineInputBorder(
                                                  //     borderSide: BorderSide(
                                                  //         color: AppColors
                                                  //             .primaryThree, width: 10),),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    borderSide: BorderSide(
                                                      color: AppColors.grey16,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.0),
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .primaryThree,
                                                    ),
                                                  ),
                                                  hintText: 'Search',
                                                  hintStyle: GoogleFonts.lato(
                                                      color: AppColors.greys60,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  // focusedBorder: OutlineInputBorder(
                                                  //   borderSide: const BorderSide(
                                                  //       color: AppColors.primaryThree, width: 1.0),
                                                  // ),
                                                  counterStyle: TextStyle(
                                                    height: double.minPositive,
                                                  ),
                                                  counterText: '',
                                                )),
                                          ),
                                          Container(
                                            height: 48,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: AppColors.grey16,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              // color: AppColors.lightGrey,
                                            ),
                                            // color: Colors.white,
                                            // width: double.infinity,
                                            // margin: EdgeInsets.only(right: 225, top: 2),
                                            child: DropdownButton<String>(
                                              value: dropdownValue != null
                                                  ? dropdownValue
                                                  : null,
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: AppColors.greys60,
                                                size: 18,
                                              ),
                                              hint: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('Sort by')),
                                              ),
                                              iconSize: 26,
                                              elevation: 16,
                                              style: TextStyle(
                                                  color: AppColors.greys87),
                                              underline: Container(
                                                // height: 2,
                                                color: AppColors.lightGrey,
                                              ),
                                              selectedItemBuilder:
                                                  (BuildContext context) {
                                                return dropdownItems
                                                    .map<Widget>((String item) {
                                                  return Row(
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  15.0,
                                                                  15.0,
                                                                  0,
                                                                  15.0),
                                                          child: Text(
                                                            item,
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: AppColors
                                                                  .greys87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ))
                                                    ],
                                                  );
                                                }).toList();
                                              },
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  dropdownValue = newValue;
                                                });
                                                _sortCourses(dropdownValue);
                                              },
                                              items: dropdownItems.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _listOfCourses.length > 0
                              ? Container(
                                  // height: 100,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: _filteredListOfCourses.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: BrowseCourseCard(
                                            course:
                                                _filteredListOfCourses[index]),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 80),
                                    child: Text(
                                      "No associated CBPs",
                                      style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: 0.12,
                                          height: 1.5),
                                    ),
                                  ),
                                ),
                          // BrowseCompetencyCard(_listOfCourses)
                          // HubPage(),
                        ],
                      ),
                    );
                  } else {
                    return PageLoader(
                      bottom: 150,
                    );
                  }
                }),
          ),
        ));
  }
}
