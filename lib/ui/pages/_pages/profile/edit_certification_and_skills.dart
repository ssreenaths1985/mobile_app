import 'package:flutter/material.dart';
// import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';
// import './../../../../models/index.dart';
// import './../../../../ui/widgets/index.dart';
import './../../../../constants/index.dart';
import './../../../../services/index.dart';
import './../../../../localization/index.dart';

class EditCertificationAndSkillsPage extends StatefulWidget {
  final profileDetails;
  final scaffoldKey;
  static final GlobalKey<_EditCertificationAndSkillsPageState>
      certificationSkillsDetailsGlobalKey = GlobalKey();
  EditCertificationAndSkillsPage({
    Key key,
    this.profileDetails,
    this.scaffoldKey,
  }) : super(key: certificationSkillsDetailsGlobalKey);

  @override
  _EditCertificationAndSkillsPageState createState() =>
      _EditCertificationAndSkillsPageState();
}

class _EditCertificationAndSkillsPageState
    extends State<EditCertificationAndSkillsPage> {
  final ProfileService profileService = ProfileService();

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _professionalInterests = [];
  List<String> _hobbies = [];
  Map _profileData;
  // var _profileDetails;

  final TextEditingController _skillCoursesController = TextEditingController();
  final TextEditingController _certificationDetailsController =
      TextEditingController();
  final TextEditingController _professionalInterestController =
      TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();

  final FocusNode _skillCoursesFocus = FocusNode();
  final FocusNode _certificationDetailsFocus = FocusNode();
  final FocusNode _professionalDetailFocus = FocusNode();
  final FocusNode _hobbiesFocus = FocusNode();

  // final GlobalKey<TagsState> _tagStateKey1 = GlobalKey<TagsState>();
  // final GlobalKey<TagsState> _tagStateKey2 = GlobalKey<TagsState>();

  // Future<List<Profile>> _getProfileDetails() async {
  //   _profileDetails = await profileService.getProfileDetailsById('');
  //   // print(_profileDetails.toString());
  //   return _profileDetails;
  // }

  @override
  void initState() {
    super.initState();
    _populateFields(widget.profileDetails);
  }

  _populateFields(profileDetails) {
    String professionalInterests =
        profileDetails[0].interests['professional'] != null
            ? profileDetails[0].interests['professional'].join(',')
            : '';
    String hobbies = profileDetails[0].interests['hobbies'] != null
        ? profileDetails[0].interests['hobbies'].join(',')
        : '';
    setState(() {
      _skillCoursesController.text =
          profileDetails[0].skills['additionalSkills'];
      _certificationDetailsController.text =
          profileDetails[0].skills['certificateDetails'];
      if (professionalInterests != '' && professionalInterests != null) {
        _professionalInterests = professionalInterests.split(',');
      }
      if (hobbies != '' && hobbies != null) {
        _hobbies = hobbies.split(',');
        // List<Item> hobbiesList = _tagStateKey1.currentState?.getAllItem;
        // if (hobbiesList != null) {
        //   hobbiesList.where((a) => a.active == true).forEach((a) => print(a));
        // }
      }
      // _hobbies = hobbies.split(',');
      // print(_hobbies);
      // print(_professionalInterests);
    });
  }

  Future<void> saveProfile() async {
    // print(_professionalInterests);
    _profileData = {
      // "id": widget.profileDetails[0].rawDetails['userId'],
      // "userId": widget.profileDetails[0].rawDetails['userId'],
      // "photo": widget.profileDetails[0].photo,
      'academics': widget.profileDetails[0].education,
      // 'employmentDetails': widget.profileDetails[0].employmentDetails,
      // 'personalDetails': widget.profileDetails[0].personalDetails,
      // 'professionalDetails': widget.profileDetails[0].professionalDetails,
      "interests": {
        "professional": _professionalInterests,
        "hobbies": _hobbies
      },
      "skills": {
        "additionalSkills": _skillCoursesController.text,
        "certificateDetails": _certificationDetailsController.text
      },
      "competencies": widget.profileDetails[0].competencies
      // 'skills': {
      //   'additionalSkills': _skillCoursesController.text,
      //   'certificateDetails': _certificationDetailsController.text
      // },
      // 'interests': {
      //   'hobbies': _hobbies,
      //   'professional': _professionalInterests,
      // },
    };
    // String mobile = _profileData['personalDetails']['mobile'].toString();
    // _profileData['personalDetails']['mobile'] = int.parse(mobile);

    var response;
    try {
      response = await profileService.updateProfileDetails(_profileData);
      FocusManager.instance.primaryFocus.unfocus();
      var snackBar;
      if (response['params']['errmsg'] == null ||
          response['params']['errmsg'] == '') {
        snackBar = SnackBar(
          content: Container(
              // margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Text(
            EnglishLang.certificationAndSkillsUpdatedText,
          )),
          backgroundColor: AppColors.positiveLight,
        );
      } else {
        snackBar = SnackBar(
          content: Container(
              // padding: const EdgeInsets.only(top: 5),
              // margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Text(response['params']['errmsg'])),
          backgroundColor: Theme.of(context).errorColor,
        );
      }
      ScaffoldMessenger.of(widget.scaffoldKey.currentContext)
          .showSnackBar(snackBar);
      // widget.scaffoldKey.currentState.showSnackBar(snackBar);
    } catch (err) {
      return err;
    }
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _addProfessionalInterests() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _professionalInterests.add(_professionalInterestController.text);
          _professionalInterests.toSet().toList();
        });
        _professionalInterestController.clear();
      },
      child: Text(
        "Add",
        style: GoogleFonts.lato(
          color: AppColors.primaryThree,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _addHobbies() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _hobbies.add(_hobbiesController.text);
          _hobbies.toSet().toList();
        });
        _hobbiesController.clear();
      },
      child: Text(
        EnglishLang.add,
        style: GoogleFonts.lato(
          color: AppColors.primaryThree,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _certificationDetailsController.dispose();
    _hobbiesController.dispose();
    _professionalInterestController.dispose();
    _skillCoursesController.dispose();
    _certificationDetailsFocus.dispose();
    _hobbiesFocus.dispose();
    _professionalDetailFocus.dispose();
    _skillCoursesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: _getProfileDetails(),
      // builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      future: Future.delayed(Duration(milliseconds: 1500)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (true) {
          return SingleChildScrollView(
              // child: SizedBox()
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 24, bottom: 5),
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    EnglishLang.certification,
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.25,
                        height: 1.5),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                margin: EdgeInsets.only(top: 5.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              EnglishLang.additionalSkillAcquired,
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _skillCoursesFocus,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _skillCoursesFocus,
                                  _certificationDetailsFocus);
                            },
                            controller: _skillCoursesController,
                            style: GoogleFonts.lato(fontSize: 14.0),
                            minLines: 6,
                            maxLines: 10,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.grey16)),
                              hintText: EnglishLang.typeHere,
                              hintStyle: GoogleFonts.lato(
                                  color: AppColors.grey40,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.primaryThree, width: 1.0),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              EnglishLang.provideCertificationDetails,
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _certificationDetailsFocus,
                            controller: _certificationDetailsController,
                            style: GoogleFonts.lato(fontSize: 14.0),
                            minLines: 6,
                            maxLines: 10,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.grey16)),
                              hintText: EnglishLang.typeHere,
                              hintStyle: GoogleFonts.lato(
                                  color: AppColors.grey40,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.primaryThree, width: 1.0),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, bottom: 5),
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    EnglishLang.skills,
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.25,
                        height: 1.5),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                margin: EdgeInsets.only(top: 5.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              EnglishLang.professionalInterests,
                              style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.25,
                                  height: 1.5),
                            ),
                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.lightBackground,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 40.0,
                          child: Focus(
                            child: TextFormField(
                              textInputAction: TextInputAction.go,
                              textCapitalization: TextCapitalization.sentences,
                              focusNode: _professionalDetailFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context,
                                    _certificationDetailsFocus,
                                    _professionalDetailFocus);
                              },
                              controller: _professionalInterestController,
                              style: GoogleFonts.lato(fontSize: 14.0),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.grey16)),
                                hintText: EnglishLang.typeHere,
                                suffix: _addProfessionalInterests(),
                                hintStyle: GoogleFonts.lato(
                                    color: AppColors.grey40,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryThree,
                                      width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          children: [
                            for (var i in _professionalInterests)
                              Container(
                                margin: const EdgeInsets.only(right: 15.0),
                                child: InputChip(
                                  padding: EdgeInsets.all(10.0),
                                  backgroundColor: AppColors.lightOrange,
                                  label: Text(
                                    i,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.25,
                                    ),
                                  ),
                                  deleteIcon: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Positioned(
                                        top: -3.5,
                                        left: -4.5,
                                        right: 0,
                                        child: Icon(Icons.cancel,
                                            size: 25.0,
                                            color: AppColors.grey40),
                                      ),
                                    ],
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      _professionalInterests.removeAt(
                                          _professionalInterests.indexOf(i));
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              EnglishLang.hobbies,
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.lightBackground,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 40.0,
                          child: Focus(
                            child: TextFormField(
                              textInputAction: TextInputAction.go,
                              textCapitalization: TextCapitalization.sentences,
                              focusNode: _hobbiesFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context,
                                    _professionalDetailFocus, _hobbiesFocus);
                              },
                              controller: _hobbiesController,
                              style: GoogleFonts.lato(fontSize: 14.0),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.grey16)),
                                hintText: EnglishLang.typeHere,
                                suffix: _addHobbies(),
                                hintStyle: GoogleFonts.lato(
                                    color: AppColors.grey40,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryThree,
                                      width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          children: [
                            for (var i in _hobbies)
                              Container(
                                margin: const EdgeInsets.only(right: 15.0),
                                child: InputChip(
                                  padding: EdgeInsets.all(10.0),
                                  backgroundColor: AppColors.lightOrange,
                                  label: Text(
                                    i,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.25,
                                    ),
                                  ),
                                  deleteIcon: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Positioned(
                                        top: -3.5,
                                        left: -4.5,
                                        right: 0,
                                        child: Icon(Icons.cancel,
                                            size: 25.0,
                                            color: AppColors.grey40),
                                      ),
                                    ],
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      _hobbies.removeAt(_hobbies.indexOf(i));
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 150,
              )
            ],
          ));
        }
        // else {
        //   return PageLoader(
        //     bottom: 50,
        //   );
        // }
      },
    );
  }
}
