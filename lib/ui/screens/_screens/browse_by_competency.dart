import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/filter/browse_by_competency_filter.dart';
import 'package:karmayogi_mobile/ui/widgets/_learn/competency_card.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:karmayogi_mobile/util/telemetry_db_helper.dart';
import 'package:provider/provider.dart';
// import './../../../ui/pages/_pages/text_search_results/text_search_page.dart';
// import './../../../ui/pages/index.dart';

import '../../../constants/_constants/telemetry_constants.dart';
import '../../../constants/index.dart';

class BrowseByCompetency extends StatefulWidget {
  static const route = AppUrl.browseByCompetencyPage;

  @override
  _BrowseByCompetencyState createState() => _BrowseByCompetencyState();
}

class _BrowseByCompetencyState extends State<BrowseByCompetency> {
  List<BrowseCompetencyCardModel> _listOfCompetencies = [];
  List<BrowseCompetencyCardModel> _filteredListOfCompetencies = [];
  bool _pageInitilized = false;

  // int pageNo = 1;
  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  List<dynamic> _allCompetencyArea;
  List<dynamic> _allCompetencyType;

  int _selectedTypeIndex;
  int _selectedAreaIndex;
  bool _isAppliedFilter = false;

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
    // _getListOfCompetencies();
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
      TelemetryPageIdentifier.browseByAllCompetenciesPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.browseByAllCompetenciesPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<dynamic> _getListOfCompetencies() async {
    _listOfCompetencies =
        await Provider.of<LearnRepository>(context, listen: false)
            .getListOfCompetencies(context);

    //getting list of competency types
    _allCompetencyType =
        _listOfCompetencies.map((e) => e.competencyType).toList();
    var seen = Set<String>();
    _allCompetencyType =
        _allCompetencyType.where((type) => seen.add(type)).toList();
    _allCompetencyType.remove('');
    _allCompetencyType.insert(0, 'All');

    //getting list of competency area
    _allCompetencyArea =
        _listOfCompetencies.map((e) => e.competencyArea).toList();
    _allCompetencyArea =
        _allCompetencyArea.where((area) => seen.add(area)).toList();
    _allCompetencyArea.remove('');
    _allCompetencyArea.insert(0, 'All');

    if (!_pageInitilized) {
      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies;
        _pageInitilized = true;
      });
    }

    // listOfCompetencies = await courseService.getCompetenciesList();
    // print({'Browse by competencies page $_listOfCompetencies'});
    return _listOfCompetencies;
  }

  void filterCompetencies(value) {
    setState(() {
      _filteredListOfCompetencies = _listOfCompetencies
          .where((competency) => competency.name.toLowerCase().contains(value))
          .toList();
    });
  }

  void filterCompetencyBy(Map filter) {
    // print('filterBy: ' + filter.toString());
    if (filter['type'] != EnglishLang.all &&
        filter['area'] == EnglishLang.all) {
      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies
            .where((competency) => competency.competencyType
                .toLowerCase()
                .contains(filter['type'].toLowerCase()))
            .toList();
      });
    } else if (filter['area'] != EnglishLang.all &&
        filter['type'] == EnglishLang.all) {
      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies
            .where((competency) => competency.competencyArea
                .toLowerCase()
                .contains(filter['area'].toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies;
      });
    }
  }

  void _selectedFilterIndex(Map index) {
    // print('Indexs: ' + index.toString());
    setState(() {
      _selectedTypeIndex = index['type'];
      _selectedAreaIndex = index['area'];
    });
  }

  void sortCompetencies(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredListOfCompetencies
            .sort((a, b) => a.name.trim().compareTo(b.name.trim()));
      } else
        _filteredListOfCompetencies
            .sort((a, b) => b.name.trim().compareTo(a.name.trim()));
    });
  }

  void _setAppliedFilterStatus(bool isApplied) {
    setState(() {
      _isAppliedFilter = isApplied;
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
            'Back to \'Explore by\'',
            style: GoogleFonts.lato(
                color: AppColors.greys60,
                wordSpacing: 1.0,
                fontSize: 16.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: _getListOfCompetencies(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Container(
                    // color: Color.fromRGBO(241, 244, 244, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Text(
                            'All competencies',
                            style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.12,
                                height: 1.5),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/img/competency_landing.svg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Text(
                            'Popular competencies',
                            style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.12,
                                height: 1.5),
                          ),
                        ),
                        _listOfCompetencies.length > 0
                            ? Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return CompetencyCard(
                                      browseCompetencyCardModel:
                                          _listOfCompetencies[index],
                                    );
                                  },
                                ),
                              )
                            : Center(),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            // height: 112,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    EnglishLang.browseCompetency,
                                    style: GoogleFonts.lato(
                                        color: AppColors.greys87,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        letterSpacing: 0.12,
                                        height: 1.5),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        // width: 316,
                                        height: 48,
                                        child: TextFormField(
                                            onChanged: (value) {
                                              filterCompetencies(value);
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
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: _isAppliedFilter
                                              ? AppColors.primaryThree
                                              : Colors.white,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(4.0)),
                                          border: Border.all(
                                              color: AppColors.grey16),
                                        ),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.filter_list,
                                              color: _isAppliedFilter
                                                  ? Colors.white
                                                  : AppColors.greys60,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                dropdownValue = null;
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BrowseByCompetencyFilter(
                                                    allCompetencyTypes:
                                                        _allCompetencyType,
                                                    allCompetencyArea:
                                                        _allCompetencyArea,
                                                    parentAction1:
                                                        filterCompetencyBy,
                                                    selectedFilterIndex:
                                                        _selectedFilterIndex,
                                                    selectedTypeIndex:
                                                        _selectedTypeIndex,
                                                    selectedAreaIndex:
                                                        _selectedAreaIndex,
                                                    isAppliedFilter:
                                                        _setAppliedFilterStatus,
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                // Container(
                                //     margin: EdgeInsets.only(
                                //         right: 2, top: 2, left: 16),
                                //     child: Text('Sort by: ')),
                                Container(
                                  // width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: DropdownButton<String>(
                                    value: dropdownValue != null
                                        ? dropdownValue
                                        : null,
                                    icon: Icon(Icons.arrow_drop_down_outlined),
                                    iconSize: 18,
                                    // elevation: 16,
                                    hint: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 16),
                                        child: Text('Sort by: ')),
                                    style: TextStyle(color: AppColors.greys87),
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
                                                padding: EdgeInsets.fromLTRB(
                                                    15.0, 15.0, 0, 15.0),
                                                child: Text(
                                                  item,
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys87,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
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
                              ],
                            ),
                          ],
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
                                        isCompetencyDetails: false,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text("No competencies found"),
                        // BrowseCompetencyCard(_listOfCompetencies)
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
        ));
  }
}
