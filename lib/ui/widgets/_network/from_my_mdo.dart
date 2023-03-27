import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/_models/profile_model.dart';
import '../../../respositories/_respositories/profile_repository.dart';
import './../../../constants/index.dart';
import './../../../respositories/index.dart';
import './../../../services/_services/network_service.dart';
import './../../../util/helper.dart';
import './../../../util/faderoute.dart';
import './../../../ui/pages/index.dart';
import './../../../localization/_langs/english_lang.dart';

//ignore: must_be_immutable
class FromMyMDO extends StatefulWidget {
  final fromMyMDO;

  FromMyMDO(this.fromMyMDO);
  @override
  _FromMyMDOState createState() => _FromMyMDOState();
}

class _FromMyMDOState extends State<FromMyMDO> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic _response;

  List _data = [];
  List<dynamic> _requestedConnections = [];

  @override
  void initState() {
    super.initState();
    _getRequestedConnections();
    setState(() {
      _data = widget.fromMyMDO;
    });
  }

  _getRequestedConnections() async {
    final response =
        await Provider.of<NetworkRespository>(context, listen: false)
            .getRequestedConnections();
    setState(() {
      _requestedConnections = response;
    });
    // print(_requestedConnections.toString());
  }

  /// Post connection request
  createConnectionRequest(id) async {
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
      if (_response['result']['message'] == 'Successful') {
        ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.connectionRequestSent),
            backgroundColor: AppColors.positiveLight,
            // duration: const Duration(milliseconds: 2000),
            // behavior: SnackBarBehavior.floating,
          ),
        );
        await _getRequestedConnections();
        try {
          final dataNode =
              await Provider.of<NetworkRespository>(context, listen: false)
                  .getAllUsersFromMDO();

          setState(() {
            _data = dataNode;
          });
        } catch (err) {
          return err;
        }
      } else {
        ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
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
    if (_data.length > 0) {
      return Container(
        key: _scaffoldKey,
        width: double.infinity,
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                SizedBox(
                  height: 250.0,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, index) => Container(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(05),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.grey04,
                                blurRadius: 8.0,
                                spreadRadius: 0.0)
                          ],
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            for (var i = 0;
                                i < (_data.length > 4 ? 5 : _data.length);
                                i++)
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: ChangeNotifierProvider<
                                        NetworkRespository>(
                                      create: (context) => NetworkRespository(),
                                      child: NetworkProfile(_data[i]['id']),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 200.0,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.grey08,
                                        blurRadius: 6.0,
                                        spreadRadius: 0,
                                        offset: Offset(
                                          3,
                                          3,
                                        ),
                                      )
                                    ],
                                    border: Border.all(color: AppColors.grey08),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  // height: double.infinity,
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 75,
                                          // width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          color: AppColors.ghostWhite,
                                          child: Center(
                                            child: _data[i]['photo'] != null &&
                                                    _data[i]['photo'] != ''
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.memory(
                                                        Helper.getByteImage(
                                                            _data[i]['photo'])))
                                                : Container(
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
                                                        Helper.getInitials(_data[
                                                                        i][
                                                                    'personalDetails']
                                                                ['firstname'] +
                                                            ' ' +
                                                            _data[i][
                                                                    'personalDetails']
                                                                ['surname']),
                                                        style: GoogleFonts.lato(
                                                            color: AppColors
                                                                .avatarText,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ),
                                          )),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          child: Text(
                                            Helper.capitalize(_data[i]
                                                        ['personalDetails']
                                                    ['firstname']) +
                                                ' ' +
                                                Helper.capitalize(_data[i]
                                                        ['personalDetails']
                                                    ['surname']),
                                            maxLines: 1,
                                            style: GoogleFonts.lato(
                                              color: AppColors.greys87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        constraints:
                                            BoxConstraints(minHeight: 50),
                                        child: Text(
                                          _data[i]['employmentDetails']
                                              ['departmentName'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                            color: AppColors.greys60,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if (!_requestedConnections.any(
                                                (element) =>
                                                    element['id'] ==
                                                    _data[i]['id']
                                                        .toString())) {
                                              createConnectionRequest(
                                                  _data[i]['id']);
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            // primary: Colors.white,
                                            splashFactory: _requestedConnections
                                                    .any((element) =>
                                                        element['id'] ==
                                                        _data[i]['id']
                                                            .toString())
                                                ? NoSplash.splashFactory
                                                : null,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                side: BorderSide(
                                                    color: AppColors.grey16)),
                                            // onSurface: Colors.grey,
                                          ),
                                          child: Text(
                                            !_requestedConnections.any(
                                                    (element) =>
                                                        element['id'] ==
                                                        _data[i]['id']
                                                            .toString())
                                                ? EnglishLang.connect
                                                : EnglishLang.connectionSent,
                                            style: GoogleFonts.lato(
                                                color: !_requestedConnections
                                                        .any((element) =>
                                                            element['id'] ==
                                                            _data[i]['id']
                                                                .toString())
                                                    ? AppColors.primaryThree
                                                    : AppColors.grey40,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                Column(
                  children: [Center()],
                )
              ],
            )
          ],
        ),
      );
    }
  }
}
