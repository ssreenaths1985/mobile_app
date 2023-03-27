import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/feedback/widgets/_microSurvey/page_loader.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
// import 'package:karmayogi_mobile/services/_services/telemetry_service.dart';
import 'package:karmayogi_mobile/ui/widgets/_learn/topic_card.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';
import '../../../constants/_constants/telemetry_constants.dart';
import '../../../constants/index.dart';

class BrowseByTopic extends StatefulWidget {
  static const route = AppUrl.browseByTopicPage;
  final int index;

  BrowseByTopic({Key key, this.index}) : super(key: key);

  @override
  _BrowseByTopicState createState() => _BrowseByTopicState();
}

class _BrowseByTopicState extends State<BrowseByTopic>
    with WidgetsBindingObserver {
  ScrollController _scrollController;
  final _textController = TextEditingController();

  List<CourseTopics> _courseTopics = [];
  List<CourseTopics> _filteredCourseTopics = [];
  bool _scrollStatus = true;
  bool _pageInitilized = false;

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

  _scrollListener() {
    if (isScroll != _scrollStatus) {
      setState(() {
        _scrollStatus = isScroll;
      });
    }
  }

  bool get isScroll {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _textController.addListener(_filterTopics);
    _generateTelemetryData();
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
      TelemetryPageIdentifier.allTopicsPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.allTopicsPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<List<CourseTopics>> _getCourseTopics() async {
    if (!_pageInitilized) {
      _courseTopics = await Provider.of<LearnRepository>(context, listen: false)
          .getCourseTopics();
      setState(() {
        _filteredCourseTopics = _courseTopics;
        _pageInitilized = true;
      });
    }
    return _courseTopics;
  }

  _filterTopics() {
    // print('_filterTopics...');
    String value = _textController.text;
    setState(() {
      _filteredCourseTopics = _courseTopics
          .where((topic) => topic.name.toString().toLowerCase().contains(value))
          .toList();
      // });
    });
  }

  List<Container> _generateTopics() {
    // print('_generateTopics...');
    final columns = <Container>[];
    for (int i = 0; i < _filteredCourseTopics.length; i = i + 2)
      columns.add(Container(
        height: 100,
        child: Row(
          children: [
            TopicCard(
              cardColor: Colors.black,
              courseTopics: _filteredCourseTopics[i],
            ),
            _filteredCourseTopics.length > i + 1
                ? TopicCard(
                    cardColor: Colors.black,
                    courseTopics: _filteredCourseTopics[i + 1],
                  )
                : Center()
          ],
        ),
      ));

    return columns;
  }

  void _sortTopics(sortBy) {
    // print('_sortTopics... $sortBy ${EnglishLang.ascentAtoZ}');
    if (sortBy == EnglishLang.ascentAtoZ) {
      setState(() {
        _filteredCourseTopics.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      });
    } else if (sortBy == EnglishLang.descentZtoA) {
      setState(() {
        _filteredCourseTopics.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      });
    }

    _generateTopics();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _textController.dispose();
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
            'Back to \'Explore by\'',
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
                  future: _getCourseTopics(),
                  builder:
                      (context, AsyncSnapshot<List<CourseTopics>> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Text(
                                'All topics',
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.12,
                                    height: 1.5),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/img/topic_landing.svg',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Text(
                                'Popular topics',
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.12,
                                    height: 1.5),
                              ),
                            ),
                            _courseTopics.length > 0
                                ? Container(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: 4,
                                      itemBuilder: (context, index) {
                                        return TopicCard(
                                          cardColor: Colors.black,
                                          courseTopics: _courseTopics[index],
                                          paddingLeft: 8.0,
                                        );
                                      },
                                    ),
                                  )
                                : Center(),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 24, bottom: 16),
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                height: 112,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        EnglishLang.browseTopics,
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
                                                  controller: _textController,
                                                  onChanged: (value) {
                                                    // _filterTopics(
                                                    //     value.toLowerCase());
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
                                                        EdgeInsets.fromLTRB(
                                                            16.0,
                                                            10.0,
                                                            0.0,
                                                            10.0),
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
                                                        color:
                                                            AppColors.greys60,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    // focusedBorder: OutlineInputBorder(
                                                    //   borderSide: const BorderSide(
                                                    //       color: AppColors.primaryThree, width: 1.0),
                                                    // ),
                                                    counterStyle: TextStyle(
                                                      height:
                                                          double.minPositive,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
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
                                                      .map<Widget>(
                                                          (String item) {
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
                                                  Future.delayed(
                                                      Duration(
                                                          microseconds: 100),
                                                      () async {
                                                    _sortTopics(newValue);
                                                  });
                                                },
                                                items: dropdownItems.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                            Column(children: _generateTopics()),
                            Padding(padding: const EdgeInsets.only(bottom: 20))
                          ],
                        ),
                      );
                    } else {
                      return PageLoader(
                        bottom: 150,
                      );
                    }
                  })),
        ));
  }
}
