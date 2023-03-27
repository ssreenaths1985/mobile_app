import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/_models/profile_model.dart';
import 'package:provider/provider.dart';
import '../../../respositories/_respositories/profile_repository.dart';
import './../../../constants/index.dart';
import './../../../respositories/index.dart';
import './../../../services/_services/network_service.dart';
import './../../../ui/pages/index.dart';
import './../../../util/faderoute.dart';
import './../../../util/helper.dart';
import './../../../localization/index.dart';

//ignore: must_be_immutable
class PeopleYouMayKnow extends StatefulWidget {
  final peopleYouMayKnow;
  final String sortBy;
  String searchText;
  final getNetworkCount;
  final bool isFromMyMDO;

  PeopleYouMayKnow(
      {this.peopleYouMayKnow,
      this.sortBy,
      this.searchText,
      this.getNetworkCount,
      this.isFromMyMDO = false});
  @override
  _PeopleYouMayKnowState createState() => _PeopleYouMayKnowState();
}

class _PeopleYouMayKnowState extends State<PeopleYouMayKnow> {
  dynamic _response;
  dynamic _data;
  List<dynamic> _requestedConnections = [];

  @override
  void initState() {
    super.initState();
    _sortMembers(widget.sortBy);
    _getRequestedConnections();
  }

  void _sortMembers(sortBy) async {
    _data = widget.peopleYouMayKnow;
    if (sortBy == EnglishLang.sortByName) {
      setState(() {
        _data.sort((a, b) => a['personalDetails']['firstname']
            .toString()
            .toLowerCase()
            .compareTo(
                b['personalDetails']['firstname'].toString().toLowerCase()));
      });
    }
  }

  _filterNetworks() async {
    setState(() {
      _data = widget.peopleYouMayKnow.where((network) =>
          ((network['personalDetails']['firstname'] +
                  network['personalDetails']['surname'])
              .toString()
              .toLowerCase()
              .contains(widget.searchText)));
    });
    if (_data != null) {
      widget.getNetworkCount(_data.length);
    }
  }

