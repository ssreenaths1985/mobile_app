import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
// import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/filter/course_filters.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/telemetry_constants.dart';

class CoursesInCompetency extends StatefulWidget {
  static const route = AppUrl.coursesInCompetency;
  final BrowseCompetencyCardModel browseCompetencyCardModel;
  CoursesInCompetency(this.browseCompetencyCardModel);

  @override
  _CoursesInCompetencyState createState() {
    return new _CoursesInCompetencyState();
  }
}

class _CoursesInCompetencyState extends State<CoursesInCompetency> {
  var _levels = [];
  List<Course> _listOfCourses = [];
  bool _pageInitilized = false;
  List<Course> _filteredListOfCourses = [];
  dynamic _listOfProviders = [];
  // List<Course> _allCourses = [];

  List contentTypes = [
    EnglishLang.program,
    EnglishLang.course,
  ];

  List<String> selectedContentTypes = [];
  List<String> selectedProviders = [];

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  bool dataSent;
  bool isDiscussionTypesOpen = false;
  bool isTrending = true;
  List typesOfDiscussions = ['Trending', 'Recent'];
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _generateTelemetryData();
    // _getLevelsAndDescription();
    // setState(() {
    //   selectedContentTypes = contentTypes;
    //   selectedProviders = _listOfProviders;
    // });
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
      TelemetryPageIdentifier.browseByCompetencyCoursesPageId
          .replaceAll(':competencyName', widget.browseCompetencyCardModel.name),
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.browseByCompetencyCoursesPageUri
          .replaceAll(':competencyName', widget.browseCompetencyCardModel.name),
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<dynamic> _getCoursesByCompetencies(
      selectedContentTypes, selectedProviders) async {
    _listOfCourses = await Provider.of<LearnRepository>(context, listen: false)
        .getCoursesByCompetencies(widget.browseCompetencyCardModel.name,
            selectedContentTypes, selectedProviders);
    // print('List Course: ' + _listOfCourses.toString());
    if (!_pageInitilized) {
      final listOfProviders = _getAllProviders(_listOfCourses);
      _listOfProviders = listOfProviders.map((item) => (item).toList());
      setState(() {
        _filteredListOfCourses = _listOfCourses;
        _listOfProviders = listOfProviders;
        _pageInitilized = true;
      });
    }
    return _listOfCourses;
  }

  // Future<dynamic> _getLevelsAndDescription() async {
  //   _levels = await Provider.of<CompetencyRepository>(context, listen: false)
  //       .getLevelsForCompetency(
  //           widget.browseCompetencyCardModel.id, "COMPETENCY");
  //   return _levels;
  // }

  _getAllProviders(courses) {
    var data = [];
    courses.forEach((item) => data.add(item.source));
    var seen = Set<String>();
    data = data.where((type) => seen.add(type)).toList();
    return data;
  }

  void _filterCourses(value) {
    setState(() {
      _filteredListOfCourses = _listOfCourses
          .where((course) => course.name.toLowerCase().contains(value))
          .toList();
    });
  }

  Future<void> updateFilters(Map data) async {
    switch (data['filter']) {
      case EnglishLang.contentType:
        if (selectedContentTypes.contains(data['item'].toLowerCase())) {
          selectedContentTypes.remove(data['item'].toLowerCase());
        } else {
          selectedContentTypes.add(data['item'].toLowerCase());
        }
        break;
      default:
        // if (!selectedProviders.contains(data['item'].toLowerCase()) &&
        //     selectedProviders.length > 0)
        //   selectedProviders.remove(selectedProviders[0]);
        if (selectedProviders.contains(data['item'].toLowerCase()))
          selectedProviders.remove(data['item'].toLowerCase());
        else
          selectedProviders.add(data['item'].toLowerCase());
        break;
    }
    // print(selectedContentTypes + selectedProviders);
    _listOfCourses = await Provider.of<LearnRepository>(context, listen: false)
        .getCoursesByCompetencies(widget.browseCompetencyCardModel.name,
            selectedContentTypes, selectedProviders);
    // print(_listOfCourses);
    setState(() {
      _filteredListOfCourses = _listOfCourses;
    });
  }

