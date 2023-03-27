import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:provider/provider.dart';
import '../index.dart';
import './../../../constants/index.dart';
import './../../../respositories/index.dart';
import './../../../ui/pages/index.dart';
import './../../../util/faderoute.dart';
import './../../../util/helper.dart';
// import './../../../localization/_langs/english_lang.dart';

class MyConnectionCard extends StatefulWidget {
  final establishedConnections;
  final bool isRecommended;

  MyConnectionCard(this.establishedConnections, {this.isRecommended = false});
  @override
  _MyConnectionCardState createState() => _MyConnectionCardState();
}

class _MyConnectionCardState extends State<MyConnectionCard> {
  List _tempData = [];
  List _filteredData = [];
  dynamic _data;
  String _dropdownValue = EnglishLang.lastAdded;
  bool _pageInitialized = false;
  List<String> dropdownItems = [EnglishLang.lastAdded, EnglishLang.sortByName];

  @override
  void initState() {
    super.initState();
    setState(() {
      _data = widget.establishedConnections;
    });

    // print(ids.toString());
  }

  /// Get connection request response
  Future<List> _getUserNames(context) async {
    try {
      if (!_pageInitialized) {
        List ids = [];
        if (_data != null) {
          for (int i = 0; i < _data.data.length; i++) {
            ids.add(_data.data[i]['id']);
          }
        }
        if (ids.length > 0) {
          _tempData =
              await Provider.of<NetworkRespository>(context, listen: false)
                  .getUsersNames(ids);
          _filteredData = _tempData;
        }
        setState(() {
          _pageInitialized = true;
        });
      }
      if (_dropdownValue == EnglishLang.sortByName) {
        setState(() {
          _filteredData.sort((a, b) => (a['profileDetails']['personalDetails']
                      ['firstname'] +
                  a['profileDetails']['personalDetails']['surname'])
              .toLowerCase()
              .compareTo((b['profileDetails']['personalDetails']['firstname'] +
                      b['profileDetails']['personalDetails']['surname'])
                  .toLowerCase()));
        });
      } else if (_dropdownValue == EnglishLang.lastAdded) {
        setState(() {
          _filteredData = _tempData.toList();
        });
      }
      return _filteredData;
    } catch (err) {
      return err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserNames(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data.length == 0)
              return widget.isRecommended
                  ? Center()
                  : Stack(
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: SvgPicture.asset(
                                    'assets/img/connections.svg',
                                    alignment: Alignment.center,
                                    // width: MediaQuery.of(context).size.width,
                                    // height: MediaQuery.of(context).size.height,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                EnglishLang.noRequests,
                                style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 1.5,
                                  letterSpacing: 0.25,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                EnglishLang.noRequestText,
                                style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 1.5,
                                  letterSpacing: 0.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            else
              return Container(
                margin: EdgeInsets.only(top: 4.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 10.0),
                          child: Text(
                            "${_filteredData.length} ${_filteredData.length == 1 ? EnglishLang.connection : EnglishLang.connections}",
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          // width: double.infinity,
                          margin: EdgeInsets.only(right: 16, top: 8),
                          child: DropdownButton<String>(
                            value:
                                _dropdownValue != null ? _dropdownValue : null,
                            icon: Icon(Icons.arrow_drop_down_outlined),
                            iconSize: 26,
                            elevation: 16,
                            hint: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 16),
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
                                _dropdownValue = newValue;
                                // _sortMembers(_dropdownValue);
                              });
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
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Column(
                          children: [
                            for (int i = 0; i < _filteredData.length; i++)
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: ChangeNotifierProvider<
                                        NetworkRespository>(
                                      create: (context) => NetworkRespository(),
                                      child: NetworkProfile(
                                          _filteredData[i]['id']),
                                    ),
                                  ),
                                ),
                                child: Wrap(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.only(bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: AppColors
                                                        .lightBackground,
                                                    width: 2.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Container(
                                                    height: 48,
                                                    width: 48,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .positiveLight,
                                                      borderRadius: BorderRadius
                                                          .all(const Radius
                                                              .circular(4.0)),
                                                    ),
                                                    child: Center(
                                                      child:
                                                          _filteredData[i]['profileDetails'] !=
                                                                      null &&
                                                                  (_filteredData[i]
                                                                              ['profileDetails']
                                                                          [
                                                                          'photo'] !=
                                                                      null)
                                                              ? Container(
                                                                  child: _filteredData[i]['profileDetails']['photo']
                                                                              .length !=
                                                                          0
                                                                      ? (ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50),
                                                                          child: Image.memory(Helper.getByteImage(_filteredData[i]['profileDetails']['photo']))))
                                                                      : (Text(
                                                                          Helper.getInitials(_filteredData[i]['profileDetails']['personalDetails']['firstname'] +
                                                                              ' ' +
                                                                              _filteredData[i]['profileDetails']['personalDetails']['surname']),
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14.0,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                        )))
                                                              : Text(
                                                                  // item['name'] != null
                                                                  //     ? Helper.getInitials(
                                                                  //         item['name'] +
                                                                  //             ' ')
                                                                  //     : 'UN',
                                                                  Helper.getInitials(_filteredData[i]['profileDetails']
                                                                              [
                                                                              'personalDetails']
                                                                          [
                                                                          'firstname'] +
                                                                      ' ' +
                                                                      _filteredData[i]
                                                                              [
                                                                              'profileDetails']['personalDetails']
                                                                          [
                                                                          'surname']),
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _filteredData[i][
                                                                          'profileDetails']
                                                                      [
                                                                      'personalDetails'] !=
                                                                  null
                                                              ? _filteredData[i]
                                                                              [
                                                                              'profileDetails']
                                                                          [
                                                                          'personalDetails']
                                                                      [
                                                                      'firstname'] +
                                                                  ' ' +
                                                                  _filteredData[i]
                                                                              [
                                                                              'profileDetails']
                                                                          [
                                                                          'personalDetails']
                                                                      [
                                                                      'surname']
                                                              : 'UN',
                                                          style: GoogleFonts.lato(
                                                              color: AppColors
                                                                  .greys87,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.0),
                                                          child: Text(
                                                            _filteredData[i][
                                                                        'rootOrgName'] !=
                                                                    null
                                                                ? _filteredData[
                                                                        i][
                                                                    'rootOrgName']
                                                                : '',
                                                            style: GoogleFonts.lato(
                                                                color: AppColors
                                                                    .greys60,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Column(
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: [
                                          //     IconButton(
                                          //       onPressed: () {},
                                          //       icon: Icon(
                                          //         Icons.more_vert,
                                          //         color: AppColors.greys60,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
          } else {
            return PageLoader(
              bottom: 175,
            );
          }
          // EmptyState({
          //   'isNetwork': true,
          //   'message': 'No connections',
          //   'messageHeading':
          //       'Looks like there are no connection  \n    requests at the moment'
          // });
        });
  }
}
