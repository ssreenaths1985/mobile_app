import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../respositories/_respositories/competency_repository.dart';
// import './../../../../constants/index.dart';
// import './../../../widgets/index.dart';

class AllCompetenciesPage extends StatefulWidget {
  @override
  _AllCompetenciesPageState createState() => _AllCompetenciesPageState();
}

class _AllCompetenciesPageState extends State<AllCompetenciesPage> {
  List<BrowseCompetencyCardModel> _listOfCompetencies = [];
  List<BrowseCompetencyCardModel> _filteredListOfCompetencies = [];

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  List selectedCourses = [];
  List selectedSubjects = [];

  bool _pageInitilized = false;
  // bool _showLoader = true;

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
      TelemetryPageIdentifier.allCompetenciesPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.allCompetenciesPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<List<BrowseCompetencyCardModel>> _getListOfCompetencies() async {
    if (!_pageInitilized) {
      _listOfCompetencies =
          await Provider.of<CompetencyRepository>(context, listen: false)
              .getCompetencies();

      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies;
        _pageInitilized = true;
        // _showLoader = false;
      });
    }

    // listOfCompetencies = await courseService.getCompetenciesList();
    // print({'_getListOfCompetencies: $_listOfCompetencies'});
    return _listOfCompetencies;
  }

  void filterCompetencies(value) {
    setState(() {
      _filteredListOfCompetencies = _listOfCompetencies
          .where((competency) =>
              competency.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void updateFilters(Map data) {
    switch (data['filter']) {
      case EnglishLang.type:
        if (selectedCourses.contains(data['item'].toLowerCase()))
          selectedCourses.remove(data['item'].toLowerCase());
        else
          selectedCourses.add(data['item'].toLowerCase());
        break;

      default:
        if (selectedSubjects.contains(data['item'].toLowerCase()))
          selectedSubjects.remove(data['item'].toLowerCase());
        else
          selectedSubjects.add(data['item'].toLowerCase());
        break;
    }
    setState(() {});
  }

  void setDefault(String filter) {
    switch (filter) {
      case EnglishLang.type:
        selectedCourses = [];
        break;
      default:
        selectedSubjects = [];
    }
    setState(() {});
  }

  void sortCompetencies(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredListOfCompetencies.sort((a, b) =>
            a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      } else
        _filteredListOfCompetencies.sort((a, b) =>
            b.name.trim().toLowerCase().compareTo(a.name.trim().toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: _getListOfCompetencies(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              // print('Loading cards...' + _showLoader.toString());

              return Container(
                // color: Color.fromRGBO(241, 244, 244, 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 0, bottom: 10),
                      child: Container(
                        // color: Colors.white,
                        width: double.infinity,
                        height: 117,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                EnglishLang.allCompetencies,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.12,
                                    height: 1.5),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.70,
                                      // width: 316,
                                      height: 48,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            filterCompetencies(value);
                                          },
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          style:
                                              GoogleFonts.lato(fontSize: 14.0),
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.search),
                                            contentPadding: EdgeInsets.fromLTRB(
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
                                      width: MediaQuery.of(context).size.width *
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
                                        style:
                                            TextStyle(color: AppColors.greys87),
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
                                          sortCompetencies(dropdownValue);
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
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.only(left: 16),
                                    //   child: Container(
                                    //     width: 48,
                                    //     height: 48,
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.white,
                                    //       borderRadius: BorderRadius.all(
                                    //           const Radius.circular(4.0)),
                                    //       border: Border.all(
                                    //           color: AppColors.grey16),
                                    //     ),
                                    //     child: Icon(
                                    //       Icons.filter_list,
                                    //       color: AppColors.greys60,
                                    //       size: 24,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _listOfCompetencies.length > 1
                        ? Container(
                            // height: 100,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _filteredListOfCompetencies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: BrowseCompetencyCard(
                                      browseCompetencyCardModel:
                                          _filteredListOfCompetencies[index],
                                      isCompetencyDetails: true),
                                );
                              },
                            ),
                          )
                        : Text(EnglishLang.noCompetenciesFound),
                    // BrowseCompetencyCard(_listOfCompetencies)
                    // HubPage(),
                  ],
                ),
              );
            } else {
              return PageLoader(
                bottom: 200,
              );
            }
          },
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     // height: _activeTabIndex == 0 ? 60 : 0,
      //     height: 60,
      //     child: Row(
      //       children: [
      //         Container(
      //           margin: const EdgeInsets.all(10),
      //           child: IconButton(
      //               icon: Icon(
      //                 Icons.filter_list,
      //                 color: Colors.white,
      //               ),
      //               onPressed: () {}),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(8),
      //             color: AppColors.primaryThree,
      //           ),
      //           height: 40,
      //         ),
      //         Expanded(
      //           child: ListView(
      //             scrollDirection: Axis.horizontal,
      //             shrinkWrap: true,
      //             // mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               InkWell(
      //                 onTap: () => {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => CompetencyFilters(
      //                         filterName: EnglishLang.type,
      //                         items: courses,
      //                         selectedItems: selectedCourses,
      //                         parentAction1: updateFilters,
      //                         parentAction2: setDefault,
      //                       ),
      //                     ),
      //                   ),
      //                 },
      //                 child: Container(
      //                     margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      //                     padding: const EdgeInsets.only(left: 0, right: 0),
      //                     height: 40,
      //                     child: FilterCard(
      //                         EnglishLang.type, EnglishLang.allCourses)),
      //               ),
      //               InkWell(
      //                 onTap: () => {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => CompetencyFilters(
      //                         filterName: EnglishLang.subject,
      //                         items: subjects,
      //                         selectedItems: selectedSubjects,
      //                         parentAction1: updateFilters,
      //                         parentAction2: setDefault,
      //                       ),
      //                     ),
      //                   ),
      //                 },
      //                 child: Container(
      //                     margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      //                     padding: const EdgeInsets.only(left: 10, right: 10),
      //                     height: 40,
      //                     child: FilterCard(
      //                         EnglishLang.subject, EnglishLang.allSubjects)),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // )
    );
  }
}