  Future<void> setDefault(String filter) async {
    switch (filter) {
      case EnglishLang.contentType:
        setState(() {
          selectedContentTypes = [];
        });
        break;
      default:
        selectedProviders = [];
    }
    // setState(() {});
    _listOfCourses = await _getCoursesByCompetencies(
        selectedContentTypes, selectedProviders);
    setState(() {
      _filteredListOfCourses = _listOfCourses;
    });
  }

  void _sortCourses(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredListOfCourses.sort((a, b) =>
            a.name.toLowerCase().trim().compareTo(b.name.toLowerCase().trim()));
      } else
        _filteredListOfCourses.sort((a, b) =>
            b.name.toLowerCase().trim().compareTo(a.name.toLowerCase().trim()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
            'Back to \'All competencies\'',
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
                future: _getCoursesByCompetencies(
                    selectedContentTypes, selectedProviders),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Container(
                      // color: Color.fromRGBO(241, 244, 244, 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16, bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.browseCompetencyCardModel.name,
                                  style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      letterSpacing: 0.12,
                                      height: 1.5),
                                ),
                                (widget.browseCompetencyCardModel.description !=
                                            null &&
                                        widget.browseCompetencyCardModel
                                                .description !=
                                            '')
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          widget.browseCompetencyCardModel
                                              .description,
                                          style: GoogleFonts.lato(
                                              color: AppColors.greys87,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              letterSpacing: 0.12,
                                              height: 1.5),
                                        ),
                                      )
                                    : Center(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Competency type: ',
                                        style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            letterSpacing: 0.12,
                                            height: 1.5),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          widget.browseCompetencyCardModel
                                              .competencyType,
                                          style: GoogleFonts.lato(
                                              color: AppColors.greys87,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              letterSpacing: 0.12,
                                              height: 1.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Competency area: ',
                                        style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            letterSpacing: 0.12,
                                            height: 1.5),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          widget.browseCompetencyCardModel
                                              .competencyArea,
                                          style: GoogleFonts.lato(
                                              color: AppColors.greys87,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              letterSpacing: 0.12,
                                              height: 1.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(4.0),
                          //   child: Container(
                          //     child: ListView.builder(
                          //       physics: const NeverScrollableScrollPhysics(),
                          //       scrollDirection: Axis.vertical,
                          //       shrinkWrap: true,
                          //       itemCount: _levels.length,
                          //       itemBuilder: (context, index) {
                          //         return Container(
                          //           margin: EdgeInsets.only(bottom: 8.0),
                          //           child: Container(
                          //             width: 75,
                          //             color: Colors.white,
                          //             child: Wrap(
                          //               children: [
                          //                 Padding(
                          //                   padding: const EdgeInsets.all(16),
                          //                   child: IntrinsicHeight(
                          //                     child: Row(
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       // mainAxisSize: MainAxisSize.min,
                          //                       children: [
                          //                         Column(
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment.start,
                          //                           children: [
                          //                             Container(
                          //                               width:
                          //                                   MediaQuery.of(context)
                          //                                           .size
                          //                                           .width /
                          //                                       3,
                          //                               child: Text(
                          //                                 _levels[index]['level'],
                          //                                 // "Name of the competency",
                          //                                 style: GoogleFonts.lato(
                          //                                   color:
                          //                                       AppColors.greys60,
                          //                                   fontWeight:
                          //                                       FontWeight.w400,
                          //                                   fontSize: 12,
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Padding(
                          //                               padding:
                          //                                   const EdgeInsets.only(
                          //                                       top: 4),
                          //                               child: Text(
                          //                                 _levels[index]['name'],
                          //                                 style: GoogleFonts.lato(
                          //                                   color:
                          //                                       AppColors.greys87,
                          //                                   fontWeight:
                          //                                       FontWeight.w700,
                          //                                   fontSize: 16,
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                         VerticalDivider(
                          //                           thickness: 1,
                          //                           width: 20,
                          //                           color: AppColors.grey16,
                          //                         ),
                          //                         Column(
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment.start,
                          //                           children: [
                          //                             Container(
                          //                               alignment:
                          //                                   Alignment.topLeft,
                          //                               width:
                          //                                   MediaQuery.of(context)
                          //                                           .size
                          //                                           .width /
                          //                                       2,
                          //                               child: Text(
                          //                                 _levels[index][
                          //                                     'description'], // "Design and set up interface and interconnections from or among sensors, through a network, to a main location, to enable transmission of information",
                          //                                 style: GoogleFonts.lato(
                          //                                   color:
                          //                                       AppColors.greys60,
                          //                                   fontWeight:
                          //                                       FontWeight.w400,
                          //                                   fontSize: 14,
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         )
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 16),
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
                                                  _filterCourses(value);
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
                          selectedProviders.length > 1
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
                                  child: Wrap(
                                    children: [
                                      for (var i = 0;
                                          i < selectedProviders.length;
                                          i++)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: (Chip(
                                              label: Text(
                                            'Provider | ' +
                                                selectedProviders[i]
                                                    .toUpperCase(),
                                            style: GoogleFonts.lato(
                                                color: AppColors.greys60,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                letterSpacing: 0.12,
                                                height: 1.5),
                                          ))),
                                        )
                                    ],
                                  ))
                              : Center(),
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
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            // height: _activeTabIndex == 0 ? 60 : 0,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryThree,
                  ),
                  height: 40,
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseFilters(
                                filterName: EnglishLang.contentType,
                                items: contentTypes,
                                selectedItems: selectedContentTypes,
                                parentAction1: updateFilters,
                                parentAction2: setDefault,
                              ),
                            ),
                          ),
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            height: 40,
                            child: FilterCard(
                                EnglishLang.contentType,
                                selectedContentTypes != null
                                    ? (selectedContentTypes.length < 2 &&
                                            selectedContentTypes.length != 0
                                        ? (selectedContentTypes[0]
                                            .toUpperCase())
                                        : (EnglishLang.all))
                                    : (EnglishLang.all))),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseFilters(
                                filterName: EnglishLang.providers,
                                items: _listOfProviders,
                                selectedItems: selectedProviders,
                                parentAction1: updateFilters,
                                parentAction2: setDefault,
                              ),
                            ),
                          ),
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            height: 40,
                            child: FilterCard(
                                EnglishLang.providers,
                                selectedProviders.length > 0
                                    ? (selectedProviders.length == 1
                                        ? (selectedProviders[0].toUpperCase())
                                        : ('MULTIPLE SELECTED'))
                                    : (EnglishLang.all))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        // bottomNavigationBar: BottomAppBar(
        //   child: Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Container(
        //       // height: _activeTabIndex == 0 ? 60 : 0,
        //       height: 100,
        //       child: Column(
        //         children: [
        //           ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //               primary: AppColors.primaryThree,
        //               minimumSize: const Size.fromHeight(40), // NEW
        //             ),
        //             onPressed: () {},
        //             child: const Text(
        //               'Competency assessment',
        //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        //             ),
        //           ),
        //           SizedBox(
        //             height: 4,
        //           ),
        //           ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //               primary: Colors.white,
        //               minimumSize: const Size.fromHeight(40), // NEW
        //               side: BorderSide(width: 1, color: AppColors.primaryThree),
        //             ),
        //             onPressed: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => SelfAttestCompetency(_levels)),
        //               );
        //             },
        //             child: const Text(
        //               'Self attest competency',
        //               style: TextStyle(
        //                   fontSize: 14,
        //                   color: AppColors.primaryThree,
        //                   fontWeight: FontWeight.w700),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
