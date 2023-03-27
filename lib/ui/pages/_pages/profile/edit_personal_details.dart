import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:intl/intl.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_tags/flutter_tags.dart';
// import 'package:karmayogi_mobile/ui/widgets/index.dart';
// import './../../../../ui/widgets/index.dart';
import './../../../../models/index.dart';
import './../../../../util/helper.dart';
import './../../../../services/index.dart';
import './../../../../constants/index.dart';
import './../../../../localization/index.dart';
// import 'dart:developer' as developer;

class EditPersonalDetailsPage extends StatefulWidget {
  final profileDetails;
  final scaffoldKey;
  static final GlobalKey<_EditPersonalDetailsPageState>
      personalDetailsGlobalKey = GlobalKey();
  final parentAction;
  EditPersonalDetailsPage(
      {Key key, this.profileDetails, this.scaffoldKey, this.parentAction})
      : super(key: personalDetailsGlobalKey);
  @override
  _EditPersonalDetailsPageState createState() =>
      _EditPersonalDetailsPageState();
}

class _EditPersonalDetailsPageState extends State<EditPersonalDetailsPage> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AutoCompleteTextFieldState<String>> key1 = GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<String>> key2 = GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<String>> key3 = GlobalKey();
  final GlobalKey<FormState> personalDetailsFormKey = GlobalKey<FormState>();

  final ProfileService profileService = ProfileService();

  // final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  File _selectedFile;
  final _picker = ImagePicker();
  // var _profileDetails;
  bool _inProcess = false;
  // Map _gender = <String, bool>{
  //   EnglishLang.male: false,
  //   EnglishLang.female: false,
  //   EnglishLang.others: false,
  // };
  List _genderRadio = [
    EnglishLang.male,
    EnglishLang.female,
    EnglishLang.others
  ];

  // Map _maritalStatus = <String, bool>{
  //   EnglishLang.single: false,
  //   EnglishLang.married: false,
  // };

  List _maritalStatusRadio = [EnglishLang.single, EnglishLang.married];

  // Map _category = <String, bool>{
  //   EnglishLang.general: false,
  //   EnglishLang.obc: false,
  //   EnglishLang.sc: false,
  //   EnglishLang.st: false,
  // };

  List _categoryRadio = [
    EnglishLang.general,
    EnglishLang.obc,
    EnglishLang.sc,
    EnglishLang.st
  ];

  int _postalAddressLength = 0;
  bool _officialEmail = false;
  var _imageBase64 = '';
  Map _profileData;
  // String _genderValue;
  // String _maritalStatusValue;
  // String _categoryValue;
  List<String> _nationalities = [];
  List<String> _languages = [];
  List<String> _countryCodes = [];
  List<String> _otherLanguages = [];
  String _selectedGender = '';
  String _selectedMaritalStatusRadio = '';
  String _selectedCategoryRadio = '';
  DateTime _dobDate;
  Timer _timer;
  int _resendOTPTime = 180;
  String _timeFormat;
  bool _hasSendOTPRequest = false;
  bool _showResendOption = false;
  bool _freezeMobileField = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _surNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _domicileMediumController =
      TextEditingController();
  final TextEditingController _otherLangsController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _mobileNoOTPController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _telephoneNoController = TextEditingController();
  final TextEditingController _primaryEmailController = TextEditingController();
  final TextEditingController _secondaryEmailController =
      TextEditingController();
  final TextEditingController _postalAddressController =
      TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _middleNameFocus = FocusNode();
  final FocusNode _surNameFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _nationalityFocus = FocusNode();
  final FocusNode _domicileMediumFocus = FocusNode();
  final FocusNode _otherLangsFocus = FocusNode();
  final FocusNode _mobileNoFocus = FocusNode();
  final FocusNode _countryCodeFocus = FocusNode();
  final FocusNode _telephoneNoFocus = FocusNode();
  final FocusNode _primaryEmailFocus = FocusNode();
  final FocusNode _secondaryEmailFocus = FocusNode();
  final FocusNode _postalAddressFocus = FocusNode();
  final FocusNode _pinCodeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _populateFields(widget.profileDetails);
    _getNationalities();
    _getLanguages();
    _getResendTimeOTP();
    // print(new DateFormat('dd/MM/yyyy').parse('2022/04/05'));
    // DateTime dt = DateTime.parse('2022-04-05');
    // print(dt);
  }

  void _startTimer() {
    _timeFormat = formatHHMMSS(_resendOTPTime);
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_resendOTPTime == 0) {
          setState(() {
            timer.cancel();
            _showResendOption = true;
          });
        } else {
          setState(() {
            _resendOTPTime--;
          });
        }
        _timeFormat = formatHHMMSS(_resendOTPTime);
      },
    );
  }

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return '$minutesStr:$secondsStr';
    }

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  Future<void> _populateFields(profileDetails) async {
    // print(profileDetails[0].personalDetails['dob'].toString());
    // print('Date: ' +
    //     widget.profileDetails[0].personalDetails['dob']
    //         .toString()
    //         .split('-')
    //         .reversed
    //         .join('-'));
    // print(profileDetails[0].toString());
    String temp;
    if (profileDetails[0].personalDetails['knownLanguages'] != null &&
        profileDetails[0].personalDetails['knownLanguages'] != '') {
      temp = profileDetails[0].personalDetails['knownLanguages'].join(',');
    }
    setState(() {
      _imageBase64 = profileDetails[0].photo;
      _firstNameController.text = profileDetails[0].firstName;
      _middleNameController.text = profileDetails[0].middleName;
      // _middleNameController.text = '';
      _surNameController.text = profileDetails[0].surname;
      _dobController.text = profileDetails[0].personalDetails['dob'];
      _nationalityController.text =
          profileDetails[0].personalDetails['nationality'];
      _domicileMediumController.text =
          profileDetails[0].personalDetails['domicileMedium'];
      _otherLanguages = (temp != null && temp != '') ? temp.split(',') : [];
      _mobileNoController.text =
          profileDetails[0].personalDetails['mobile'] != null
              ? profileDetails[0].personalDetails['mobile'].toString()
              : '';
      _countryCodeController.text =
          profileDetails[0].personalDetails['countryCode'];
      _telephoneNoController.text =
          profileDetails[0].personalDetails['telephone'];
      _primaryEmailController.text =
          profileDetails[0].personalDetails['primaryEmail'];
      _officialEmail = profileDetails[0].personalDetails['officialEmail'] ==
              profileDetails[0].personalDetails['primaryEmail']
          ? true
          : false;
      _secondaryEmailController.text =
          profileDetails[0].personalDetails['personalEmail'];
      _postalAddressController.text =
          profileDetails[0].personalDetails['postalAddress'];
      _postalAddressLength =
          profileDetails[0].personalDetails['postalAddress'] != null
              ? profileDetails[0].personalDetails['postalAddress'].length
              : 0;
      _pinCodeController.text = profileDetails[0].personalDetails['pincode'];
      // if (profileDetails[0].personalDetails['gender'] != null &&
      //     profileDetails[0].personalDetails['gender'] != '') {
      //   _gender[profileDetails[0].personalDetails['gender']] = true;
      //   _genderValue = profileDetails[0].personalDetails['gender'];
      // }

      _selectedGender = profileDetails[0].personalDetails['gender'];

      // if (profileDetails[0].personalDetails['maritalStatus'] != null &&
      //     profileDetails[0].personalDetails['maritalStatus'] != '') {
      //   _maritalStatus[profileDetails[0].personalDetails['maritalStatus']] =
      //       true;
      //   _maritalStatusValue =
      //       profileDetails[0].personalDetails['maritalStatus'];
      // }
      _selectedMaritalStatusRadio =
          profileDetails[0].personalDetails['maritalStatus'];
      // if (profileDetails[0].personalDetails['category'] != null &&
      //     profileDetails[0].personalDetails['category'] != '') {
      //   _category[profileDetails[0].personalDetails['category']] = true;
      //   _categoryValue = profileDetails[0].personalDetails['category'];
      // }
      _selectedCategoryRadio = profileDetails[0].personalDetails['category'];
    });
    // print(profileDetails[0].personalDetails['gender']);
  }

  Future<void> _getNationalities() async {
    List<Nationality> nationalities =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getNationalities();
    setState(() {
      _nationalities =
          nationalities.map((item) => item.country.toString()).toList();
      // print(_nationalities);
      _countryCodes =
          nationalities.map((item) => item.countryCode.toString()).toList();
    });
  }

  Future<void> _getResendTimeOTP() async {
    final editProfileConfig = await profileService.getProfileEditConfig();
    if (editProfileConfig['resendOTPTime'] != null) {
      setState(() {
        _resendOTPTime = editProfileConfig['resendOTPTime'];
      });
    }
  }

  Future<dynamic> _getLanguages() async {
    List<Language> languages =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getLanguages();
    _languages = languages.map((item) => item.language).toList();
    // for (int i = 0; i < _languages.length; i++) {
    //   _languages[i] = _languages[i].replaceAll('ʽ', '');
    //   _languages[i] = _languages[i].replaceAll('-', '');
    //   _languages[i] = _languages[i].replaceAll('(', '');
    //   _languages[i] = _languages[i].replaceAll(')', '');
    // }
    // developer.log(JsonEncoder() .toString());
    return _languages;
  }

  _getEditedFields() async {
    var personalDetails = [
      {
        "personalEmail": _secondaryEmailController.text,
        "isChanged": _secondaryEmailController.text !=
                widget.profileDetails[0].personalDetails['personalEmail']
            ? true
            : false
      },
      {
        "firstname": _firstNameController.text,
        "isChanged":
            _firstNameController.text != widget.profileDetails[0].firstName
                ? true
                : false
      },
      {
        "middlename": _middleNameController.text,
        "isChanged":
            _middleNameController.text != widget.profileDetails[0].middleName
                ? true
                : false
      },
      {
        'surname': _surNameController.text,
        "isChanged": _surNameController.text != widget.profileDetails[0].surname
            ? true
            : false
      },
      {
        'dob': _dobController.text,
        "isChanged": _dobController.text !=
                widget.profileDetails[0].personalDetails['dob']
            ? true
            : false
      },
      {
        'nationality': _nationalityController.text.toString(),
        "isChanged": _nationalityController.text !=
                widget.profileDetails[0].personalDetails['nationality']
            ? true
            : false
      },
      {
        'domicileMedium': _domicileMediumController.text.toString(),
        "isChanged": _domicileMediumController.text !=
                widget.profileDetails[0].personalDetails['domicileMedium']
            ? true
            : false
      },
      {
        'gender': _selectedGender.toString(),
        "isChanged": _selectedGender.toString() !=
                widget.profileDetails[0].personalDetails['gender']
            ? true
            : false
      },
      {
        'maritalStatus': _selectedMaritalStatusRadio.toString(),
        "isChanged": _selectedMaritalStatusRadio.toString() !=
                widget.profileDetails[0].personalDetails['maritalStatus']
            ? true
            : false
      },
      {
        'category': _selectedCategoryRadio,
        "isChanged": _selectedCategoryRadio !=
                widget.profileDetails[0].personalDetails['category']
            ? true
            : false
      },
      {
        'knownLanguages': _otherLanguages,
        "isChanged": (_otherLanguages.toString() !=
                    widget.profileDetails[0].personalDetails['knownLanguages']
                        .toString() &&
                _otherLanguages.length > 0)
            ? true
            : false
      },
      {
        'countryCode': _countryCodeController.text.toString(),
        "isChanged": _countryCodeController.text.toString() !=
                widget.profileDetails[0].personalDetails['countryCode']
                    .toString()
            ? true
            : false
      },
      {
        'mobile': _mobileNoController.text,
        "isChanged": _mobileNoController.text.toString() !=
                widget.profileDetails[0].personalDetails['mobile'].toString()
            ? true
            : false,
        "phoneVerified":
            (widget.profileDetails[0].personalDetails['phoneVerified'] != null
                    ? widget.profileDetails[0].personalDetails['phoneVerified']
                    : false) &&
                (_mobileNoController.text.toString() ==
                    widget.profileDetails[0].personalDetails['mobile']
                        .toString())
      },
      {
        "phoneVerified":
            (widget.profileDetails[0].personalDetails['phoneVerified'] != null
                    ? widget.profileDetails[0].personalDetails['phoneVerified']
                    : false) &&
                (_mobileNoController.text.toString() ==
                    widget.profileDetails[0].personalDetails['mobile']
                        .toString()),
        "isChanged": _mobileNoController.text.toString() !=
                widget.profileDetails[0].personalDetails['mobile'].toString()
            ? true
            : false,
      },
      {
        'telephone': _telephoneNoController.text.toString(),
        "isChanged": _telephoneNoController.text.toString() !=
                widget.profileDetails[0].personalDetails['telephone'].toString()
            ? true
            : false
      },
      {
        'primaryEmail': _primaryEmailController.text,
        "isChanged": _primaryEmailController.text !=
                widget.profileDetails[0].personalDetails['primaryEmail']
            ? true
            : false
      },
      {
        'officialEmail': _officialEmail ? _primaryEmailController.text : '',
        "isChanged": true
      },
      {
        'secondaryEmail': _secondaryEmailController.text,
        "isChanged": _secondaryEmailController.text !=
                widget.profileDetails[0].personalDetails['personalEmail']
            ? true
            : false
      },
      {
        'postalAddress': _postalAddressController.text,
        "isChanged": _postalAddressController.text !=
                widget.profileDetails[0].personalDetails['postalAddress']
            ? true
            : false
      },
      {
        'pincode': _pinCodeController.text.toString(),
        "isChanged": _pinCodeController.text.toString() !=
            widget.profileDetails[0].personalDetails['pincode']
      },
    ];
    var edited = {};
    var editedPersonalDetails =
        personalDetails.where((data) => data['isChanged'] == true);

    editedPersonalDetails.forEach((element) {
      edited[element.entries.first.key] = element.entries.first.value;
    });
    // developer.log(edited.toString());
    return edited;
  }

  bool checkMandatoryFieldsStatus() {
    return (personalDetailsFormKey.currentState != null &&
        personalDetailsFormKey.currentState.validate() &&
        (_nationalityController.text.trim().isNotEmpty &&
            _domicileMediumController.text.trim().isNotEmpty &&
            _selectedGender.trim().isNotEmpty &&
            _selectedMaritalStatusRadio.trim().isNotEmpty &&
            _selectedCategoryRadio.trim().isNotEmpty));
  }

  Future<void> saveProfile() async {
    var editedPersonalDetails = await _getEditedFields();
    if (_imageBase64 != widget.profileDetails[0].photo) {
      _profileData = {
        // "id": widget.profileDetails[0].rawDetails['userId'],
        // "userId": widget.profileDetails[0].rawDetails['userId'],
        "photo": _imageBase64,
        "personalDetails": editedPersonalDetails,
        'academics': widget.profileDetails[0].education,
        // 'employmentDetails': widget.profileDetails[0].employmentDetails,
        // 'professionalDetails': widget.profileDetails[0].professionalDetails,
        // 'skills': widget.profileDetails[0].skills,
        // "interests": widget.profileDetails[0].interests,
        "competencies": widget.profileDetails[0].competencies
        // "skills": {"additionalSkills": "", "certificateDetails": ""},
        // "interests": {"professional": [], "hobbies": []}
      };
    } else {
      _profileData = {
        "personalDetails": editedPersonalDetails,
        'academics': widget.profileDetails[0].education,
        // 'employmentDetails': widget.profileDetails[0].employmentDetails,
        // 'professionalDetails': widget.profileDetails[0].professionalDetails,
        // 'skills': widget.profileDetails[0].skills,
        // "interests": widget.profileDetails[0].interests,
        "competencies": widget.profileDetails[0].competencies
        // "skills": {"additionalSkills": "", "certificateDetails": ""},
        // "interests": {"professional": [], "hobbies": []}
      };
    }

    // _profileData = {
    //   // "id": widget.profileDetails[0].rawDetails['userId'],
    //   // "userId": widget.profileDetails[0].rawDetails['userId'],
    //   "photo": _imageBase64,
    //   "personalDetails": {
    //     "personalEmail": _secondaryEmailController.text,
    //     "firstname": _firstNameController.text,
    //     "middlename": _middleNameController.text,
    //     'surname': _surNameController.text,
    //     'dob': _dobController.text,
    //     'nationality': _nationalityController.text.toString(),
    //     'domicileMedium': _domicileMediumController.text.toString(),
    //     'gender': _selectedGender.toString(),
    //     'maritalStatus': _selectedMaritalStatusRadio.toString(),
    //     // 'category': _categoryValue,
    //     'category': _selectedCategoryRadio,
    //     'knownLanguages': _otherLanguages,
    //     'countryCode': _countryCodeController.text.toString(),
    //     'mobile': _mobileNoController.text,
    //     'telephone': _telephoneNoController.text.toString(),
    //     'primaryEmail': _primaryEmailController.text,
    //     'officialEmail': _officialEmail ? _primaryEmailController.text : '',
    //     'secondaryEmail': _secondaryEmailController.text,
    //     'postalAddress': _postalAddressController.text,
    //     'pincode': _pinCodeController.text.toString(),
    //   },
    //   'academics': widget.profileDetails[0].education,
    //   // 'employmentDetails': widget.profileDetails[0].employmentDetails,
    //   // 'professionalDetails': widget.profileDetails[0].professionalDetails,
    //   // 'skills': widget.profileDetails[0].skills,
    //   // "interests": widget.profileDetails[0].interests,
    //   "competencies": widget.profileDetails[0].competencies
    //   // "skills": {"additionalSkills": "", "certificateDetails": ""},
    //   // "interests": {"professional": [], "hobbies": []}
    // };
    // developer.log(_profileData.toString());
    var response;
    if (checkMandatoryFieldsStatus()) {
      try {
        response = await profileService.updateProfileDetails(_profileData);
        FocusManager.instance.primaryFocus.unfocus();
        var snackBar;
        if (response['params']['errmsg'] == null ||
            response['params']['errmsg'] == '') {
          snackBar = SnackBar(
            content: Container(
                // padding: const EdgeInsets.only(top: 7, bottom: 7),
                // margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Text(
              'Personal details updated.',
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
    } else
      ScaffoldMessenger.of(widget.scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Container(
            // padding: const EdgeInsets.only(top: 5),
            // margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: Text(
          'Please fill all the mandatory fields.',
        )),
        backgroundColor: Theme.of(context).errorColor,
      ));
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _sendOTPToVerifyNumber() async {
    _getResendTimeOTP();
    _startTimer();
    final response =
        await profileService.generateMobileNumberOTP(_mobileNoController.text);
    if (response['params']['errmsg'] == null ||
        response['params']['errmsg'] == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EnglishLang.otpSentToMobile,
              style: GoogleFonts.lato(
                color: Colors.white,
              )),
          backgroundColor: AppColors.positiveLight,
        ),
      );
      setState(() {
        _hasSendOTPRequest = true;
        _freezeMobileField = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['params']['errmsg'].toString(),
              style: GoogleFonts.lato(
                color: Colors.white,
              )),
          backgroundColor: AppColors.negativeLight,
        ),
      );
    }
  }

  _verifyOTP(otp) async {
    final response = await profileService.verifyMobileNumberOTP(
        _mobileNoController.text, otp);

    if (response['params']['errmsg'] == null ||
        response['params']['errmsg'] == '') {
      //call extPatch
      _profileData = {
        "personalDetails": {
          "mobile": "${_mobileNoController.text}",
          "phoneVerified": true
        },
      };
      final response = await profileService.updateProfileDetails(_profileData);
      if (response['params']['status'] == 'success' ||
          response['params']['status'] == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.mobileVerifiedMessage,
                style: GoogleFonts.lato(
                  color: Colors.white,
                )),
            backgroundColor: AppColors.positiveLight,
          ),
        );
        setState(() {
          _hasSendOTPRequest = false;
          widget.parentAction();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['params']['errmsg'].toString(),
                style: GoogleFonts.lato(
                  color: Colors.white,
                )),
            backgroundColor: AppColors.negativeLight,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['params']['errmsg'].toString(),
              style: GoogleFonts.lato(
                color: Colors.white,
              )),
          backgroundColor: AppColors.negativeLight,
        ),
      );
    }
    setState(() {
      _freezeMobileField = false;
    });
  }

  // void _updateGender(key, value) {
  //   setState(() {
  //     _gender = {
  //       EnglishLang.male: false,
  //       EnglishLang.female: false,
  //       EnglishLang.others: false,
  //     };
  //     _gender[key] = value;
  //     _genderValue = key;
  //   });
  // }

  // void _updateMaritalStatus(key, value) {
  //   setState(() {
  //     _maritalStatus = {
  //       EnglishLang.single: false,
  //       EnglishLang.married: false,
  //     };
  //     _maritalStatus[key] = value;
  //     _maritalStatusValue = key;
  //   });
  // }

  // void _updateCategory(key, value) {
  //   setState(() {
  //     _category = {
  //       EnglishLang.general: false,
  //       EnglishLang.obc: false,
  //       EnglishLang.sc: false,
  //       EnglishLang.st: false,
  //     };
  //     _category[key] = value;
  //     _categoryValue = key;
  //   });
  // }

  // Future<List<Profile>> _getProfileDetails() async {
  //   _profileDetails = await profileService.getProfileDetails();
  //   // print(_profileDetails);
  //   return _profileDetails;
  // }

  Widget _getImageWidget() {
    if (_selectedFile != null) {
      List<int> imageBytes = _selectedFile.readAsBytesSync();
      _imageBase64 = 'data:image/jpeg;base64,' + base64Encode(imageBytes);
      return Stack(children: [
        Container(
          padding: EdgeInsets.all(30),
          child: Image.file(
            _selectedFile,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 20,
          right: 0,
          child: InkWell(
            onTap: () {
              photoOptions(context);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey08,
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(
                        3,
                        3,
                      ),
                    ),
                  ],
                ),
                height: 48,
                width: 48,
                child: Icon(
                  Icons.edit,
                  color: AppColors.greys60,
                )),
          ),
        )
      ]);
    } else {
      return widget.profileDetails[0].photo != null &&
              widget.profileDetails[0].photo != ''
          ? Stack(children: [
              Container(
                padding: EdgeInsets.all(30),
                child: Image.memory(
                  Helper.getByteImage(widget.profileDetails[0].photo),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 0,
                child: InkWell(
                  onTap: () {
                    photoOptions(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey08,
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(
                              3,
                              3,
                            ),
                          ),
                        ],
                      ),
                      height: 48,
                      width: 48,
                      child: Icon(
                        Icons.edit,
                        color: AppColors.greys60,
                      )),
                ),
              )
            ])
          : Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grey16,
                  width: 1,
                ),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _getImageWidget(),

                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: SvgPicture.asset('assets/img/connections_empty.svg',
                        width: 48, height: 48, fit: BoxFit.cover),
                  ),
                  InkWell(
                    onTap: () {
                      photoOptions(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: AppColors.primaryThree,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                EnglishLang.addAPhoto,
                                style: GoogleFonts.lato(
                                    color: AppColors.primaryThree,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            );
    }
  }

  Future<bool> photoOptions(contextMain) {
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
                          height: 120.0,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                    _getImage(ImageSource.camera);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.photo_camera,
                                        color: AppColors.primaryThree,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          EnglishLang.takeAPicture,
                                          style: GoogleFonts.montserrat(
                                              decoration: TextDecoration.none,
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                    _getImage(ImageSource.gallery);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.photo),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          EnglishLang.goToFiles,
                                          style: GoogleFonts.montserrat(
                                              decoration: TextDecoration.none,
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )))
              ],
            ));
  }

  Future<dynamic> _getImage(ImageSource source) async {
    _inProcess = true;
    PickedFile image = await _picker.getImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: AppColors.primaryThree,
            toolbarTitle: EnglishLang.cropImage,
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.grey.shade900,
            backgroundColor: Colors.white,
          ));
      setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  Widget _addOtherLang() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _otherLanguages.add(_otherLangsController.text);
          _otherLanguages.toSet().toList();
        });
        _otherLangsController.clear();
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

  Widget _fieldNameWidget(String fieldName, {bool isMandatory = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !isMandatory
              ? Text(
                  fieldName,
                  style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                )
              : RichText(
                  text: TextSpan(
                      text: fieldName,
                      style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                      ]),
                ),
          // Icon(Icons.check_circle_outline)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _otherLangsController.dispose();
    _mobileNoController.dispose();
    _countryCodeController.dispose();
    _telephoneNoController.dispose();
    _primaryEmailController.dispose();
    _secondaryEmailController.dispose();
    _postalAddressController.dispose();
    _pinCodeController.dispose();

    _firstNameFocus.dispose();
    _middleNameFocus.dispose();
    _dobFocus.dispose();
    _nationalityFocus.dispose();
    _domicileMediumFocus.dispose();
    _otherLangsFocus.dispose();
    _mobileNoFocus.dispose();
    _countryCodeFocus.dispose();
    _telephoneNoFocus.dispose();
    _primaryEmailFocus.dispose();
    _secondaryEmailFocus.dispose();
    _postalAddressFocus.dispose();
    _pinCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLanguages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data != null) {
          return SingleChildScrollView(
              child: Form(
            key: personalDetailsFormKey,
            child: Container(
                padding: const EdgeInsets.only(
                    bottom: 100, left: 0, right: 0, top: 16),
                color: Colors.white,
                child: Column(children: [
                  // Container(
                  //     width: 250,
                  //     height: 250,
                  //     // height: MediaQuery.of(context).size.height,
                  //     padding: const EdgeInsets.all(20),
                  //     child: Stack(
                  //       children: [
                  //         Container(
                  //             // padding: const EdgeInsets.all(20),
                  //             child: _getImageWidget()),
                  //         _inProcess
                  //             ? Container(
                  //                 height: MediaQuery.of(context).size.height,
                  //                 child: Center(
                  //                   child: CircularProgressIndicator(),
                  //                 ),
                  //               )
                  //             : Center(),
                  //       ],
                  //     )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: EnglishLang.firstName,
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))
                              ]),
                        ),
                        // Icon(Icons.check_circle_outline)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      // height: 40,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Focus(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return EnglishLang.firstNameMandatory;
                            } else
                              return null;
                          },
                          focusNode: _firstNameFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _firstNameFocus, _middleNameFocus);
                          },
                          // onChanged: (value) =>
                          //     _updateProfileDetails(),
                          controller: _firstNameController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 10.0),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.middleName),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          focusNode: _middleNameFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _middleNameFocus, _surNameFocus);
                          },
                          controller: _middleNameController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.surName, isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName, EnglishLang.surName);
                            } else
                              return null;
                          },
                          focusNode: _surNameFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _surNameFocus, _dobFocus);
                          },
                          controller: _surNameController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.dob, isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName, EnglishLang.dob);
                            } else
                              return null;
                          },
                          focusNode: _dobFocus,
                          readOnly: true,
                          onTap: () async {
                            DateTime newDate = await showDatePicker(
                                context: context,
                                initialDate: _dobDate == null
                                    ? (_dobController.text != null &&
                                            _dobController.text != ''
                                        ? DateTime.parse(_dobController.text
                                            .toString()
                                            .split('-')
                                            .reversed
                                            .join('-'))
                                        : DateTime.now())
                                    : _dobDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            if (newDate == null) {
                              return null;
                            }
                            setState(() {
                              _dobDate = newDate;
                              _dobController.text = newDate
                                  .toString()
                                  .split(' ')
                                  .first
                                  .split('-')
                                  .reversed
                                  .join('-');
                            });
                          },
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _dobFocus, _nationalityFocus);
                          },
                          controller: _dobController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.grey16)),
                            hintText: _dobController.text != ''
                                ? _dobController.text
                                : EnglishLang.chooseDate,
                            hintStyle: GoogleFonts.lato(
                                color: AppColors.grey40,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.primaryThree, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.nationality, isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 40.0,
                      child: SimpleAutoCompleteTextField(
                        key: key1,
                        suggestions: _nationalities,
                        controller: _nationalityController,
                        focusNode: _nationalityFocus,
                        clearOnSubmit: false,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.avatarRed)),
                          hintText: EnglishLang.typeHere,
                          hintStyle: GoogleFonts.lato(
                              color: AppColors.grey40,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.primaryThree, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ((key1.currentState != null && key1.currentState != null) &&
                          key1.currentState.currentText.isEmpty)
                      ? Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName,
                                  EnglishLang.nationality),
                              style: GoogleFonts.lato(
                                  color: AppColors.negativeLight),
                            ),
                          ),
                        )
                      : Center(),
                  _fieldNameWidget(EnglishLang.gender, isMandatory: true),
                  // for (var entry in _gender.entries)
                  //   Padding(
                  //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  //     child: Container(
                  //       margin: const EdgeInsets.only(top: 10),
                  //       alignment: Alignment.centerLeft,
                  //       decoration: BoxDecoration(
                  //         color: entry.value
                  //             ? Color.fromRGBO(0, 116, 182, 0.05)
                  //             : Colors.white,
                  //         border: Border.all(
                  //           color: entry.value
                  //               ? AppColors.primaryThree
                  //               : AppColors.grey16,
                  //           width: 1,
                  //         ),
                  //         borderRadius: BorderRadius.circular(4),
                  //       ),
                  //       height: 48.0,
                  //       child: Row(
                  //         children: [
                  //           Checkbox(
                  //             value: entry.value,
                  //             onChanged: (value) {
                  //               _updateGender(entry.key, value);
                  //             },
                  //             // activeTrackColor: Color.fromRGBO(0, 116, 182, 0.3),
                  //             activeColor: AppColors.primaryThree,
                  //           ),
                  //           Text(
                  //             entry.key != null ? entry.key : '',
                  //             textAlign: TextAlign.center,
                  //             style: GoogleFonts.lato(
                  //                 color: AppColors.greys87,
                  //                 fontSize: 14.0,
                  //                 fontWeight: FontWeight.w400),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _genderRadio.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(4.0)),
                              border: Border.all(
                                  color:
                                      (_selectedGender == _genderRadio[index])
                                          ? AppColors.primaryThree
                                          : AppColors.grey16,
                                  width: 1.5),
                            ),
                            child: RadioListTile(
                              dense: true,
                              // contentPadding: EdgeInsets.only(bottom:20),
                              groupValue: _selectedGender,
                              title: Text(
                                _genderRadio[index],
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              value: _genderRadio[index],
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              selected:
                                  (_selectedGender == _genderRadio[index]),
                              selectedTileColor:
                                  AppColors.selectionBackgroundBlue,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  (_selectedGender == '')
                      ? Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32, top: 8),
                            child: Text(
                              EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName, EnglishLang.gender),
                              style: GoogleFonts.lato(
                                  color: AppColors.negativeLight),
                            ),
                          ),
                        )
                      : Center(),
                  _fieldNameWidget(EnglishLang.maritalStatus,
                      isMandatory: true),
                  // for (var entry in _maritalStatus.entries)
                  //   Padding(
                  //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  //     child: Container(
                  //       margin: const EdgeInsets.only(top: 10),
                  //       alignment: Alignment.centerLeft,
                  //       decoration: BoxDecoration(
                  //         color: entry.value
                  //             ? Color.fromRGBO(0, 116, 182, 0.05)
                  //             : Colors.white,
                  //         border: Border.all(
                  //           color: entry.value
                  //               ? AppColors.primaryThree
                  //               : AppColors.grey16,
                  //           width: 1,
                  //         ),
                  //         borderRadius: BorderRadius.circular(4),
                  //       ),
                  //       height: 48.0,
                  //       child: Row(
                  //         children: [
                  //           Checkbox(
                  //             value: entry.value,
                  //             onChanged: (value) {
                  //               _updateMaritalStatus(entry.key, value);
                  //             },
                  //             // activeTrackColor: Color.fromRGBO(0, 116, 182, 0.3),
                  //             activeColor: AppColors.primaryThree,
                  //           ),
                  //           Text(
                  //             entry.key != null ? entry.key : '',
                  //             textAlign: TextAlign.center,
                  //             style: GoogleFonts.lato(
                  //                 color: AppColors.greys87,
                  //                 fontSize: 14.0,
                  //                 fontWeight: FontWeight.w400),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _maritalStatusRadio.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(4.0)),
                              border: Border.all(
                                  color: (_selectedMaritalStatusRadio ==
                                          _maritalStatusRadio[index])
                                      ? AppColors.primaryThree
                                      : AppColors.grey16,
                                  width: 1.5),
                            ),
                            child: RadioListTile(
                              dense: true,
                              // contentPadding: EdgeInsets.only(bottom:20),
                              groupValue: _selectedMaritalStatusRadio,
                              title: Text(
                                _maritalStatusRadio[index],
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              value: _maritalStatusRadio[index],
                              onChanged: (value) {
                                setState(() {
                                  _selectedMaritalStatusRadio = value;
                                });
                              },
                              selected: (_selectedMaritalStatusRadio ==
                                  _maritalStatusRadio[index]),
                              selectedTileColor:
                                  AppColors.selectionBackgroundBlue,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  (_selectedMaritalStatusRadio == '')
                      ? Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32, top: 8),
                            child: Text(
                              EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName,
                                  EnglishLang.maritalStatus),
                              style: GoogleFonts.lato(
                                  color: AppColors.negativeLight),
                            ),
                          ),
                        )
                      : Center(),
                  _fieldNameWidget(EnglishLang.category, isMandatory: true),
                  // for (var entry in _category.entries)
                  //   Padding(
                  //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  //     child: Container(
                  //       margin: const EdgeInsets.only(top: 10),
                  //       alignment: Alignment.centerLeft,
                  //       decoration: BoxDecoration(
                  //         color: entry.value
                  //             ? Color.fromRGBO(0, 116, 182, 0.05)
                  //             : Colors.white,
                  //         border: Border.all(
                  //           color: entry.value
                  //               ? AppColors.primaryThree
                  //               : AppColors.grey16,
                  //           width: 1,
                  //         ),
                  //         borderRadius: BorderRadius.circular(4),
                  //       ),
                  //       height: 48.0,
                  //       child: Row(
                  //         children: [
                  //           Checkbox(
                  //             value: entry.value,
                  //             onChanged: (value) {
                  //               _updateCategory(entry.key, value);
                  //             },
                  //             // activeTrackColor: Color.fromRGBO(0, 116, 182, 0.3),
                  //             activeColor: AppColors.primaryThree,
                  //           ),
                  //           Text(
                  //             entry.key != null ? entry.key : '',
                  //             textAlign: TextAlign.center,
                  //             style: GoogleFonts.lato(
                  //                 color: AppColors.greys87,
                  //                 fontSize: 14.0,
                  //                 fontWeight: FontWeight.w400),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _categoryRadio.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(4.0)),
                              border: Border.all(
                                  color: (_selectedCategoryRadio ==
                                          _categoryRadio[index])
                                      ? AppColors.primaryThree
                                      : AppColors.grey16,
                                  width: 1.5),
                            ),
                            child: RadioListTile(
                              dense: true,
                              // contentPadding: EdgeInsets.only(bottom:20),
                              groupValue: _selectedCategoryRadio,
                              title: Text(
                                _categoryRadio[index],
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              value: _categoryRadio[index],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategoryRadio = value;
                                });
                              },
                              selected: (_selectedCategoryRadio ==
                                  _categoryRadio[index]),
                              selectedTileColor:
                                  AppColors.selectionBackgroundBlue,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  (_selectedCategoryRadio == '')
                      ? Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32, top: 8),
                            child: Text(
                              EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName, EnglishLang.category),
                              style: GoogleFonts.lato(
                                  color: AppColors.negativeLight),
                            ),
                          ),
                        )
                      : Center(),
                  _fieldNameWidget(EnglishLang.domicileMeduium,
                      isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 40.0,
                      child: SimpleAutoCompleteTextField(
                        key: key2,
                        suggestions: _languages,
                        controller: _domicileMediumController,
                        focusNode: _domicileMediumFocus,
                        // onFocusChanged: (term) {
                        //   _fieldFocusChange(
                        //       context,
                        //       _domicileMediumFocus,
                        //       _otherLangsFocus);
                        // },
                        clearOnSubmit: false,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
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
                        ),
                      ),
                    ),
                  ),
                  ((key2.currentState != null && key2.currentState != null) &&
                          key2.currentState.currentText.isEmpty)
                      ? Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName,
                                  EnglishLang.domicileMeduium),
                              style: GoogleFonts.lato(
                                  color: AppColors.negativeLight),
                            ),
                          ),
                        )
                      : Center(),
                  _fieldNameWidget(EnglishLang.otherLangs),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          textInputAction: TextInputAction.go,
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: _otherLangsFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _domicileMediumFocus,
                                _otherLangsFocus);
                          },
                          controller: _otherLangsController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.grey16)),
                            hintText: EnglishLang.typeHere,
                            suffix: _addOtherLang(),
                            hintStyle: GoogleFonts.lato(
                                color: AppColors.grey40,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.primaryThree, width: 1.0),
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
                        for (var i in _otherLanguages)
                          Container(
                            margin: const EdgeInsets.only(left: 12.0),
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
                                        size: 25.0, color: AppColors.grey40),
                                  ),
                                ],
                              ),
                              onDeleted: () {
                                setState(() {
                                  _otherLanguages
                                      .removeAt(_otherLanguages.indexOf(i));
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.mobileNumber, isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        // height: 70.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              height: 50.0,
                              width: MediaQuery.of(context).size.width * 0.165,
                              child: SimpleAutoCompleteTextField(
                                key: key3,
                                suggestions: _countryCodes,
                                controller: _countryCodeController,
                                focusNode: _countryCodeFocus,
                                keyboardType: TextInputType.phone,
                                clearOnSubmit: false,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.grey16)),
                                  hintText: '+91',
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
                            Container(
                                height: 70,
                                width:
                                    MediaQuery.of(context).size.width * 0.725,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Focus(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    focusNode: _mobileNoFocus,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(context, _mobileNoFocus,
                                          _telephoneNoFocus);
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _hasSendOTPRequest = false;
                                        widget.profileDetails[0]
                                                .personalDetails[
                                            'phoneVerified'] = false;
                                        if (value.trim().length > 9 &&
                                            (widget.profileDetails[0]
                                                        .personalDetails[
                                                    'mobile'] ==
                                                value.trim())) {
                                          widget.parentAction();
                                        }
                                      });
                                    },
                                    readOnly: _freezeMobileField,
                                    controller: _mobileNoController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String value) {
                                      if (value.trim().isEmpty) {
                                        return EnglishLang.firstNameMandatory
                                            .replaceAll(EnglishLang.firstName,
                                                EnglishLang.mobileNumber);
                                      } else if (value.trim().length != 10) {
                                        return EnglishLang.pleaseAddValidNumber;
                                      } else
                                        return null;
                                    },
                                    style: GoogleFonts.lato(fontSize: 14.0),
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      suffixIcon: (widget.profileDetails[0]
                                                          .personalDetails[
                                                      'phoneVerified'] ==
                                                  true &&
                                              _mobileNoController.text
                                                      .toString()
                                                      .trim() ==
                                                  widget.profileDetails[0]
                                                      .personalDetails['mobile']
                                                      .toString()
                                                      .trim())
                                          ? Icon(
                                              Icons.verified,
                                              color: AppColors.positiveLight,
                                            )
                                          : null,
                                      contentPadding: EdgeInsets.fromLTRB(
                                          16.0, 0.0, 20.0, 0.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.grey16)),
                                      hintText: EnglishLang.typeHere,
                                      helperText: EnglishLang.addValidNumber,
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
                                )),
                          ],
                        )),
                  ),
                  widget.profileDetails[0].personalDetails['phoneVerified'] !=
                          true
                      ? !_hasSendOTPRequest
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.positiveLight,
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed:
                                    _mobileNoController.text.trim().length == 10
                                        ? () async {
                                            await _sendOTPToVerifyNumber();
                                          }
                                        : null,
                                child: Text(
                                  EnglishLang.sendOtp,
                                  style: GoogleFonts.lato(
                                      height: 1.429,
                                      letterSpacing: 0.5,
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          // height: 70,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Focus(
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              // focusNode: _mobileNoFocus,
                                              // onFieldSubmitted: (term) {
                                              //   _fieldFocusChange(
                                              //       context, _mobileNoFocus, _telephoneNoFocus);
                                              // },
                                              controller:
                                                  _mobileNoOTPController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return EnglishLang
                                                      .pleaseEnterOtp;
                                                } else
                                                  return null;
                                              },
                                              style: GoogleFonts.lato(
                                                  fontSize: 14.0),
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        16.0, 0.0, 20.0, 0.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            AppColors.grey16)),
                                                hintText: EnglishLang.enterOtp,
                                                // helperText: EnglishLang.addValidNumber,
                                                hintStyle: GoogleFonts.lato(
                                                    color: AppColors.grey40,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: AppColors
                                                          .primaryThree,
                                                      width: 1.0),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Container(
                                        // height: 45,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.positiveLight,
                                            minimumSize:
                                                const Size.fromHeight(48),
                                          ),
                                          onPressed: () async {
                                            await _verifyOTP(
                                                _mobileNoOTPController.text);
                                          },
                                          child: Text(
                                            EnglishLang.verifyOtp,
                                            style: GoogleFonts.lato(
                                                height: 1.429,
                                                letterSpacing: 0.5,
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  !_showResendOption
                                      ? Container(
                                          padding: EdgeInsets.only(top: 16),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              'Resend OTP after $_timeFormat'),
                                        )
                                      : Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.only(top: 16),
                                          child: TextButton(
                                              onPressed: () {
                                                _sendOTPToVerifyNumber();
                                                setState(() {
                                                  _showResendOption = false;
                                                  _resendOTPTime = 180;
                                                });
                                              },
                                              child:
                                                  Text(EnglishLang.resendOtp)),
                                        )
                                ],
                              ),
                            )
                      : Center(),

                  _fieldNameWidget(EnglishLang.telephoneNumber),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _telephoneNoFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _telephoneNoFocus, _primaryEmailFocus);
                          },
                          controller: _telephoneNoController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.grey16)),
                            hintText: EnglishLang.telephoneNumberExample,
                            hintStyle: GoogleFonts.lato(
                                color: AppColors.grey40,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.primaryThree, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.primaryEmail, isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _primaryEmailFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _primaryEmailFocus,
                                _secondaryEmailFocus);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName,
                                  EnglishLang.primaryEmail);
                            } else
                              return null;
                          },
                          controller: _primaryEmailController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _officialEmail,
                          onChanged: (value) {
                            setState(() {
                              _officialEmail = !_officialEmail;
                            });
                          },
                        ),
                        Text(
                          EnglishLang.myOfficialEmailText,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.secondaryEmail),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: _secondaryEmailFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _secondaryEmailFocus,
                                _postalAddressFocus);
                          },
                          controller: _secondaryEmailController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  _fieldNameWidget(EnglishLang.postalAddress,
                      isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // height: 50.0,
                      child: Focus(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _postalAddressFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _postalAddressFocus, _pinCodeFocus);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName,
                                  EnglishLang.postalAddress);
                            } else
                              return null;
                          },
                          onChanged: (text) {
                            setState(() {
                              _postalAddressLength = text.length;
                            });
                          },
                          controller: _postalAddressController,
                          maxLength: 200,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: 5,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16.0, 20.0, 20.0, 0.0),
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
                              counterStyle: TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: ''),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 5, right: 16),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _postalAddressLength.toString() +
                              '/200 ' +
                              EnglishLang.chacters,
                          style: GoogleFonts.lato(
                            color: AppColors.greys60,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                  _fieldNameWidget(EnglishLang.pinCode, isMandatory: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // height: 40.0,
                      child: Focus(
                        child: TextFormField(
                          // textInputAction: TextInputAction.next,
                          focusNode: _pinCodeFocus,
                          // obscureText: true,
                          // onFieldSubmitted: (term) {
                          //   _fieldFocusChange(
                          //       context,
                          //       _secondaryEmailFocus,
                          //       _postalAddressFocus);
                          // },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return EnglishLang.firstNameMandatory.replaceAll(
                                  EnglishLang.firstName, EnglishLang.pinCode);
                            } else
                              return null;
                          },
                          controller: _pinCodeController,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 20.0, 0.0),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
          ));
        } else {
          return Center();
        }
      },
    );
  }
}
