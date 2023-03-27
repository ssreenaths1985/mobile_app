import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_currentCompetencies/competencies_info.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_currentCompetencies/filter_competencies.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_currentCompetencies/level_info.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/color_constants.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../localization/_langs/english_lang.dart';
import '../../../../models/_models/browse_competency_card_model.dart';
import '../../../../models/_models/multi_select_item.dart';
import '../../../../models/_models/profile_model.dart';
import '../../../../models/_models/telemetry_event_model.dart';
import '../../../../respositories/_respositories/competency_repository.dart';

// import 'dart:developer' as developer;

import '../../../../services/_services/profile_service.dart';
import '../../../../util/telemetry.dart';
import '../../../../util/telemetry_db_helper.dart';

class CurrentCompetencies extends StatefulWidget {
  final bool isDesiredCompetencies;
  const CurrentCompetencies({Key key, this.isDesiredCompetencies = false})
      : super(key: key);

  @override
  State<CurrentCompetencies> createState() => _CurrentCompetenciesState();
}

class _CurrentCompetenciesState extends State<CurrentCompetencies> {
  final ProfileService profileService = ProfileService();
  List<BrowseCompetencyCardModel> _listOfCompetencies = [];
  List<BrowseCompetencyCardModel> _filteredListOfCompetencies = [];
  List<Profile> _profileDetails;

  List<Set<MultiSelectItem>> _allCompetencyArea;
  List<Set<MultiSelectItem>> _allCompetencyType;

  List<String> _selectedCompetencyTypes = [];
  List<String> _selectedCompetencyAreas = [];

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  var _selectedCompetencies = [];

  // final _textController = TextEditingController();

  bool _pageInitilized = false;
  bool _showLoader = false;
  // bool _showInitialLoader = false;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _generateTelemetryData();
    _fetchData();
    // _textController.addListener(_filterCompetencies);
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
      widget.isDesiredCompetencies
          ? TelemetryPageIdentifier.desiredCompetenciesPageId
          : TelemetryPageIdentifier.currentCompetenciesPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      widget.isDesiredCompetencies
          ? TelemetryPageIdentifier.desiredCompetenciesPageUri
          : TelemetryPageIdentifier.currentCompetenciesPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  _fetchData() async {
    await _getProfileDetails();
    await _getListOfCompetencies();
  }

  Future<List<Profile>> _getProfileDetails() async {
    _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    // print('Profile data: ' + _profileDetails[0].rawDetails.toString());
    await _populateFields();
    return _profileDetails;
  }

  Future<void> _populateFields() async {
    if (_profileDetails != null) {
      setState(() {
        _selectedCompetencies = widget.isDesiredCompetencies
            ? _profileDetails[0].desiredCompetencies
            : _profileDetails[0].competencies;
        // developer.log(jsonEncode(_selectedCompetencies));
      });
    }
  }

