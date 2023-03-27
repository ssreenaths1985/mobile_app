import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../constants/index.dart';
import './../../../../respositories/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../localization/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';

// import 'dart:developer' as developer;

class MyMDO extends StatefulWidget {
  final bool isRecommended;

  const MyMDO({Key key, this.isRecommended = false}) : super(key: key);
  @override
  _MyMDOState createState() => _MyMDOState();
}

class _MyMDOState extends State<MyMDO> {
  final TelemetryService telemetryService = TelemetryService();
  dynamic _filteredListOfNetworks = [];
  dynamic _networks = [];
  // List<dynamic> _requestedConnections = [];
  String _searchText = '';
  int _connectionCount;

  String _dropdownValue = EnglishLang.lastAdded;
  List<String> dropdownItems = [EnglishLang.lastAdded, EnglishLang.sortByName];

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  int _start = 0;
  List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _getConnectedList(context);
    _getAllConnections(context);
    if (_start == 0) {
      allEventsData = [];
      _generateTelemetryData();
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
      TelemetryPageIdentifier.myMdoPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.myMdoPageUri,
    );
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  /// Get established connections
  Future<void> _getConnectedList(context) async {
    try {
      return await Provider.of<NetworkRespository>(context, listen: false)
          .getEstablishedConnectionList();
    } catch (err) {
      return err;
    }
  }

  /// Get PYMK response
  Future<dynamic> _getPymk(context) async {
    try {
      return Provider.of<NetworkRespository>(context, listen: false)
          .getPymkList();
    } catch (err) {
      return err;
    }
  }

  /// Get connections from the user MDO
  Future<dynamic> _getAllConnections(context) async {
    try {
      _networks = await Provider.of<NetworkRespository>(context, listen: false)
          .getAllUsersFromMDO();

      _filteredListOfNetworks = _networks;

      // if (widget.isRecommended) {
      //   dynamic recommendedConnections = await _getPymk(context);

      //   // print('Length: ' + recommendedConnections[1]['surname'].toString());
      //   if (recommendedConnections != null &&
      //       recommendedConnections.length > 0) {
      //     // _networks =
      //     _filteredListOfNetworks =
      //         _filteredListOfNetworks.addAll(recommendedConnections);
      //   }
      // }

      return _networks;
    } catch (err) {
      return err;
    }
  }

  Future<int> _getCountOfNetworks(int count) async {
    _connectionCount = count;
    return count;
  }

  @override
  void dispose() async {
    super.dispose();
  }

  /// Navigate to discussion detail
  // _navigateToDetail(tid) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ChangeNotifierProvider<DiscussRepository>(
  //         create: (context) => DiscussRepository(),
  //         child: DiscussionPage(tid: tid),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Wrap(
        children: [
          !widget.isRecommended
              ? FutureBuilder(
                  future: _getConnectedList(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return snapshot.data.data != null
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                // Padding(
                                //   padding: EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 10.0),
                                //   child: Text(
                                //     EnglishLang.connected,
                                //     style: GoogleFonts.lato(
                                //       color: AppColors.greys87,
                                //       fontSize: 16.0,
                                //       fontWeight: FontWeight.w700,
                                //     ),
                                //   ),
                                // ),
                                Wrap(
                                  children: [
                                    MyConnectionCard(
                                      snapshot.data,
                                      isRecommended: true,
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Center();
                    } else {
                      return PageLoader(
                        bottom: 150,
                      );
                    }
                  },
                )
              : Center(),
          FutureBuilder(
            future: _getAllConnections(context),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return snapshot.data != null
                    ? Wrap(
                        // alignment: WrapAlignment.start,
                        children: [
                          !widget.isRecommended
                              ? Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.fromLTRB(12, 16, 12, 0),
                                  width: MediaQuery.of(context).size.width,
                                  // width: 316,
                                  height: 48,
                                  child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          _searchText = value;
                                        });
                                      },
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      style: GoogleFonts.lato(fontSize: 14.0),
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
                                        hintText: EnglishLang.search,
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
                                )
                              : Center(),
                          !widget.isRecommended
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _filteredListOfNetworks != null
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15.0, 18.0, 15.0, 10.0),
                                            child: Text(
                                              EnglishLang.allMembers +
                                                  ' (' +
                                                  (_connectionCount != null
                                                      ? _connectionCount
                                                          .toString()
                                                      : _filteredListOfNetworks
                                                          .length
                                                          .toString()) +
                                                  ')',
                                              style: GoogleFonts.lato(
                                                color: AppColors.greys87,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          )
                                        : Center(),
                                    Container(
                                      // width: double.infinity,
                                      margin:
                                          EdgeInsets.only(right: 16, top: 8),
                                      child: DropdownButton<String>(
                                        value: _dropdownValue != null
                                            ? _dropdownValue
                                            : null,
                                        icon: Icon(
                                            Icons.arrow_drop_down_outlined),
                                        iconSize: 26,
                                        elevation: 16,
                                        hint: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 16),
                                            child: Text('Sort by: ')),
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
                                            _dropdownValue = newValue;
                                            // _sortMembers(_dropdownValue);
                                          });
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
                                )
                              : Center(),
                          Wrap(
                            children: [
                              PeopleYouMayKnow(
                                peopleYouMayKnow: _filteredListOfNetworks,
                                sortBy: _dropdownValue,
                                searchText: _searchText,
                                getNetworkCount: _getCountOfNetworks,
                                isFromMyMDO:
                                    widget.isRecommended ? false : true,
                              ),
                            ],
                          ),
                          !widget.isRecommended
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 65),
                                  child: Center(),
                                )
                              : Center()
                        ],
                      )
                    : Center();
              } else {
                return PageLoader(
                  bottom: 150,
                );
              }
            },
          ),
          widget.isRecommended
              ? FutureBuilder(
                  future: _getPymk(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return (snapshot.data != null && snapshot.data.length > 0)
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    PeopleYouMayKnow(
                                      peopleYouMayKnow: snapshot.data,
                                      // isFromMyMDO: true,
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 65),
                                  child: Center(),
                                )
                              ],
                            )
                          : Center();
                    } else {
                      return Center();
                    }
                  },
                )
              : Center(),
          SizedBox(
            height: 60,
          )
        ],
      ),
    ));
  }
}
