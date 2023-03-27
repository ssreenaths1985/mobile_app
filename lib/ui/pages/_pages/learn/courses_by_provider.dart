import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/telemetry_constants.dart';

class CoursesByProvider extends StatefulWidget {
  // static const route = AppUrl.coursesInCompetency;
  // final String identifier;
  final String providerName;
  final bool isCollection;
  final String collectionId;
  final String collectionDescription;
  final bool isFromHome;

  CoursesByProvider(this.providerName,
      {this.isCollection = false,
      this.collectionId = '',
      this.collectionDescription,
      this.isFromHome = false});

  @override
  _CoursesByProviderState createState() => _CoursesByProviderState();
}

class _CoursesByProviderState extends State<CoursesByProvider> {
  List<Course> _listOfCourses = [];
  List<Course> _filteredListOfCourses = [];
  bool _pageInitilized = false;

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  bool trimText = false;
  int _maxLength = 200;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _generateTelemetryData();
    if (widget.isCollection && widget.collectionDescription != null) {
      if (widget.collectionDescription.length > _maxLength) {
        trimText = true;
      }
    }
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
      TelemetryPageIdentifier.browseByProviderCoursesPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.browseByProviderCoursesPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<dynamic> _getCoursesByProvider() async {
    _listOfCourses = !widget.isCollection
        ? await Provider.of<LearnRepository>(context, listen: false)
            .getCoursesByProvider(widget.providerName)
        : await Provider.of<LearnRepository>(context, listen: false)
            .getCoursesByCollection(widget.collectionId);
    // print(_listOfCourses.length.toString());
    if (!_pageInitilized) {
      setState(() {
        _filteredListOfCourses = _listOfCourses;
        _pageInitilized = true;
      });
    }
    return _listOfCourses;
  }

  void _filterTopicCourses(value) {
    setState(() {
      _filteredListOfCourses = _listOfCourses
          .where((course) => course.name.toLowerCase().contains(value))
          .toList();
    });
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

  void _toogleReadMore() {
    setState(() {
      trimText = !trimText;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            !widget.isFromHome
                ? (!widget.isCollection
                    ? 'Back to \'All providers\''
                    : 'Back to \'All collections\'')
                : 'Back',
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
                future: _getCoursesByProvider(),
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
                                  widget.providerName != null
                                      ? widget.providerName
                                      : '',
                                  style: GoogleFonts.montserrat(
                                      color: AppColors.greys87,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.12,
                                      height: 1.5),
                                ),
                              )),
                          (widget.isCollection &&
                                  widget.collectionDescription != null)
                              ? Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 0),
                                    child: Text(
                                      (trimText &&
                                              widget.collectionDescription
                                                      .length >
                                                  _maxLength)
                                          ? widget.collectionDescription
                                                  .substring(
                                                      0, _maxLength - 1) +
                                              '...'
                                          : widget.collectionDescription,
                                      style: GoogleFonts.montserrat(
                                          color: AppColors.greys87,
                                          fontSize: 14.0,
                                          letterSpacing: 0.12,
                                          height: 1.5),
                                    ),
                                  ))
                              : Center(),
                          (widget.isCollection &&
                                  widget.collectionDescription != null)
                              ? (widget.collectionDescription.length >
                                      _maxLength)
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
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: AppColors.primaryThree,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ))
                                  : Center()
                              : Center(),
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

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16, bottom: 16),
                            child: Text(
                              _filteredListOfCourses.length.toString() +
                                  ' CBP\'s from this ' +
                                  (!widget.isCollection
                                      ? 'provider'
                                      : 'collection'),
                              style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: 0.12,
                                  height: 1.5),
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
