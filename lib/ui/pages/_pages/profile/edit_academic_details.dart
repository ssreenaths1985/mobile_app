import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:karmayogi_mobile/services/_services/profile_service.dart';
import 'package:provider/provider.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';
import './../../../../localization/index.dart';

class EditAcademicDetailsPage extends StatefulWidget {
  final profileDetails;
  final scaffoldKey;
  static final GlobalKey<_EditAcademicDetailsPageState>
      academicDetailsGlobalKey = GlobalKey();
  EditAcademicDetailsPage({
    Key key,
    this.profileDetails,
    this.scaffoldKey,
  }) : super(key: academicDetailsGlobalKey);
  @override
  _EditAcademicDetailsPageState createState() =>
      _EditAcademicDetailsPageState();
}

class _EditAcademicDetailsPageState extends State<EditAcademicDetailsPage> {
  // final _scaffoldAcademicDetailsKey = GlobalKey<ScaffoldState>();
  final ProfileService profileService = ProfileService();
  Map<dynamic, dynamic> _graduationDegrees = {
    0: {
      'display': true,
      'nameOfQualification': '',
      'type': DegreeType.graduate,
      'nameOfInstitute': '',
      'yearOfPassing': ''
    }
  };
  Map<dynamic, dynamic> _postGraduationDegrees = {
    0: {
      'display': true,
      'nameOfQualification': '',
      'type': DegreeType.postGraduate,
      'nameOfInstitute': '',
      'yearOfPassing': ''
    }
  };
  List<String> _graduationDegreesList = [];
  List<String> _postGraduationDegreesList = [];

  final TextEditingController _schoolName10thController =
      TextEditingController();
  final TextEditingController _yearOfPassing10thController =
      TextEditingController();
  final TextEditingController _schoolName12thController =
      TextEditingController();
  final TextEditingController _yearOfPassing12thController =
      TextEditingController();

  final FocusNode _schoolName10thFocus = FocusNode();
  final FocusNode _yearOfPassing10thFocus = FocusNode();
  final FocusNode _schoolName12thFocus = FocusNode();
  final FocusNode _yearOfPassing12thFocus = FocusNode();

  TextEditingController _textController = TextEditingController();
  List _filteredDegrees;

  Map _profileData;

  void initState() {
    super.initState();
    _getAllDegrees();
  }

  void _setDegree(String degreeType, int index, String degreeName) {
    if (degreeType == 'graduation') {
      setState(() {
        _graduationDegrees[index]['nameOfQualification'] = degreeName;
      });
    } else {
      setState(() {
        _postGraduationDegrees[index]['nameOfQualification'] = degreeName;
      });
    }
  }

  void _filterDegrees(String degreeType, String value) {
    if (degreeType == 'graduation') {
      setState(() {
        _filteredDegrees = _graduationDegreesList
            .where((degree) => degree.toLowerCase().contains(value))
            .toList();
      });
    } else {
      setState(() {
        _filteredDegrees = _postGraduationDegreesList
            .where((degree) => degree.toLowerCase().contains(value))
            .toList();
      });
    }
  }