  /// Post connection request
  createConnectionRequest(context, id) async {
    try {
      List<Profile> profileDetailsFrom;
      profileDetailsFrom =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById('');
      List<Profile> profileDetailsTo;
      profileDetailsTo =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getProfileDetailsById(id);
      _response = await NetworkService.postConnectionRequest(
          id, profileDetailsFrom, profileDetailsTo);

      if (_response['result']['status'] == 'CREATED') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.connectionRequestSent),
            backgroundColor: AppColors.positiveLight,
          ),
        );
        await _getRequestedConnections();
        try {
          final dataNode =
              await Provider.of<NetworkRespository>(context, listen: false)
                  .getAllUsersFromMDO();

          setState(() {
            _data = dataNode.data;
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

  _getRequestedConnections() async {
    final response =
        await Provider.of<NetworkRespository>(context, listen: false)
            .getRequestedConnections();
    setState(() {
      _requestedConnections = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data != widget.peopleYouMayKnow) {
      _sortMembers(widget.sortBy);
    }
    if (widget.isFromMyMDO &&
        (widget.searchText != null && widget.peopleYouMayKnow != null)) {
      _filterNetworks();
    }
    if (_data != null && _data.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                Column(
                  children: [
                    for (var item in _data)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: ChangeNotifierProvider<NetworkRespository>(
                                create: (context) => NetworkRespository(),
                                child: NetworkProfile(item['id']),
                              ),
                            ),
                          );
                        },
                        child: Wrap(
                          children: [
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: AppColors.lightBackground,
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
                                              color: AppColors.positiveLight,
                                              borderRadius: BorderRadius.all(
                                                  const Radius.circular(4.0)),
                                            ),
                                            child: Center(
                                              child: item['photo'] != null &&
                                                      item['photo'] != ''
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.memory(
                                                          Helper.getByteImage(
                                                              item['photo'])))
                                                  : item['profileDetails'] !=
                                                          null
                                                      ? (Text(
                                                          (item['profileDetails'][
                                                                          'personalDetails'] !=
                                                                      null &&
                                                                  (item['profileDetails']['personalDetails']['firstname'] !=
                                                                          null &&
                                                                      item['profileDetails']['personalDetails']['surname'] !=
                                                                          null)
                                                              ? (Helper.getInitials(item['profileDetails']
                                                                              ['personalDetails'][
                                                                          'firstname']
                                                                      .trim() +
                                                                  ' ' +
                                                                  item['profileDetails']
                                                                              ['personalDetails']
                                                                          ['surname']
                                                                      .trim()))
                                                              : ('UN')),
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ))
                                                      : (Text(
                                                          item['personalDetails'] !=
                                                                  null
                                                              ? Helper.getInitials(item[
                                                                              'personalDetails']
                                                                          [
                                                                          'firstname']
                                                                      .trim() +
                                                                  ' ' +
                                                                  item['personalDetails']
                                                                          [
                                                                          'surname']
                                                                      .trim())
                                                              : 'UN',
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        )),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['profileDetails'] != null
                                                  ? (item['profileDetails'][
                                                              'personalDetails'] !=
                                                          null
                                                      ? (item['profileDetails']['personalDetails']['firstname'] !=
                                                                  null &&
                                                              item['profileDetails']['personalDetails']['surname'] !=
                                                                  null)
                                                          ? (item['profileDetails']
                                                                      ['personalDetails'][
                                                                  'firstname'] +
                                                              ' ' +
                                                              item['profileDetails']
                                                                      ['personalDetails']
                                                                  ['surname'])
                                                          : ('Unknown user')
                                                      : 'Unknown user')
                                                  : (item['personalDetails'] != null
                                                      ? item['personalDetails']
                                                              ['firstname'] +
                                                          ' ' +
                                                          item['personalDetails']
                                                              ['surname']
                                                      : 'User name'),
                                              style: GoogleFonts.lato(
                                                  color: AppColors.greys87,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Text(
                                                  item['profileDetails'] != null
                                                      ? ((item['profileDetails']['employmentDetails'] !=
                                                                  null &&
                                                              item['profileDetails']
                                                                          ['employmentDetails'][
                                                                      'departmentName'] !=
                                                                  null)
                                                          ? item['profileDetails']
                                                                  ['employmentDetails']
                                                              ['departmentName']
                                                          : '')
                                                      : ((item['employmentDetails'] !=
                                                                  null &&
                                                              item['employmentDetails'][
                                                                      'departmentName'] !=
                                                                  null)
                                                          ? item['employmentDetails']
                                                              ['departmentName']
                                                          : ''),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                      color: AppColors.greys60,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (!_requestedConnections.any(
                                          (element) =>
                                              element['id'] == item['id'])) {
                                        createConnectionRequest(
                                            context, item['id']);
                                      }
                                    },
                                    style: ButtonStyle(
                                      splashFactory: _requestedConnections.any(
                                              (element) =>
                                                  element['id'] == item['id'])
                                          ? NoSplash.splashFactory
                                          : null,
                                    ),
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          _requestedConnections.any((element) =>
                                                  element['id'] == item['id'])
                                              ? EnglishLang.connectionSent
                                              : EnglishLang.connect,
                                          style: GoogleFonts.lato(
                                            color: _requestedConnections.any(
                                                    (element) =>
                                                        element['id'] ==
                                                        item['id'])
                                                ? AppColors.grey40
                                                : AppColors.primaryThree,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
      return Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SvgPicture.asset(
                      'assets/img/empty_search.svg',
                      alignment: Alignment.center,
                      // color: AppColors.grey16,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  EnglishLang.noResultsFound,
                  style: GoogleFonts.lato(
                    color: AppColors.greys60,
                    fontWeight: FontWeight.w700,
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
      // return Container(
      //   margin: EdgeInsets.only(top: 20.0),
      //   child: Column(
      //     children: [
      //       Wrap(
      //         alignment: WrapAlignment.start,
      //         children: [
      //           Column(
      //             children: [Center()],
      //           )
      //         ],
      //       )
      //     ],
      //   ),
      // );
    }
  }
}