  Future<List<BrowseCompetencyCardModel>> _getListOfCompetencies() async {
    if (!_pageInitilized) {
      _listOfCompetencies =
          await Provider.of<CompetencyRepository>(context, listen: false)
              .getCompetencies();

      //getting list of competency types
      List<String> competencyTypes;
      competencyTypes =
          _listOfCompetencies.map((e) => e.competencyType).toList();
      var seen = Set<String>();
      competencyTypes =
          competencyTypes.where((type) => seen.add(type)).toList();
      competencyTypes.remove('');
      competencyTypes.remove('COMPETENCY');
      _allCompetencyType = competencyTypes
          .map((e) => {MultiSelectItem(itemName: e, isSelected: false)})
          .toList();
      // _allCompetencyType.insert(0, 'All');

      //getting list of competency area
      List<String> competencyAreas;
      competencyAreas =
          _listOfCompetencies.map((e) => e.competencyArea).toList();
      competencyAreas = competencyAreas
          .where((area) => seen.add(area.toString().trim()))
          .toList();
      competencyAreas.remove('');
      _allCompetencyArea = competencyAreas
          .map((e) => {MultiSelectItem(itemName: e, isSelected: false)})
          .toList();
      // _allCompetencyArea.insert(0, 'All');

      if (widget.isDesiredCompetencies) {
        _profileDetails[0].competencies.forEach((competency) {
          if (_listOfCompetencies
              .any((element) => element.id != competency['id'])) {
            _listOfCompetencies
                .removeWhere((element) => element.id == competency['id']);
          }
        });
      }

      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies;
        _pageInitilized = true;
      });
    }
    return _filteredListOfCompetencies;
  }

  _filterCompetencies(value) {
    // String value = _textController.text;
    setState(() {
      _filteredListOfCompetencies = _listOfCompetencies
          .where((competency) => competency.name
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
      // });
    });
  }

  void _sortCompetencies(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        _filteredListOfCompetencies
            .sort((a, b) => a.name.trim().compareTo(b.name.trim()));
      } else
        _filteredListOfCompetencies
            .sort((a, b) => b.name.trim().compareTo(a.name.trim()));
    });
  }

  Future<void> _saveProfile({
    String succussMessage = 'Updated successfully',
  }) async {
    Map _profileData;
    if (widget.isDesiredCompetencies) {
      _profileData = {'desiredCompetencies': _selectedCompetencies};
    } else {
      _profileData = {'competencies': _selectedCompetencies};
    }

    var response;
    try {
      response = await profileService.updateProfileDetails(_profileData);
      // print(response.toString());
      if (response['params']['status'] == 'success' ||
          response['params']['status'] == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(succussMessage),
            backgroundColor: AppColors.positiveLight,
          ),
        );
        // widget.getTopicSelectedStatus(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.errorMessage),
            backgroundColor: AppColors.negativeLight,
          ),
        );
      }
    } catch (err) {
      return err;
    }
  }

  List<Widget> _getLevels(BrowseCompetencyCardModel competency) {
    List<Widget> levels = [];
    List<dynamic> temp = competency.levels;

    int selectedLevelValue = 0;
    String selectedLevelName;
    String selectedLevel;
    String selectedLevelId;

    for (var selectedCompetency in _selectedCompetencies) {
      if (selectedCompetency['id'] == competency.id) {
        if (selectedCompetency['competencySelfAttestedLevel']
            .toString()
            .startsWith('CIL')) {
          selectedLevelId =
              selectedCompetency['competencySelfAttestedLevel'].toString();
        } else {
          selectedLevelValue = int.parse(
              selectedCompetency['competencySelfAttestedLevel']
                  .toString()
                  .split(' ')
                  .last);
        }
      }
    }

    for (int i = 0; i < temp.length; i++) {
      if (temp[i]['level'] != null && temp[i]['level'] != '') {
        int level = int.parse(temp[i]['level'].toString().split(' ').last);
        if (selectedLevelId != null && selectedLevelId.startsWith('CIL')) {
          temp[i]['isSelected'] =
              (selectedLevelId == temp[i]['id']) ? true : false;
        } else {
          temp[i]['isSelected'] = (selectedLevelValue == level) ? true : false;
        }

        levels.add(InkWell(
          onTap: () {
            setState(() {
              selectedLevelValue = level;
              selectedLevelId = temp[i]['id'];
              selectedLevelName = temp[i]['name'];
              selectedLevel = temp[i]['level'];
              temp[i]['isSelected'] = !temp[i]['isSelected'];
            });

            Map data = {
              "type": competency.type,
              "id": competency.id,
              "name": competency.name,
              "description": competency.description,
              "status": competency.status,
              "source": competency.source,
              "competencyType": competency.competencyType,
              "competencySelfAttestedLevel": selectedLevelId,
              "competencySelfAttestedLevelName": selectedLevelName,
              "competencySelfAttestedLevelValue": selectedLevel
            };

            if (temp.where((element) => element['isSelected'] == true).length >
                0) {
              var userTagged = _selectedCompetencies.where((competency) =>
                  (competency['id'].contains(data['id']) &&
                      competency['competencySelfAttestedLevel']
                          .toString()
                          .contains(
                              data['competencySelfAttestedLevel'].toString())));
              if (userTagged.length == 0) {
                _selectedCompetencies
                    .removeWhere((element) => element['id'] == data['id']);
                _selectedCompetencies.add(data);
                _selectedCompetencies = _selectedCompetencies.toSet().toList();
                _saveProfile();
              }
            } else {
              _selectedCompetencies
                  .removeWhere((element) => element['id'] == data['id']);
              _saveProfile();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: temp[i]['isSelected']
                  ? AppColors.primaryThree
                  : AppColors.grey04,
              border: Border.all(
                  color: temp[i]['isSelected']
                      ? AppColors.primaryThree
                      : AppColors.grey08),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Text(
                temp[i]['level'],
                style: GoogleFonts.lato(
                  color:
                      temp[i]['isSelected'] ? Colors.white : AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 1.0,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ));
      }
    }

    // print(temp.where((element) => element['isSelected'] == true.toString()));

    return levels;
  }

  _setFilters(index, value, selectedArea,
      {bool isCompetencyType = false, bool isCompetencyArea = false}) async {
    _selectedCompetencyTypes = [];
    _selectedCompetencyAreas = [];
    if (isCompetencyType) {
      _allCompetencyType.elementAt(index).first.isSelected = value;
    }
    if (isCompetencyArea) {
      var selectedIndex = (_allCompetencyArea
          .indexWhere((element) => element.first.itemName == selectedArea));
      _allCompetencyArea.elementAt(selectedIndex).first.isSelected = value;
    }

    _allCompetencyType.map((Set<MultiSelectItem> type) {
      if (type.first.isSelected == true) {
        _selectedCompetencyTypes.add(type.first.itemName);
      }
    }).toList();

    _allCompetencyArea.map((Set<MultiSelectItem> area) {
      if (area.first.isSelected == true) {
        _selectedCompetencyAreas.add(area.first.itemName);
      }
    }).toList();
    // developer.log('Types: ' + _selectedCompetencyTypes.toString());
    // developer.log('Area: ' + _selectedCompetencyAreas.toString());
  }

  _applyFilters() {
    List<BrowseCompetencyCardModel> filterByTypes = [];
    List<BrowseCompetencyCardModel> filterByAreas = [];
    if (_selectedCompetencyTypes.length > 0 &&
        _selectedCompetencyAreas.length == 0) {
      filterByTypes = [];
      for (var type in _selectedCompetencyTypes) {
        filterByTypes.addAll(_listOfCompetencies
            .where((competency) => competency.competencyType
                .toLowerCase()
                .contains(type.toLowerCase()))
            .toSet()
            .toList());
      }

      setState(() {
        _filteredListOfCompetencies = filterByTypes;
      });
    } else if (_selectedCompetencyAreas.length > 0 &&
        _selectedCompetencyTypes.length == 0) {
      filterByAreas = [];
      for (var area in _selectedCompetencyAreas) {
        filterByAreas.addAll(_listOfCompetencies
            .where((competency) => competency.competencyArea
                .toLowerCase()
                .contains(area.toLowerCase()))
            .toSet()
            .toList());
      }

      setState(() {
        _filteredListOfCompetencies = filterByAreas;
      });
    } else if (_selectedCompetencyAreas.length > 0 &&
        _selectedCompetencyTypes.length > 0) {
      filterByAreas = [];
      filterByTypes = [];
      for (var type in _selectedCompetencyTypes) {
        filterByTypes.addAll(_listOfCompetencies
            .where((competency) => competency.competencyType
                .toLowerCase()
                .contains(type.toLowerCase()))
            .toSet()
            .toList());
      }
      for (var area in _selectedCompetencyAreas) {
        filterByAreas.addAll(filterByTypes
            .where((competency) => competency.competencyArea
                .toLowerCase()
                .contains(area.toLowerCase()))
            .toSet()
            .toList());
      }

      setState(() {
        _filteredListOfCompetencies = filterByAreas;
      });
    } else {
      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies;
      });
    }
  }

  _resetToDefault() async {
    setState(() {
      _showLoader = true;
      _pageInitilized = false;
      _selectedCompetencyTypes.clear();
      _selectedCompetencyAreas.clear();
    });
    await _getListOfCompetencies();
    setState(() {
      _showLoader = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.78,
                // width: 316,
                height: 48,
                child: TextFormField(
                    // controller: _textController,
                    onChanged: (value) {
                      _filterCompetencies(value);
                      // filterAddedCompetencies(value);
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.lato(fontSize: 14.0),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      contentPadding:
                          EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: AppColors.grey16,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.0),
                        borderSide: BorderSide(
                          color: AppColors.primaryThree,
                        ),
                      ),
                      hintText: EnglishLang.search,
                      hintStyle: GoogleFonts.lato(
                          color: AppColors.greys60,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
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
                  color: (_selectedCompetencyTypes.length == 0 &&
                          _selectedCompetencyAreas.length == 0)
                      ? Colors.white
                      : AppColors.primaryThree,
                  borderRadius: BorderRadius.all(const Radius.circular(4.0)),
                  border: Border.all(color: AppColors.grey16),
                ),
                child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: (_selectedCompetencyTypes.length == 0 &&
                              _selectedCompetencyAreas.length == 0)
                          ? AppColors.greys60
                          : Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FilterCompetencies(
                              applyFilter: _applyFilters,
                              updateSelection: _setFilters,
                              competencyTypes: _allCompetencyType,
                              competencyAreas: _allCompetencyArea,
                              resetToDefault: _resetToDefault,
                            ),
                          ),
                        )),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    // width: double.infinity,
                    // margin: EdgeInsets.only(bottom: 12),
                    child: DropdownButton<String>(
                      value: dropdownValue != null ? dropdownValue : null,
                      icon: Icon(Icons.arrow_drop_down_outlined),
                      iconSize: 22,
                      // elevation: 16,
                      hint: Container(
                          alignment: Alignment.center,
                          // margin: EdgeInsets.only(left: 8),
                          child: Text('Sort by: ')),
                      style: TextStyle(color: AppColors.greys87),
                      underline: Container(
                        // height: 2,
                        color: AppColors.lightGrey,
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return dropdownItems.map<Widget>((String item) {
                          return Row(
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(4, 15.0, 0, 15.0),
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
                        _sortCompetencies(dropdownValue);
                      },
                      items: dropdownItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.grey40,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => CompetenciesInfo());
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("What are competencies?",
                        style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            letterSpacing: 0.12,
                            fontSize: 16)),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          _pageInitilized
              ? ((_filteredListOfCompetencies != null &&
                      _filteredListOfCompetencies.length > 0)
                  ? (!_showLoader
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredListOfCompetencies.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              width: double.infinity,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: Text(
                                                          _filteredListOfCompetencies[
                                                                          index]
                                                                      .name !=
                                                                  null
                                                              ? _filteredListOfCompetencies[
                                                                      index]
                                                                  .name
                                                              : '',
                                                          // "Name of the competency",
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: AppColors
                                                                .greys87,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4),
                                                        child: Text(
                                                          _filteredListOfCompetencies[
                                                                          index]
                                                                      .competencyType !=
                                                                  null
                                                              ? _filteredListOfCompetencies[
                                                                      index]
                                                                  .competencyType
                                                              : '',
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: AppColors
                                                                .greys60,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              VerticalDivider(
                                                thickness: 1,
                                                width: 20,
                                                color: AppColors.grey16,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.48,
                                                child: Text(
                                                  _filteredListOfCompetencies[
                                                                  index]
                                                              .description !=
                                                          null
                                                      ? _filteredListOfCompetencies[
                                                              index]
                                                          .description
                                                      : '',
                                                  // "Design and set up interface and interconnections from or among sensors, through a network, to a main location, to enable transmission of information",
                                                  style: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('Select level',
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys60,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                )),
                                            IconButton(
                                              onPressed: () => showDialog(
                                                  context: context,
                                                  builder: (ctx) => LevelInfo(
                                                        levelDetails:
                                                            _filteredListOfCompetencies[
                                                                    index]
                                                                .levels,
                                                      )),
                                              icon: Icon(Icons.info_outline),
                                              color: AppColors.grey40,
                                              iconSize: 22,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _getLevels(
                                          _filteredListOfCompetencies[index]),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : PageLoader(
                          bottom: 400,
                        ))
                  : _filteredListOfCompetencies.length == 0
                      ? Container(
                          margin: EdgeInsets.only(top: 32),
                          child: Center(child: Text('No competencies found')))
                      : PageLoader(top: 250))
              : PageLoader(
                  bottom: 400,
                ),
          SizedBox(
            height: 120,
          )
        ],
      ),
    ));
  }
}
