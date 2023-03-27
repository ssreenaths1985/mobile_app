import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
// import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:karmayogi_mobile/services/index.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/competency/self_attest_competency.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../respositories/_respositories/competency_repository.dart';

class CompetencyDetailsPage extends StatefulWidget {
  static const route = AppUrl.coursesInCompetency;
  final BrowseCompetencyCardModel browseCompetencyCardModel;
  final ValueChanged<bool> updateRemoveCompetencyStatus;
  CompetencyDetailsPage(this.browseCompetencyCardModel,
      {this.updateRemoveCompetencyStatus});

  @override
  _CoursesInCompetencyState createState() {
    return new _CoursesInCompetencyState();
  }
}

class _CoursesInCompetencyState extends State<CompetencyDetailsPage> {
  final CompetencyService competencyService = CompetencyService();

  var _levels = [];
  var _profileCompetencies = [];
  bool _isAlreadyAdded = false;
  List<Course> _listOfCourses = [];
  bool _pageInitilized = false;
  List<Course> _filteredListOfCourses = [];
  // List<Course> _allCourses = [];

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
    _checkAlreadyAdded();
    //checking the current competency is already existed in profile competency
    // _getLevelsAndDescription();
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
      TelemetryPageIdentifier.browseByCompetencyCoursesPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.browseByCompetencyCoursesPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<dynamic> _getCoursesByCompetencies() async {
    // getting list of courses in the current competency
    List<String> emptyList = [];
    _listOfCourses = await Provider.of<LearnRepository>(context, listen: false)
        .getCoursesByCompetencies(
            widget.browseCompetencyCardModel.name, emptyList, emptyList);

    //getting all levels and description
    _levels = await _getLevelsAndDescription();

    // _isAlreadyAdded = await _checkAlreadyAdded();

    // print('Length: ' + _profileCompetencies.length.toString());

    // print('List Course: ' + _listOfCourses.toString());
    if (!_pageInitilized) {
      setState(() {
        _filteredListOfCourses = _listOfCourses;
        _pageInitilized = true;
      });
    }
    return _listOfCourses;
  }

  Future<bool> _checkAlreadyAdded() async {
    //getting profile competency
    List<Profile> _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    _profileCompetencies = _profileDetails[0].competencies;

    final foundId = _profileCompetencies.where((competency) =>
        competency['id'] == widget.browseCompetencyCardModel.id);

    if (foundId.isNotEmpty) {
      // print('Already added');
      setState(() {
        _isAlreadyAdded = true;
      });
    }
    return _isAlreadyAdded;
  }

  void _setAlreadyAdded(bool value) {
    setState(() {
      _isAlreadyAdded = true;
    });
  }