  Future<bool> _showListOfDegrees(
      contextMain, String degreeType, int parentIndex) {
    _filterDegrees(degreeType, '');
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Stack(
                children: [
                  Positioned(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              // constraints: BoxConstraints(
                              //     minHeight:
                              //         MediaQuery.of(context).size.height * 0.8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              width: double.infinity,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 24),
                                color: Colors.white,
                                // height: (_graduationDegreesList.length * 52.0),
                                child: Material(
                                    child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.end,
                                        children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              // width: 316,
                                              height: 48,
                                              child: TextFormField(
                                                  onChanged: (value) {
                                                    if (degreeType ==
                                                        'graduation') {
                                                      setState(() {
                                                        _filteredDegrees =
                                                            _graduationDegreesList
                                                                .where((degree) => degree
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        value))
                                                                .toList();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _filteredDegrees =
                                                            _postGraduationDegreesList
                                                                .where((degree) => degree
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        value))
                                                                .toList();
                                                      });
                                                    }
                                                    _filterDegrees(
                                                        degreeType, value);
                                                  },
                                                  controller: _textController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14.0),
                                                  decoration: InputDecoration(
                                                    prefixIcon:
                                                        Icon(Icons.search),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            16.0,
                                                            14.0,
                                                            0.0,
                                                            10.0),
                                                    hintText: 'Search',
                                                    hintStyle: GoogleFonts.lato(
                                                        color:
                                                            AppColors.greys60,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .primaryThree,
                                                              width: 1.0),
                                                    ),
                                                    counterStyle: TextStyle(
                                                      height:
                                                          double.minPositive,
                                                    ),
                                                    counterText: '',
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              child: Container(
                                                  width: 48,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    // borderRadius:
                                                    //     BorderRadius.all(
                                                    //         const Radius.circular(
                                                    //             4.0)),
                                                    // border: Border.all(
                                                    //     color: AppColors.grey16),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                      _textController.text = '';
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: AppColors.greys60,
                                                      size: 24,
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          color: Colors.white,
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.683,
                                          child: degreeType == "graduation"
                                              ? ListView.builder(
                                                  // controller: _controller,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _filteredDegrees.length,
                                                  itemBuilder: (BuildContext
                                                              context,
                                                          index) =>
                                                      InkWell(
                                                          onTap: () {
                                                            _setDegree(
                                                                degreeType,
                                                                parentIndex,
                                                                _filteredDegrees[
                                                                    index]);
                                                            setState(() {
                                                              _graduationDegrees[
                                                                          parentIndex]
                                                                      [
                                                                      'nameOfQualification'] =
                                                                  _filteredDegrees[
                                                                      index];
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child: _options(
                                                              degreeType,
                                                              _filteredDegrees[
                                                                  index],
                                                              parentIndex)))
                                              : ListView.builder(
                                                  // controller: _controller,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _filteredDegrees.length,
                                                  itemBuilder: (BuildContext
                                                              context,
                                                          index) =>
                                                      InkWell(
                                                          onTap: () {
                                                            _setDegree(
                                                                degreeType,
                                                                parentIndex,
                                                                _filteredDegrees[
                                                                    index]);
                                                            setState(() {
                                                              _postGraduationDegrees[
                                                                          parentIndex]
                                                                      [
                                                                      'nameOfQualification'] =
                                                                  _filteredDegrees[
                                                                      index];
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child: _options(
                                                              degreeType,
                                                              _filteredDegrees[index],
                                                              parentIndex)))),
                                    ])),
                              ))))
                ],
              );
            }));
  }

  Widget _options(String degreeType, String degreeName, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
          decoration: BoxDecoration(
            color: degreeType == "graduation"
                ? _graduationDegrees[index]['nameOfQualification'] == degreeName
                    ? AppColors.lightSelected
                    : Colors.white
                : _postGraduationDegrees[index]['nameOfQualification'] ==
                        degreeName
                    ? AppColors.lightSelected
                    : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          // height: 52,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 7, bottom: 7, left: 12, right: 4),
            child: Text(
              degreeName,
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.25,
                  height: 1.5),
            ),
          )),
    );
  }

  _getAllDegrees() {
    _getDegrees('postGraduation');
    _getDegrees('graduation');
    _populateFields();
    return _graduationDegreesList;
  }

  _populateFields() {
    setState(() {
      // var degrees = widget.profileDetails[0].education;
      int graduationIndex = 0;
      int postGraduationIndex = 0;
      Map<dynamic, dynamic> graduationDegrees = {};
      Map<dynamic, dynamic> postGraduationDegrees = {};
      for (int i = 0; i < widget.profileDetails[0].education.length; i++) {
        switch (widget.profileDetails[0].education[i]['type']) {
          case DegreeType.xStandard:
            _schoolName10thController.text =
                widget.profileDetails[0].education[i]['nameOfInstitute'];
            _yearOfPassing10thController.text =
                widget.profileDetails[0].education[i]['yearOfPassing'];
            break;
          case DegreeType.xiiStandard:
            _schoolName12thController.text =
                widget.profileDetails[0].education[i]['nameOfInstitute'];
            _yearOfPassing12thController.text =
                widget.profileDetails[0].education[i]['yearOfPassing'];
            break;
          case DegreeType.graduate:
            graduationDegrees.addAll({
              graduationIndex++: {
                'display': true,
                'nameOfQualification': widget.profileDetails[0].education[i]
                    ['nameOfQualification'],
                'type': DegreeType.graduate,
                'nameOfInstitute': widget.profileDetails[0].education[i]
                    ['nameOfInstitute'],
                'yearOfPassing': widget.profileDetails[0].education[i]
                    ['yearOfPassing']
              }
            });
            break;
          case DegreeType.postGraduate:
            postGraduationDegrees.addAll({
              postGraduationIndex++: {
                'display': true,
                'nameOfQualification': widget.profileDetails[0].education[i]
                    ['nameOfQualification'],
                'type': DegreeType.postGraduate,
                'nameOfInstitute': widget.profileDetails[0].education[i]
                    ['nameOfInstitute'],
                'yearOfPassing': widget.profileDetails[0].education[i]
                    ['yearOfPassing']
              }
            });
            break;
        }
      }
      if (graduationDegrees.length > 0) {
        _graduationDegrees = graduationDegrees;
      }
      if (postGraduationDegrees.length > 0) {
        _postGraduationDegrees = postGraduationDegrees;
      }
      // print(graduationDegrees);
      // print(postGraduationDegrees);
    });
  }

  Future<void> saveProfile() async {
    List<Map<dynamic, dynamic>> academics = [
      {
        'nameOfQualification': '',
        'type': DegreeType.xStandard,
        'nameOfInstitute': _schoolName10thController.text,
        'yearOfPassing': _yearOfPassing10thController.text
      },
      {
        'nameOfQualification': '',
        'type': DegreeType.xiiStandard,
        'nameOfInstitute': _schoolName12thController.text,
        'yearOfPassing': _yearOfPassing12thController.text
      }
    ];
    for (int i = 0; i < _graduationDegrees.length; i++) {
      if (_graduationDegrees[i]['nameOfQualification'] == '') {
        _graduationDegrees[i]['nameOfQualification'] =
            _graduationDegreesList[0];
      }
      if (_graduationDegrees[i]['display']) {
        academics.add(_graduationDegrees[i]);
      }
    }
    for (int i = 0; i < _postGraduationDegrees.length; i++) {
      if (_postGraduationDegrees[i]['nameOfQualification'] == '') {
        _postGraduationDegrees[i]['nameOfQualification'] =
            _postGraduationDegreesList[0];
      }
      if (_postGraduationDegrees[i]['display']) {
        academics.add(_postGraduationDegrees[i]);
      }
    }
    // print(academics);
    _profileData = {
      // 'photo': widget.profileDetails[0].photo,
      'academics': academics,
      // 'employmentDetails': widget.profileDetails[0].employmentDetails,
      // 'personalDetails': widget.profileDetails[0].personalDetails,
      // 'professionalDetails': widget.profileDetails[0].professionalDetails,
      "competencies": widget.profileDetails[0].competencies,
      // "interests": widget.profileDetails[0].interests,
      // "@type": "UserProfile",
      // "userId": widget.profileDetails[0].rawDetails['userId'],
      // "id": widget.profileDetails[0].rawDetails['userId'],
      // "@id": widget.profileDetails[0].rawDetails['userId'],
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
            EnglishLang.academicDetailsUpdatedText,
          )),
          backgroundColor: AppColors.positiveLight,
        );
      } else {
        snackBar = SnackBar(
          content: Container(
              // padding: const EdgeInsets.only(top: 5),
              // margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Text(
            response['params']['errmsg'],
          )),
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

  Future<void> _getDegrees(String degree) async {
    List<Degree> degrees =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getDegrees(degree);
    if (degree == AcademicDegree.graduation) {
      setState(() {
        _graduationDegreesList = degrees.map((item) => item.degree).toList();
        // _graduationDegreesList.insert(0, EnglishLang.selectFromDropdown);
      });
    } else {
      setState(() {
        _postGraduationDegreesList =
            degrees.map((item) => item.degree).toList();
        // _postGraduationDegreesList.insert(0, EnglishLang.selectFromDropdown);
      });
    }
    // print(_postGraduationDegreesList);
  }

  Future<bool> _onRemoveDegree(String degree, int index) {
    return showDialog(
        context: context,
        builder: (context) => Stack(
              children: [
                Positioned(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          height: 125.0,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  child: Text(
                                    EnglishLang.confirmRemoveText,
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Row(children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                    setState(() {
                                      degree == AcademicDegree.graduation
                                          ? _graduationDegrees[index]
                                              ['display'] = false
                                          : _postGraduationDegrees[index]
                                              ['display'] = false;
                                    });
                                  },
                                  child: roundedButton(EnglishLang.yesRemove,
                                      Colors.white, AppColors.primaryThree),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(false),
                                  child: roundedButton(EnglishLang.noBackText,
                                      AppColors.primaryThree, Colors.white),
                                ),
                              ])
                            ],
                          ),
                        )))
              ],
            ));
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width / 2 - 28,
      padding: EdgeInsets.all(10),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        border: bgColor == Colors.white
            ? Border.all(color: AppColors.grey40)
            : Border.all(color: bgColor),
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.montserrat(
            decoration: TextDecoration.none,
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
    return loginBtn;
  }

  _getDegreeFields(String degree, int index) {
    return Container(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          // margin: EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldNameWidget(EnglishLang.degres),
              InkWell(
                onTap: () => _showListOfDegrees(context, degree, index),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(4.0)),
                        border: Border.all(color: AppColors.grey40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 10, bottom: 10),
                        child: Text(
                          degree == AcademicDegree.graduation
                              ? _graduationDegrees[index]
                                              ['nameOfQualification'] !=
                                          null &&
                                      _graduationDegrees[index]
                                              ['nameOfQualification'] !=
                                          ''
                                  ? _graduationDegrees[index]
                                      ['nameOfQualification']
                                  : "Select"
                              : _postGraduationDegrees[index]
                                              ['nameOfQualification'] !=
                                          null &&
                                      _postGraduationDegrees[index]
                                              ['nameOfQualification'] !=
                                          ''
                                  ? _postGraduationDegrees[index]
                                      ['nameOfQualification']
                                  : "Select",
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontSize: 14,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                ),
              ),
              _fieldNameWidget(EnglishLang.yearOfPassing),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 200, 0),
                child: Container(
                  height: 40,
                  child: TextFormField(
                      style: GoogleFonts.lato(fontSize: 14.0),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      initialValue: degree == AcademicDegree.graduation
                          ? _graduationDegrees[index]['yearOfPassing']
                          : _postGraduationDegrees[index]['yearOfPassing'],
                      onChanged: (String newValue) {
                        setState(() {
                          degree == AcademicDegree.graduation
                              ? _graduationDegrees[index]['yearOfPassing'] =
                                  newValue
                              : _postGraduationDegrees[index]['yearOfPassing'] =
                                  newValue;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey16)),
                        hintText: EnglishLang.typeHere,
                        hintStyle: GoogleFonts.lato(
                            color: AppColors.grey40,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.primaryThree, width: 1.0),
                        ),
                        counterStyle: TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: '',
                      )),
                ),
              ),
              _fieldNameWidget(EnglishLang.instituteName),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  height: 40,
                  child: TextFormField(
                      style: GoogleFonts.lato(fontSize: 14.0),
                      initialValue: degree == AcademicDegree.graduation
                          ? _graduationDegrees[index]['nameOfInstitute']
                          : _postGraduationDegrees[index]['nameOfInstitute'],
                      onChanged: (String newValue) {
                        setState(() {
                          degree == AcademicDegree.graduation
                              ? _graduationDegrees[index]['nameOfInstitute'] =
                                  newValue
                              : _postGraduationDegrees[index]
                                  ['nameOfInstitute'] = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey16)),
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
              ),
              index > 0
                  ? InkWell(
                      onTap: () => _onRemoveDegree(degree, index),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              size: 24,
                              color: AppColors.greys60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Delete degree",
                                style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  height: 1.5,
                                  letterSpacing: 0.25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                  : Center()
            ],
          ),
        ),
      ],
    ));
    // return _graduationWidgets;
  }

  Widget _titleFieldWidget(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 32, bottom: 16, left: 16),
      child: Container(
        // margin: const EdgeInsets.only(top: 32, bottom: 16, left: 4),
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: GoogleFonts.lato(
            color: AppColors.greys87,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.5,
            letterSpacing: 0.25,
          ),
        ),
      ),
    );
  }

  Widget _fieldNameWidget(String fieldName) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            fieldName,
            style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          // Icon(Icons.check_circle_outline)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _yearOfPassing10thController.dispose();
    _yearOfPassing12thController.dispose();
    _schoolName12thController.dispose();
    _schoolName10thController.dispose();
    _yearOfPassing10thFocus.dispose();
    _yearOfPassing12thFocus.dispose();
    _schoolName10thFocus.dispose();
    _schoolName12thFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 1500)),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (true) {
              return Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      // Container(
                      //   margin: const EdgeInsets.only(top: 10),
                      //   alignment: Alignment.topLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 15),
                      //     child: Container(
                      //       height: 40,
                      //       width: 160,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         children: [
                      //           // Icon(Icons.check_circle_outline),
                      //           Text(
                      //             'Requires approval',
                      //             style: GoogleFonts.lato(
                      //               color: AppColors.greys87,
                      //               fontSize: 14.0,
                      //               fontWeight: FontWeight.w400,
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: AppColors.grey04,
                      //         borderRadius: BorderRadius.all(const Radius.circular(21.0)),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      _titleFieldWidget(EnglishLang.standardTenth),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        // margin: EdgeInsets.only(top: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.schoolName),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                height: 40,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    focusNode: _schoolName10thFocus,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          context,
                                          _schoolName10thFocus,
                                          _yearOfPassing10thFocus);
                                    },
                                    controller: _schoolName10thController,
                                    style: GoogleFonts.lato(fontSize: 14.0),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 0.0, 10.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.grey16)),
                                      hintText: EnglishLang.typeHere,
                                      hintStyle: GoogleFonts.lato(
                                          color: AppColors.grey40,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryThree,
                                            width: 1.0),
                                      ),
                                    )),
                              ),
                            ),
                            _fieldNameWidget(EnglishLang.yearOfPassing),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 200, 24),
                              child: Container(
                                height: 40,
                                child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _yearOfPassing10thFocus,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          context,
                                          _yearOfPassing10thFocus,
                                          _schoolName12thFocus);
                                    },
                                    controller: _yearOfPassing10thController,
                                    style: GoogleFonts.lato(fontSize: 14.0),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 0.0, 10.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.grey16)),
                                      hintText: EnglishLang.typeHere,
                                      hintStyle: GoogleFonts.lato(
                                          color: AppColors.grey40,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryThree,
                                            width: 1.0),
                                      ),
                                      counterStyle: TextStyle(
                                        height: double.minPositive,
                                      ),
                                      counterText: '',
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      _titleFieldWidget(EnglishLang.standardTwelfth),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        // margin: EdgeInsets.only(top: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.schoolName),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                height: 40,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    focusNode: _schoolName12thFocus,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          context,
                                          _schoolName12thFocus,
                                          _yearOfPassing12thFocus);
                                    },
                                    controller: _schoolName12thController,
                                    style: GoogleFonts.lato(fontSize: 14.0),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 0.0, 10.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.grey16)),
                                      hintText: EnglishLang.typeHere,
                                      hintStyle: GoogleFonts.lato(
                                          color: AppColors.grey40,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryThree,
                                            width: 1.0),
                                      ),
                                    )),
                              ),
                            ),
                            _fieldNameWidget(EnglishLang.yearOfPassing),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 200, 24),
                              child: Container(
                                height: 40,
                                child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _yearOfPassing12thFocus,
                                    // onFieldSubmitted: (term) {
                                    //   _fieldFocusChange(
                                    //       context,
                                    //       _12thSchoolNameFocus,
                                    //       _12thYearOfPassingFocus);
                                    // },
                                    controller: _yearOfPassing12thController,
                                    style: GoogleFonts.lato(fontSize: 14.0),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 0.0, 10.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.grey16)),
                                      hintText: EnglishLang.typeHere,
                                      hintStyle: GoogleFonts.lato(
                                          color: AppColors.grey40,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryThree,
                                            width: 1.0),
                                      ),
                                      counterStyle: TextStyle(
                                        height: double.minPositive,
                                      ),
                                      counterText: '',
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      _titleFieldWidget(EnglishLang.gradDetails),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _graduationDegrees.length,
                                itemBuilder: (context, index) {
                                  // print(
                                  //     '_graduationDegrees[index][]) ${_graduationDegrees[index]['display']}');
                                  return _graduationDegrees[index]['display']
                                      ? _getDegreeFields('graduation', index)
                                      : Center();
                                }),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24, top: 24),
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                // margin: EdgeInsets.only(top: 5),
                                child: TextButton(
                                  onPressed: () => setState(() {
                                    _graduationDegrees[
                                        _graduationDegrees.length] = {
                                      'display': true,
                                      'nameOfQualification': '',
                                      'type': DegreeType.graduate,
                                      'nameOfInstitute': '',
                                      'yearOfPassing': ''
                                    };
                                  }),
                                  style: TextButton.styleFrom(
                                    // primary: Colors.white,
                                    // backgroundColor: FeedbackColors.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                            color: AppColors.primaryThree)),
                                    // onSurface: Colors.grey,
                                  ),
                                  child: Text(
                                    'Add another qualification',
                                    style: GoogleFonts.lato(
                                      color: AppColors.primaryThree,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      _titleFieldWidget(EnglishLang.postGradDetails),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _postGraduationDegrees.length,
                                itemBuilder: (context, index) {
                                  return _postGraduationDegrees[index]
                                          ['display']
                                      ? _getDegreeFields(
                                          'postGraduation', index)
                                      : Center();
                                }),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24, top: 24),
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                // margin: EdgeInsets.only(top: 5),
                                child: TextButton(
                                  onPressed: () => setState(() {
                                    _postGraduationDegrees[
                                        _postGraduationDegrees.length] = {
                                      'display': true,
                                      'nameOfQualification': '',
                                      'type': DegreeType.postGraduate,
                                      'nameOfInstitute': '',
                                      'yearOfPassing': ''
                                    };
                                  }),
                                  style: TextButton.styleFrom(
                                    // primary: Colors.white,
                                    // backgroundColor: FeedbackColors.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                            color: AppColors.primaryThree)),
                                  ),
                                  child: Text(
                                    'Add another qualification',
                                    style: GoogleFonts.lato(
                                      color: AppColors.primaryThree,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 50,
                      )
                    ],
                  ));
            }
          }),
    );
  }
}
