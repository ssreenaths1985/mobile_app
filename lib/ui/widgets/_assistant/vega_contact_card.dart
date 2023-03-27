import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';
import './../../../util/faderoute.dart';
import './../../../respositories/index.dart';
import './../../../ui/pages/index.dart';
// import 'dart:developer' as developer;

class VegaContactCard extends StatefulWidget {
  final suggestion;
  final ValueChanged<String> parentAction1;
  final ValueChanged<String> parentAction2;
  VegaContactCard(
      {Key key, this.suggestion, this.parentAction1, this.parentAction2})
      : super(key: key);

  _VegaContactCardState createState() => _VegaContactCardState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _VegaContactCardState extends State<VegaContactCard> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    // print(
    //     'Contact card =================================================================== ${widget.suggestion['profileDetails']['firstName']}');
    //      developer.log(widget.suggestion.toString());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
              context,
              FadeRoute(
                page: ChangeNotifierProvider<NetworkRespository>(
                  create: (context) => NetworkRespository(),
                  child: NetworkProfile(widget.suggestion['id']),
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
                    child: widget.suggestion['profileDetails']['photo'] != '' &&
                            widget.suggestion['profileDetails']['photo'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.memory(Helper.getByteImage(
                                widget.suggestion['profileDetails']['photo'])))
                        : Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.positiveLight,
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(4.0)),
                            ),
                            child: Center(
                              child: Text(
                                Helper.getInitials(widget
                                            .suggestion['profileDetails']
                                                ['personalDetails']['firstname']
                                            .trim() +
                                        ' ' +
                                        widget.suggestion['profileDetails']
                                                ['personalDetails']['surname']
                                            .trim()
                                    // 'UN',
                                    ),
                                style: GoogleFonts.lato(
                                    color: AppColors.avatarText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w700),
                                // 'UN'
                              ),
                            ),
                          ),
                  )),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  Helper.capitalize(widget.suggestion['profileDetails']
                          ['personalDetails']['firstname']) +
                      ' ' +
                      Helper.capitalize(widget.suggestion['profileDetails']
                          ['personalDetails']['surname']),
                  // 'UN',
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
                  widget.suggestion['profileDetails']['employmentDetails']
                          ['departmentName']
                      .toString(),
                  style: GoogleFonts.lato(
                    color: AppColors.greys60,
                    fontSize: 16,
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.only(top: 10, bottom: 10),
              //   child: OutlinedButton(
              //     onPressed: () {
              //       widget.parentAction1(widget.suggestion['id']);
              //     },
              //     style: OutlinedButton.styleFrom(
              //       // primary: Colors.white,

              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(4),
              //           side: BorderSide(color: AppColors.grey16)),
              //       // onSurface: Colors.grey,
              //     ),
              //     child: Text(
              //       'Connect',
              //       style: GoogleFonts.lato(
              //           color: AppColors.primaryThree,
              //           fontSize: 14,
              //           fontWeight: FontWeight.w700),
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
}
