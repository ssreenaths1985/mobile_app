import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:provider/provider.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';
import './../../../util/faderoute.dart';
import './../../../respositories/index.dart';
import './../../../ui/pages/index.dart';

class PeopleItem extends StatefulWidget {
  final suggestion;
  final networkFromSearch;
  final ValueChanged<String> parentAction1;
  final ValueChanged<String> parentAction2;
  final List<dynamic> requestedConnections;

  PeopleItem(
      {Key key,
      this.suggestion,
      this.networkFromSearch,
      this.parentAction1,
      this.parentAction2,
      this.requestedConnections})
      : super(key: key);

  _PeopleItemState createState() => _PeopleItemState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _PeopleItemState extends State<PeopleItem> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    // print(
    //     'Contact card =================================================================== ${widget.suggestion.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
              context,
              FadeRoute(
                page: ChangeNotifierProvider<NetworkRespository>(
                  create: (context) => NetworkRespository(),
                  child: NetworkProfile(widget.suggestion != null
                      ? widget.suggestion.id
                      : widget.networkFromSearch['id']),
                ),
              ),
            ),
        child: Container(
          margin: EdgeInsets.only(left: 10, bottom: 8),
          width: 200.0,
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
              ),
            ],
            border: Border.all(color: AppColors.grey08),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Container(
                  height: 75,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: AppColors.ghostWhite,
                  child: Center(
                    child: widget.networkFromSearch != null
                        ? ((widget.networkFromSearch['profileDetails'] !=
                                    null &&
                                (widget.networkFromSearch['profileDetails']
                                            ['photo'] !=
                                        null &&
                                    widget.networkFromSearch['profileDetails']
                                            ['photo'] !=
                                        ''))
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.memory(Helper.getByteImage(
                                    widget.networkFromSearch['profileDetails']
                                        ['photo'])))
                            : Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.positiveLight,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                ),
                                child: Center(
                                  child: Text(
                                    (widget.networkFromSearch['profileDetails']['personalDetails'] != null &&
                                            (widget.networkFromSearch['profileDetails']
                                                            ['personalDetails']
                                                        ['firstname'] !=
                                                    null &&
                                                widget.networkFromSearch['profileDetails']
                                                            ['personalDetails']
                                                        ['surname'] !=
                                                    null))
                                        ? Helper.getInitials(widget
                                                .networkFromSearch['profileDetails']
                                                    ['personalDetails']
                                                    ['firstname']
                                                .trim() +
                                            ' ' +
                                            widget.networkFromSearch['profileDetails']['personalDetails']['surname'].trim())
                                        : 'UN',
                                    style: GoogleFonts.lato(
                                        color: AppColors.avatarText,
                                        fontSize: 14.0,
                                        letterSpacing: 0.25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ))
                        : (widget.suggestion.photo != ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.memory(
                                    Helper.getByteImage(widget.suggestion.photo)))
                            : Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.positiveLight,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                ),
                                child: Center(
                                  child: Text(
                                    Helper.getInitials(
                                        widget.suggestion.firstName.trim() +
                                            ' ' +
                                            widget.suggestion.lastName.trim()),
                                    style: GoogleFonts.lato(
                                        color: AppColors.avatarText,
                                        fontSize: 14.0,
                                        letterSpacing: 0.25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              )),
                  )),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  (widget.networkFromSearch != null)
                      ? ((widget.networkFromSearch['profileDetails'] != null &&
                              (widget.networkFromSearch['profileDetails']
                                          ['personalDetails']['firstname'] !=
                                      null &&
                                  widget.networkFromSearch['profileDetails']
                                          ['personalDetails']['surname'] !=
                                      null))
                          ? (Helper.capitalize(widget.networkFromSearch['profileDetails']['personalDetails']['firstname']) +
                              ' ' +
                              Helper.capitalize(
                                  widget.networkFromSearch['profileDetails']
                                      ['personalDetails']['surname']))
                          : 'Unknown user')
                      : (Helper.capitalize(widget.suggestion.firstName) +
                          ' ' +
                          Helper.capitalize(widget.suggestion.lastName)),
                  maxLines: 1,
                  style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 20, right: 20),
                constraints: BoxConstraints(minHeight: 50),
                child: Text(
                  (widget.networkFromSearch != null)
                      ? ((widget.networkFromSearch['profileDetails'] != null &&
                              (widget.networkFromSearch['profileDetails']
                                          ['employmentDetails'] !=
                                      null &&
                                  widget.networkFromSearch['profileDetails']
                                              ['employmentDetails']
                                          ['departmentName'] !=
                                      null))
                          ? widget.networkFromSearch['profileDetails']
                              ['employmentDetails']['departmentName']
                          : '')
                      : ((widget.suggestion.department != null)
                          ? (widget.suggestion.department.toString())
                          : ''),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: AppColors.greys60,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: OutlinedButton(
                  onPressed: () {
                    // print(widget.suggestion['id']);
                    // print('post connection: ' +
                    //     widget.suggestion.rawDetails.toString());
                    if (widget.suggestion != null &&
                        (!widget.requestedConnections.any((element) =>
                            element['id'] == widget.suggestion.id))) {
                      widget.parentAction1(widget.suggestion.id);
                    } else {
                      if (widget.networkFromSearch != null &&
                          !widget.requestedConnections.any((element) =>
                              element['id'] ==
                              widget.networkFromSearch['id'])) {
                        widget.parentAction1(widget.networkFromSearch['id']);
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    // primary: Colors.white,
                    splashFactory: (widget.requestedConnections.any((element) =>
                            element['id'] ==
                            (widget.suggestion != null
                                ? widget.suggestion.id.toString()
                                : widget.networkFromSearch['id'])))
                        ? NoSplash.splashFactory
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: AppColors.grey16)),
                    // onSurface: Colors.grey,
                  ),
                  child: Text(
                    (!widget.requestedConnections.any((element) =>
                            element['id'] ==
                            (widget.suggestion != null
                                ? widget.suggestion.id.toString()
                                : widget.networkFromSearch['id'])))
                        ? EnglishLang.connect
                        : EnglishLang.connectionSent,
                    style: GoogleFonts.lato(
                        color: (!widget.requestedConnections.any((element) =>
                                element['id'] ==
                                (widget.suggestion != null
                                    ? widget.suggestion.id.toString()
                                    : widget.networkFromSearch['id'])))
                            ? AppColors.primaryThree
                            : AppColors.grey40,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
