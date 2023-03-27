import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/feedback/widgets/index.dart';
// import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:provider/provider.dart';
import './../../../constants/index.dart';
import './../../../respositories/index.dart';
import './../../../services/index.dart';
import './../../../ui/pages/index.dart';
import './../../../util/faderoute.dart';
import './../../../util/helper.dart';
import './../../../localization/_langs/english_lang.dart';

//ignore: must_be_immutable
class ConnectionRequests extends StatefulWidget {
  final connectionRequests;
  bool isShow;
  bool isFromHome;
  final parentAction;

  ConnectionRequests(this.connectionRequests, this.isShow,
      {this.isFromHome = false, this.parentAction});
  @override
  _ConnectionRequestsState createState() => _ConnectionRequestsState();
}

class _ConnectionRequestsState extends State<ConnectionRequests> {
  dynamic _response;
  List _tempData = [];
  List _filteredData = [];
  String _dropdownValue = EnglishLang.lastAdded;
  bool _pageInitialized = false;
  List<String> dropdownItems = [EnglishLang.lastAdded, EnglishLang.sortByName];
  dynamic _data;

  @override
  void initState() {
    super.initState();
    setState(() {
      _data = widget.connectionRequests;
    });

    // print(widget.connectionRequests.toString());
  }

  /// Get connection request response
  Future<List> _getUserNames(context) async {
    try {
      if (!_pageInitialized) {
        List ids = [];
        if (widget.connectionRequests != null) {
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
      // print('_filteredData: ' + _filteredData.toString());
      return _filteredData;
    } catch (err) {
      return err;
    }
  }

  /// Post accept / reject
  postRequestStatus(context, status, connectionId, connectionDepartment) async {
    try {
      _response = await NetworkService.postAcceptReject(
          status, connectionId, connectionDepartment);

      if (_response['result']['message'] == 'Successful') {
        if (status == 'Approved') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(EnglishLang.connectionRequestSent),
              backgroundColor: AppColors.positiveLight,
            ),
          );
        }

        if (status == 'Rejected') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(EnglishLang.connectionRequestRejected),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }

        try {
          final dataNode =
              await Provider.of<NetworkRespository>(context, listen: false)
                  .getCrList();

          setState(() {
            _data = dataNode;
          });
        } catch (err) {
          return err;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.errorMessage),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } catch (err) {
      return err;
    }

    return _response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserNames(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data.length == 0) {
              return !widget.isFromHome
                  ? Stack(
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 60),
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
                                'No requests',
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
                                'Looks like there are no connection  \n       requests at the moment',
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
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('No connection requests!'),
                        ),
                      ),
                    );
            } else {
              return Container(
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Column(
                          children: [
                            if (widget.isShow)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        15.0, 18.0, 15.0, 15.0),
                                    child: Text(
                                      _filteredData.length.toString() +
                                          ' ' +
                                          EnglishLang.connectionRequests,
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: double.infinity,
                                    margin: EdgeInsets.only(right: 16, top: 8),
                                    child: DropdownButton<String>(
                                      value: _dropdownValue != null
                                          ? _dropdownValue
                                          : null,
                                      icon:
                                          Icon(Icons.arrow_drop_down_outlined),
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
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 15.0, 0, 15.0),
                                                  child: Text(
                                                    item,
                                                    style: GoogleFonts.lato(
                                                      color: AppColors.greys87,
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
                              ),
                          ],
                        ),
                        Column(
                          children: [
                            for (int i = 0;
                                i <
                                    (widget.isFromHome
                                        ? (_filteredData.length > 1 ? 2 : 1)
                                        : _filteredData.length);
                                i++)
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      child: Text(
                                                        _filteredData[i][
                                                                    'profileDetails'] !=
                                                                null
                                                            ? Helper.getInitials(_filteredData[i]
                                                                            ['profileDetails']
                                                                        ['personalDetails']
                                                                    [
                                                                    'firstname'] +
                                                                ' ' +
                                                                (_filteredData[i]['profileDetails']['personalDetails']['surname'] !=
                                                                        null
                                                                    ? _filteredData[i]['profileDetails']
                                                                            ['personalDetails']
                                                                        ['surname']
                                                                    : ''))
                                                            : 'UN',
                                                        style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _filteredData[i][
                                                                  'profileDetails'] !=
                                                              null
                                                          ? _filteredData[i]
                                                                          ['profileDetails']
                                                                      ['personalDetails'][
                                                                  'firstname'] +
                                                              ' ' +
                                                              (_filteredData[i]['profileDetails']['surname'] !=
                                                                          '' ||
                                                                      _filteredData[i]['profileDetails']['surname'] !=
                                                                          null
                                                                  ? _filteredData[i]
                                                                              ['profileDetails']
                                                                          ['personalDetails']
                                                                      ['surname']
                                                                  : '')
                                                          : 'UN',
                                                      style: GoogleFonts.lato(
                                                          color:
                                                              AppColors.greys87,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Text(
                                                        _filteredData[i][
                                                                    'rootOrgName'] !=
                                                                null
                                                            ? _filteredData[i]
                                                                ['rootOrgName']
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
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      postRequestStatus(
                                                          context,
                                                          EnglishLang.rejected,
                                                          _filteredData[i]
                                                              ['id'],
                                                          _filteredData[i]
                                                              ['rootOrgName']);
                                                    },
                                                    child: Text(
                                                      EnglishLang.reject,
                                                      style: GoogleFonts.lato(
                                                        color:
                                                            AppColors.greys60,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 15.0, 20.0, 15.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      postRequestStatus(
                                                          context,
                                                          EnglishLang.approved,
                                                          _filteredData[i]
                                                              ['id'],
                                                          _filteredData[i]
                                                              ['rootOrgName']);
                                                    },
                                                    child: Text(
                                                      EnglishLang.approve,
                                                      style: GoogleFonts.lato(
                                                        color: AppColors
                                                            .primaryThree,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            (_filteredData.length > 2 && widget.isFromHome)
                                ? Container(
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: InkWell(
                                        onTap: () {
                                          widget.parentAction(2);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4),
                                              child: Text(
                                                'See all  ${_filteredData.length}',
                                                style: GoogleFonts.lato(
                                                    color:
                                                        AppColors.primaryThree,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_right,
                                              color: AppColors.primaryThree,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Center()
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          } else {
            return PageLoader(
              bottom: 150,
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