  Future<void> _removeFromYourCompetency(id) async {
    List<Profile> profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    var _response =
        await competencyService.removeFromYourCompetency(id, profileDetails);

    if (_response['result']['response'] == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EnglishLang.removedFromYourCompetency),
          backgroundColor: AppColors.positiveLight,
        ),
      );
      widget.updateRemoveCompetencyStatus(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EnglishLang.errorMessage),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  Future<void> _addedStatus(dynamic response) async {
    if (response['result']['response'] == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EnglishLang.addedToYourCompetency),
          backgroundColor: AppColors.positiveLight,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EnglishLang.errorMessage),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  Future<dynamic> _getLevelsAndDescription() async {
    var levels = await Provider.of<CompetencyRepository>(context, listen: false)
        .getLevelsForCompetency(
            widget.browseCompetencyCardModel.id, "COMPETENCY");
    return levels;
  }

  void _filterCourses(value) {
    setState(() {
      _filteredListOfCourses = _listOfCourses
          .where((course) => course.name.toLowerCase().contains(value))
          .toList();
    });
    // print(_filteredCourseLearners);
  }

  void _sortCourses(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredListOfCourses
            .sort((a, b) => a.name.trim().compareTo(b.name.trim()));
      } else
        _filteredListOfCourses
            .sort((a, b) => b.name.trim().compareTo(a.name.trim()));
    });
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        border: bgColor == Colors.white
            ? Border.all(color: AppColors.grey40)
            : Border.all(color: bgColor),
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.montserrat(
            decoration: TextDecoration.none,
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
    return loginBtn;
  }

  Future<bool> _confirmDeletion() {
    return showDialog(
        context: context,
        builder: (context) => Stack(
              children: [
                Positioned(
                    child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      height: 215.0,
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 15),
                                child: Text(
                                  EnglishLang.doYouWantToRemove,
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: GestureDetector(
                                onTap: () async {
                                  _removeFromYourCompetency(
                                      widget.browseCompetencyCardModel.id);
                                  setState(() {
                                    _isAlreadyAdded = false;
                                  });
                                  Navigator.of(context).pop(true);
                                },
                                child: roundedButton(EnglishLang.yesRemove,
                                    Colors.white, AppColors.primaryThree),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 15),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(false),
                                child: roundedButton('No, take me back',
                                    AppColors.primaryThree, Colors.white),
                              ),
                            ),
                          ])),
                ))
              ],
            ));
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
          EnglishLang.backToAllCompetencies,
          style: GoogleFonts.lato(
              color: AppColors.greys60,
              wordSpacing: 1.0,
              fontSize: 16.0,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _getCoursesByCompetencies(),
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
                            widget.browseCompetencyCardModel.description != null
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
                                                  .competencyType !=
                                              null
                                          ? widget.browseCompetencyCardModel
                                              .competencyType
                                          : '',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        widget.browseCompetencyCardModel
                                                    .competencyArea !=
                                                null
                                            ? widget.browseCompetencyCardModel
                                                .competencyArea
                                            : '',
                                        style: GoogleFonts.lato(
                                            color: AppColors.greys87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            letterSpacing: 0.12,
                                            height: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _levels.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: 75,
                                  color: Colors.white,
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    child: Text(
                                                      _levels[index]['level'],
                                                      // "Name of the competency",
                                                      style: GoogleFonts.lato(
                                                        color:
                                                            AppColors.greys60,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        _levels[index]['name'],
                                                        style: GoogleFonts.lato(
                                                          color:
                                                              AppColors.greys87,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              VerticalDivider(
                                                thickness: 1,
                                                width: 20,
                                                color: AppColors.grey16,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      _levels[index][
                                                          'description'], // "Design and set up interface and interconnections from or among sensors, through a network, to a main location, to enable transmission of information",
                                                      style: GoogleFonts.lato(
                                                        color:
                                                            AppColors.greys60,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: 112,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        // width: 316,
                                        height: 48,
                                        child: TextFormField(
                                            onChanged: (value) {
                                              _filterCourses(value);
                                            },
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.done,
                                            style: GoogleFonts.lato(
                                                fontSize: 14.0),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.search),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      16.0, 10.0, 0.0, 10.0),
                                              // border: OutlineInputBorder(
                                              //     borderSide: BorderSide(
                                              //         color: AppColors
                                              //             .primaryThree, width: 10),),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                borderSide: BorderSide(
                                                  color: AppColors.grey16,
                                                  width: 1.0,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                                borderSide: BorderSide(
                                                  color: AppColors.primaryThree,
                                                ),
                                              ),
                                              hintText: 'Search',
                                              hintStyle: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400),
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                const EdgeInsets.only(left: 8),
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
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15.0,
                                                              15.0,
                                                              0,
                                                              15.0),
                                                      child: Text(
                                                        item,
                                                        style: GoogleFonts.lato(
                                                          color:
                                                              AppColors.greys87,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                          items: dropdownItems
                                              .map<DropdownMenuItem<String>>(
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
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _filteredListOfCourses.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: BrowseCourseCard(
                                        course: _filteredListOfCourses[index]),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 80, bottom: 150),
                                child: Text(
                                  EnglishLang.noAssociatedCBPs,
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            // height: _activeTabIndex == 0 ? 60 : 0,
            height: 50,
            child: Column(
              children: [
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: AppColors.primaryThree,
                //     minimumSize: const Size.fromHeight(40), // NEW
                //   ),
                //   onPressed: () {},
                //   child: const Text(
                //     EnglishLang.competencyAssessment,
                //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                //   ),
                // ),
                // SizedBox(
                //   height: 4,
                // ),
                _isAlreadyAdded
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: const Size.fromHeight(40), // NEW
                          side: BorderSide(
                              width: 1, color: AppColors.primaryThree),
                        ),
                        onPressed: () {
                          _confirmDeletion();
                        },
                        child: const Text(
                          EnglishLang.removeFromYourCompetency,
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryThree,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: const Size.fromHeight(40), // NEW
                          side: BorderSide(
                              width: 1, color: AppColors.primaryThree),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelfAttestCompetency(
                                      currentCompetencySelected:
                                          widget.browseCompetencyCardModel,
                                      profileCompetencies: _profileCompetencies,
                                      isAlreadyAdded: _setAlreadyAdded,
                                      addedStatus: _addedStatus,
                                      levels: _levels,
                                    )),
                          );
                        },
                        child: const Text(
                          EnglishLang.selfAttestCompetency,
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryThree,
                              fontWeight: FontWeight.w700),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
