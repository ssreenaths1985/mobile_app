// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:provider/provider.dart';
// import './../../../../ui/widgets/index.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';
import './../../../../services/index.dart';
import './../../../../localization/index.dart';
// import 'dart:developer' as developer;

class EditProfessionalDetailsPage extends StatefulWidget {
  final profileDetails;
  final scaffoldKey;
  static final GlobalKey<_EditProfessionalDetailsPageState>
      professionalDetailsGlobalKey = GlobalKey();
  EditProfessionalDetailsPage({
    Key key,
    this.profileDetails,
    this.scaffoldKey,
  }) : super(key: professionalDetailsGlobalKey);

  @override
  _EditProfessionalDetailsPageState createState() =>
      _EditProfessionalDetailsPageState();
}

class _EditProfessionalDetailsPageState
    extends State<EditProfessionalDetailsPage> {
  final ProfileService profileService = ProfileService();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _allotmentYearOfServiceController =
      TextEditingController();
  final TextEditingController _dateOfJoiningController =
      TextEditingController();
  final TextEditingController _dateOfJoiningExpController =
      TextEditingController();
  final TextEditingController _civilListNumberController =
      TextEditingController();
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _officialPostalAddressController =
      TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _allotmentYearOfServiceFocus = FocusNode();
  final FocusNode _dateOfJoiningFocus = FocusNode();
  final FocusNode _dateOfJoiningExpFocus = FocusNode();
  final FocusNode _civilListNumberFocus = FocusNode();
  final FocusNode _employeeCodeFocus = FocusNode();
  final FocusNode _officialPostalAddressFocus = FocusNode();
  final FocusNode _pinCodeFocus = FocusNode();

  Map _organisationTypes = <String, bool>{
    EnglishLang.government: false,
    EnglishLang.nonGovernment: false,
  };

  List _organizationTypesRadio = [
    EnglishLang.government,
    EnglishLang.nonGovernment
  ];

  // String _orgType;
  List<String> _organisationList = [];
  List<String> _industriesList = [];
  List<String> _locationList = [];
  List<String> _designationList = [];
  List<String> _gradePayList = [];
  List<String> _serviceList = [];
  List<String> _cadreList = [];
  String _selectedOrganisation;
  String _selectedIndustry;
  String _selectedLocation;
  String _selectedDesignation;
  String _selectedGradePay;
  String _selectedService;
  String _selectedCadre;
  Map _profileData;
  String _selectedOrg = '';
  TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  DateTime _selectedDate;
  List<dynamic> _inReview = [];

  @override
  void initState() {
    super.initState();
    _populateFields();
    _getOrganisations();
    _getLocations();
    _getIndustries();
    _getDesignations();
    _getGradePay();
    _getServices();
    _getCadre();
    _getInReviewFields();
    // print(widget.profileDetails[0]);
  }

  _getInReviewFields() async {
    final response = await profileService.getInReviewFields();
    _inReview = response['result']['data'];
  }

  Future<void> _populateFields() async {
    if (widget.profileDetails[0].experience.toString() != [].toString()) {
      setState(() {
        if (widget.profileDetails[0].experience[0]['organisationType'] !=
                null &&
            widget.profileDetails[0].experience[0]['organisationType'] != '') {
          _organisationTypes[widget.profileDetails[0].experience[0]
              ['organisationType']] = true;
          _selectedOrg =
              widget.profileDetails[0].experience[0]['organisationType'];
          // _orgType = widget.profileDetails[0].experience[0]['organisationType'];
        } else {
          if (widget.profileDetails[0].rawDetails['rootOrg']
                      ['organisationType'] !=
                  null &&
              widget.profileDetails[0].rawDetails['rootOrg']['organisationType']
                      .toString() !=
                  '') {
            _organisationTypes[widget.profileDetails[0].rawDetails['rootOrg']
                        ['organisationType'] ==
                    128
                ? EnglishLang.government
                : EnglishLang.nonGovernment] = true;
            _selectedOrg = widget.profileDetails[0].rawDetails['rootOrg']
                        ['organisationType'] ==
                    128
                ? EnglishLang.government
                : EnglishLang.nonGovernment;
          }
        }
        // _selectedOrg =
        //     widget.profileDetails[0].experience[0]['organisationType'];
        // _selectedOrganisation = widget.profileDetails[0].experience[0]['name'];
        _selectedOrganisation =
            widget.profileDetails[0].rawDetails['rootOrg']['orgName'];
        _selectedIndustry = widget.profileDetails[0].experience[0]['industry'];
        _selectedDesignation =
            widget.profileDetails[0].experience[0]['designation'];
        _selectedLocation = widget.profileDetails[0].experience[0]['location'];
        _dateOfJoiningController.text =
            widget.profileDetails[0].experience[0]['doj'];
        _descriptionController.text =
            widget.profileDetails[0].experience[0]['description'];
        _selectedGradePay =
            widget.profileDetails[0].employmentDetails['payType'];
        _selectedService =
            widget.profileDetails[0].employmentDetails['service'];
        _selectedCadre = widget.profileDetails[0].employmentDetails['cadre'];
        _allotmentYearOfServiceController.text = widget
            .profileDetails[0].employmentDetails['allotmentYearOfService'];
        _dateOfJoiningExpController.text =
            widget.profileDetails[0].employmentDetails['dojOfService'];
        _civilListNumberController.text =
            widget.profileDetails[0].employmentDetails['civilListNo'];

        _employeeCodeController.text =
            widget.profileDetails[0].employmentDetails['employeeCode'];
        _officialPostalAddressController.text =
            widget.profileDetails[0].employmentDetails['officialPostalAddress'];
        _pinCodeController.text =
            widget.profileDetails[0].employmentDetails['pinCode'];
      });
    } else {
      setState(() {
        if (widget.profileDetails[0].rawDetails['rootOrg']
                    ['organisationType'] !=
                null &&
            widget.profileDetails[0].rawDetails['rootOrg']['organisationType']
                    .toString() !=
                '') {
          _organisationTypes[widget.profileDetails[0].rawDetails['rootOrg']
                      ['organisationType'] ==
                  128
              ? EnglishLang.government
              : EnglishLang.nonGovernment] = true;
          _selectedOrg = widget.profileDetails[0].rawDetails['rootOrg']
                      ['organisationType'] ==
                  128
              ? EnglishLang.government
              : EnglishLang.nonGovernment;
        }

        _selectedOrganisation =
            widget.profileDetails[0].rawDetails['rootOrg']['orgName'];
      });
    }
  }

  Future<void> _getOrganisations() async {
    List<dynamic> _organisations =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getOrganisations();
    setState(() {
      _organisationList =
          _organisations.map((item) => item.toString()).toList();
      // _organisationList.insert(0, EnglishLang.selectFromDropdown);
    });
  }

  Future<void> _getIndustries() async {
    List<dynamic> _industries =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getIndustries();
    setState(() {
      _industriesList = _industries.map((item) => item.toString()).toList();
      // _industriesList.insert(0, EnglishLang.selectFromDropdown);
    });
  }

  Future<void> _getDesignations() async {
    List<dynamic> _designations =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getDesignations();
    setState(() {
      _designationList = _designations.map((item) => item.toString()).toList();
      // _designationList.insert(0, EnglishLang.selectFromDropdown);
    });
  }

  //getGradePay

  Future<void> _getGradePay() async {
    List<dynamic> _gradepay =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getGradePay();
    setState(() {
      _gradePayList = _gradepay.map((item) => item.toString()).toList();
      // _gradePayList.insert(0, EnglishLang.selectFromDropdown);
    });
  }

  Future<void> _getServices() async {
    List<dynamic> _services =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getServices();
    setState(() {
      _serviceList = _services.map((item) => item.toString()).toList();
      // _serviceList.insert(0, EnglishLang.selectFromDropdown);
    });
  }

  Future<void> _getCadre() async {
    List<dynamic> _cadre =
        await Provider.of<ProfileRepository>(context, listen: false).getCadre();
    setState(() {
      _cadreList = _cadre.map((item) => item.toString()).toList();
      // _cadreList.insert(0, EnglishLang.selectFromDropdown);
    });
  }

  Future<void> _getLocations() async {
    List<Nationality> nationalities =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getNationalities();
    setState(() {
      _locationList =
          nationalities.map((item) => item.country.toString()).toList();
      // _locationList.insert(0, EnglishLang.selectFromDropdown);
    });
  }

  // Future<dynamic> _getProfilePageMeta() async {
  //   // var rawData = await profileService.getProfilePageMeta();
  //   // List<dynamic> designations = rawData['designations']['designations'];
  //   // _designationList =
  //   //     designations.map((item) => item['name'].toString()).toList();
  //   // _designationList.insert(0, EnglishLang.selectFromDropdown);

  //   // List<dynamic> industries = rawData['industries'];
  //   // _industriesList =
  //   //     industries.map((item) => item['name'].toString()).toList();
  //   // _industriesList.insert(0, EnglishLang.selectFromDropdown);

  //   // List<dynamic> gradePay = rawData['designations']['gradePay'];
  //   // _gradePayList = gradePay.map((item) => item['name'].toString()).toList();
  //   // _gradePayList.insert(0, EnglishLang.selectFromDropdown);

  //   // List<dynamic> services = rawData['govtOrg']['service'];
  //   // _serviceList = services.map((item) => item['name'].toString()).toList();
  //   // _serviceList.insert(0, EnglishLang.selectFromDropdown);

  //   // List<dynamic> cadre = rawData['govtOrg']['cadre'];
  //   // _cadreList = cadre.map((item) => item['name'].toString()).toList();
  //   // _cadreList.insert(0, EnglishLang.selectFromDropdown);
  //   return null;
  // }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // void _updateOrganisation(key, value) {
  //   setState(() {
  //     _organisationTypes = {
  //       EnglishLang.government: false,
  //       EnglishLang.nonGovernment: false,
  //     };
  //     _organisationTypes[key] = value;
  //     _orgType = key;
  //   });
  // }
  _getEditedEmploymentDetails() async {
    var employmentDetails = [
      {
        'allotmentYearOfService':
            _allotmentYearOfServiceController.text.toString(),
        'isChanged': _allotmentYearOfServiceController.text.toString() !=
                (widget.profileDetails[0]
                            .employmentDetails['allotmentYearOfService'] !=
                        null
                    ? widget.profileDetails[0]
                        .employmentDetails['allotmentYearOfService']
                        .toString()
                    : '')
            ? true
            : false
      },
      {
        'cadre': _selectedCadre,
        'isChanged': _selectedCadre !=
                widget.profileDetails[0].employmentDetails['cadre']
            ? true
            : false
      },
      {
        'civilListNo': _civilListNumberController.text.toString(),
        'isChanged': _civilListNumberController.text.toString() !=
                (widget.profileDetails[0].employmentDetails['civilListNo'] !=
                        null
                    ? widget.profileDetails[0].employmentDetails['civilListNo']
                        .toString()
                    : '')
            ? true
            : false
      },
      {
        'dojOfService': _dateOfJoiningExpController.text.toString(),
        'isChanged': _dateOfJoiningExpController.text.toString() !=
                (widget.profileDetails[0].employmentDetails['dojOfService'] !=
                        null
                    ? widget.profileDetails[0].employmentDetails['dojOfService']
                        .toString()
                    : '')
            ? true
            : false
      },
      {
        'employeeCode': _employeeCodeController.text.toString(),
        'isChanged': _employeeCodeController.text.toString() !=
                (widget.profileDetails[0].employmentDetails['employeeCode'] !=
                        null
                    ? widget.profileDetails[0].employmentDetails['employeeCode']
                    : '')
            ? true
            : false
      },
      {
        'officialPostalAddress': _officialPostalAddressController.text,
        'isChanged': _officialPostalAddressController.text !=
                (widget.profileDetails[0]
                            .employmentDetails['officialPostalAddress'] !=
                        null
                    ? widget.profileDetails[0]
                        .employmentDetails['officialPostalAddress']
                    : '')
            ? true
            : false
      },
      {
        'payType': _selectedGradePay,
        'isChanged': _selectedGradePay !=
                widget.profileDetails[0].employmentDetails['payType']
            ? true
            : false
      },
      {
        'pinCode': _pinCodeController.text.toString(),
        'isChanged': _pinCodeController.text.toString() !=
                (widget.profileDetails[0].employmentDetails['pinCode'] != null
                    ? widget.profileDetails[0].employmentDetails['pinCode']
                        .toString()
                    : '')
            ? true
            : false
      },
      {
        'service': _selectedService != EnglishLang.selectFromDropdown
            ? _selectedService
            : '',
        'isChanged': _selectedService !=
                widget.profileDetails[0].employmentDetails['service']
            ? true
            : false
      }
    ];
    var edited = {};
    var editedEmploymentDetails =
        employmentDetails.where((data) => data['isChanged'] == true);

    editedEmploymentDetails.forEach((element) {
      edited[element.entries.first.key] = element.entries.first.value;
    });
    // developer.log(edited.isEmpty.toString());
    return edited;
  }

  _getEditedProfessionalDetails() async {
    var professionalDetails = [
      {
        'organisationType': _selectedOrg,
        "isChanged": _selectedOrg !=
                (widget.profileDetails[0].rawDetails['rootOrg']
                            ['organisationType'] ==
                        128
                    ? EnglishLang.government
                    : EnglishLang.nonGovernment)
            ? true
            : false
      },
      {
        'name': _selectedOrganisation,
        'isChanged': _selectedOrganisation !=
                widget.profileDetails[0].rawDetails['rootOrg']['orgName']
            ? true
            : false
      },
      {
        'designation': _selectedDesignation,
        'isChanged': (_selectedDesignation !=
                    (widget.profileDetails[0].experience.toString() ==
                            [].toString()
                        ? ''
                        : widget.profileDetails[0].experience[0]
                            ['designation']) &&
                !_inReview.contains('designation'))
            ? true
            : false
      },
      {
        'industry': _selectedIndustry,
        'isChanged': _selectedIndustry !=
                (widget.profileDetails[0].experience.toString() == [].toString()
                    ? ''
                    : widget.profileDetails[0].experience[0]['industry'])
            ? true
            : false
      },
      {
        'location': _selectedLocation,
        'isChanged': _selectedLocation !=
                (widget.profileDetails[0].experience.toString() == [].toString()
                    ? ''
                    : widget.profileDetails[0].experience[0]['location'])
            ? true
            : false
      },
      {
        'doj': _dateOfJoiningController.text.toString(),
        'isChanged': (_dateOfJoiningController.text.toString() !=
                    (widget.profileDetails[0].experience.toString() ==
                            [].toString()
                        ? ''
                        : widget.profileDetails[0].experience[0]['doj']
                            .toString()) &&
                !_inReview.contains('doj'))
            ? true
            : false
      },
      {
        'description': _descriptionController.text,
        'isChanged': (_descriptionController.text !=
                (widget.profileDetails[0].experience.toString() == [].toString()
                    ? ''
                    : (widget.profileDetails[0].experience[0]['description'] !=
                            null
                        ? widget.profileDetails[0].experience[0]['description']
                        : '')))
            ? true
            : false
      }
    ];
    var edited = {};
    var editedProfessionalDetails =
        professionalDetails.where((data) => data['isChanged'] == true);

    editedProfessionalDetails.forEach((element) {
      edited[element.entries.first.key] = element.entries.first.value;
    });
    // developer.log(edited.toString());
    return edited;
  }

  Future<void> saveProfile() async {
    // List<Map<dynamic, dynamic>> professionalDetails = [
    //   {
    //     'organisationType': _selectedOrg,
    //     'name': _selectedOrganisation != EnglishLang.selectFromDropdown
    //         ? _selectedOrganisation
    //         : '',
    //     'nameOther': '',
    //     'industry': _selectedIndustry != EnglishLang.selectFromDropdown
    //         ? _selectedIndustry
    //         : '',
    //     'industryOther': '',
    //     'designation': _selectedDesignation != EnglishLang.selectFromDropdown
    //         ? _selectedDesignation
    //         : '',
    //     'designationOther': '',
    //     'location': _selectedLocation != EnglishLang.selectFromDropdown
    //         ? _selectedLocation
    //         : '',
    //     'responsibilities': '',
    //     'doj': _dateOfJoiningController.text.toString(),
    //     'description': _descriptionController.text,
    //     'completePostalAddress': _officialPostalAddressController.text,
    //     'additionalAttributes': {},
    //     // 'osid': widget.profileDetails[0].professionalDetails[0]['osid']
    //   }
    // ];

    // Map<dynamic, dynamic> employmentDetails = {
    //   'allotmentYearOfService':
    //       _allotmentYearOfServiceController.text.toString(),
    //   'cadre': _selectedCadre != EnglishLang.selectFromDropdown
    //       ? _selectedCadre
    //       : '',
    //   'civilListNo': _civilListNumberController.text.toString(),
    //   'dojOfService': _dateOfJoiningExpController.text.toString(),
    //   'employeeCode': _employeeCodeController.text.toString(),
    //   'officialPostalAddress': _officialPostalAddressController.text,
    //   'osid': widget.profileDetails[0].employmentDetails['osid'],
    //   'payType': _selectedGradePay != EnglishLang.selectFromDropdown
    //       ? _selectedGradePay
    //       : '',
    //   'pinCode': _pinCodeController.text.toString(),
    //   'service': _selectedService != EnglishLang.selectFromDropdown
    //       ? _selectedService
    //       : '',
    // };
    var editedEmploymentDetails = await _getEditedEmploymentDetails();
    var editedProfessionalDetails = await _getEditedProfessionalDetails();

    if (editedEmploymentDetails.isEmpty) {
      _profileData = {
        // 'photo': widget.profileDetails[0].photo,
        'academics': widget.profileDetails[0].education,
        // 'personalDetails': widget.profileDetails[0].personalDetails,
        'professionalDetails': [editedProfessionalDetails],
        "competencies": widget.profileDetails[0].competencies,
        // "interests": widget.profileDetails[0].interests,
        // "@type": "UserProfile",
        // "userId": widget.profileDetails[0].rawDetails['userId'],
        // "id": widget.profileDetails[0].rawDetails['userId'],
        // "@id": widget.profileDetails[0].rawDetails['userId'],
      };
    } else if (editedProfessionalDetails.isEmpty) {
      _profileData = {
        // 'photo': widget.profileDetails[0].photo,
        'academics': widget.profileDetails[0].education,
        'employmentDetails': editedEmploymentDetails,
        // 'personalDetails': widget.profileDetails[0].personalDetails,
        // 'professionalDetails': editedProfessionalDetails,
        "competencies": widget.profileDetails[0].competencies,
        // "interests": widget.profileDetails[0].interests,
        // "@type": "UserProfile",
        // "userId": widget.profileDetails[0].rawDetails['userId'],
        // "id": widget.profileDetails[0].rawDetails['userId'],
        // "@id": widget.profileDetails[0].rawDetails['userId'],
      };
    } else {
      _profileData = {
        // 'photo': widget.profileDetails[0].photo,
        'academics': widget.profileDetails[0].education,
        'employmentDetails': editedEmploymentDetails,
        'professionalDetails': editedProfessionalDetails,
        "competencies": widget.profileDetails[0].competencies,
        // "interests": widget.profileDetails[0].interests,
        // "@type": "UserProfile",
        // "userId": widget.profileDetails[0].rawDetails['userId'],
        // "id": widget.profileDetails[0].rawDetails['userId'],
        // "@id": widget.profileDetails[0].rawDetails['userId'],
      };
    }

    // developer.log(_profileData.toString());
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
            EnglishLang.professionalDetailsUpdatedText,
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

  Widget _inReviewWidget(String field) {
    return _inReview.contains(field)
        ? Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              'In review',
              style: GoogleFonts.lato(
                color: AppColors.negativeLight,
              ),
            ),
          )
        : Center();
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

  void _setListItem(String listType, String itemName) {
    setState(() {
      switch (listType) {
        case EnglishLang.organisationName:
          _selectedOrganisation = itemName;
          break;
        case EnglishLang.industry:
          _selectedIndustry = itemName;
          break;
        case EnglishLang.designation:
          _selectedDesignation = itemName;
          break;
        case EnglishLang.location:
          _selectedLocation = itemName;
          break;
        case EnglishLang.payBand:
          _selectedGradePay = itemName;
          break;
        case EnglishLang.service:
          _selectedService = itemName;
          break;
        default:
          _selectedCadre = itemName;
      }
    });
  }

  void _filterItems(List items, String value) {
    setState(() {
      _filteredItems =
          items.where((item) => item.toLowerCase().contains(value)).toList();
    });
  }

  Future<bool> _showListOfOptions(contextMain, String listType) {
    List<String> items = [];
    switch (listType) {
      case EnglishLang.organisationName:
        items = _organisationList;
        break;
      case EnglishLang.industry:
        items = _industriesList;
        break;
      case EnglishLang.designation:
        items = _designationList;
        break;
      case EnglishLang.location:
        items = _locationList;
        break;
      case EnglishLang.payBand:
        items = _gradePayList;
        break;
      case EnglishLang.service:
        items = _serviceList;
        break;
      default:
        items = _cadreList;
    }
    _filterItems(items, '');
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
                                                    setState(() {
                                                      _filteredItems = items
                                                          .where((item) => item
                                                              .toLowerCase()
                                                              .contains(value))
                                                          .toList();
                                                    });
                                                    _filterItems(items, value);
                                                  },
                                                  controller: _searchController,
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
                                                      _searchController.text =
                                                          '';
                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.hide');
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
                                              0.685,
                                          child: ListView.builder(
                                              // controller: _controller,
                                              shrinkWrap: true,
                                              itemCount: _filteredItems.length,
                                              itemBuilder: (BuildContext
                                                          context,
                                                      index) =>
                                                  InkWell(
                                                      onTap: () {
                                                        _setListItem(
                                                            listType,
                                                            _filteredItems[
                                                                index]);
                                                        setState(() {
                                                          switch (listType) {
                                                            case EnglishLang
                                                                .organisationName:
                                                              _selectedOrganisation =
                                                                  _filteredItems[
                                                                      index];
                                                              break;
                                                            case EnglishLang
                                                                .industry:
                                                              _selectedIndustry =
                                                                  _filteredItems[
                                                                      index];
                                                              break;
                                                            case EnglishLang
                                                                .designation:
                                                              _selectedDesignation =
                                                                  _filteredItems[
                                                                      index];
                                                              break;
                                                            case EnglishLang
                                                                .location:
                                                              _selectedLocation =
                                                                  _filteredItems[
                                                                      index];
                                                              break;
                                                            case EnglishLang
                                                                .payBand:
                                                              _selectedGradePay =
                                                                  _filteredItems[
                                                                      index];
                                                              break;
                                                            case EnglishLang
                                                                .service:
                                                              _selectedService =
                                                                  _filteredItems[
                                                                      index];
                                                              break;
                                                            default:
                                                              _selectedCadre =
                                                                  _filteredItems[
                                                                      index];
                                                          }
                                                        });
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: _options(
                                                          listType,
                                                          _filteredItems[
                                                              index])))),
                                    ])),
                              ))))
                ],
              );
            }));
  }

  Widget _options(String listType, String itemName) {
    Color _color;
    switch (listType) {
      case EnglishLang.organisationName:
        _color = _selectedOrganisation == itemName
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.industry:
        _color = _selectedIndustry == itemName
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.designation:
        _color = _selectedDesignation == itemName
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.location:
        _color = _selectedLocation == itemName
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.payBand:
        _color = _selectedGradePay == itemName
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.service:
        _color = _selectedService == itemName
            ? AppColors.lightSelected
            : Colors.white;
        break;
      default:
        _color =
            _selectedCadre == itemName ? AppColors.lightSelected : Colors.white;
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
          decoration: BoxDecoration(
            color: _color,

            // ? AppColors.lightSelected
            // : Colors.white,
            // color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          // height: 52,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 7, bottom: 7, left: 12, right: 4),
            child: Text(
              itemName,
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

  @override
  void dispose() {
    _descriptionController.dispose();
    _allotmentYearOfServiceController.dispose();
    _dateOfJoiningController.dispose();
    _dateOfJoiningExpController.dispose();
    _civilListNumberController.dispose();
    _employeeCodeController.dispose();
    _officialPostalAddressController.dispose();
    _pinCodeController.dispose();

    _descriptionFocus.dispose();
    _allotmentYearOfServiceFocus.dispose();
    _dateOfJoiningFocus.dispose();
    _dateOfJoiningExpFocus.dispose();
    _civilListNumberFocus.dispose();
    _employeeCodeFocus.dispose();
    _officialPostalAddressFocus.dispose();
    _pinCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 1500)),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (true) {
                return SingleChildScrollView(
                    child: Column(children: [
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
                  //         borderRadius:
                  //             BorderRadius.all(const Radius.circular(21.0)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  _titleFieldWidget(EnglishLang.typeOfOrganisation),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    // margin: EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _organizationTypesRadio.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(4.0)),
                                    border: Border.all(
                                        color: (_selectedOrg ==
                                                _organizationTypesRadio[index])
                                            ? AppColors.primaryThree
                                            : AppColors.grey16,
                                        width: 1.5),
                                  ),
                                  child: RadioListTile(
                                    dense: true,

                                    // contentPadding: EdgeInsets.only(bottom:20),
                                    groupValue: _selectedOrg,
                                    title: Text(
                                      _organizationTypesRadio[index],
                                      style: GoogleFonts.lato(
                                          color: AppColors.greys87,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    value: _organizationTypesRadio[index],
                                    onChanged: (value) {
                                      if (!_inReview
                                          .contains('organisationType')) {
                                        setState(() {
                                          _selectedOrg = value;
                                        });
                                      }
                                    },
                                    selected: (_selectedOrg ==
                                        _organizationTypesRadio[index]),
                                    selectedTileColor:
                                        AppColors.selectionBackgroundBlue,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        _inReviewWidget('organisationType'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.organisationName),

                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                        InkWell(
                          onTap: () => _inReview.contains('name')
                              ? null
                              : _showListOfOptions(
                                  context, EnglishLang.organisationName),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                  border: Border.all(color: AppColors.grey40),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 10, bottom: 10),
                                  child: Text(
                                    _selectedOrganisation != null &&
                                            _selectedOrganisation != ''
                                        ? _selectedOrganisation
                                        : EnglishLang.selectFromDropdown,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        _inReviewWidget('name'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.industry),

                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                        InkWell(
                          onTap: () => _inReview.contains('industry')
                              ? null
                              : _showListOfOptions(
                                  context, EnglishLang.industry),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                  border: Border.all(color: AppColors.grey40),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 10, bottom: 10),
                                  child: Text(
                                    _selectedIndustry != null &&
                                            _selectedIndustry != ''
                                        ? _selectedIndustry
                                        : EnglishLang.selectFromDropdown,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        _inReviewWidget('industry'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.designation),

                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                        InkWell(
                          onTap: () => _inReview.contains('designation')
                              ? null
                              : _showListOfOptions(
                                  context, EnglishLang.designation),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                  border: Border.all(color: AppColors.grey40),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 10, bottom: 10),
                                  child: Text(
                                    _selectedDesignation != null &&
                                            _selectedDesignation != ''
                                        ? _selectedDesignation
                                        : EnglishLang.selectFromDropdown,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        _inReviewWidget('designation'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.location),
                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                        InkWell(
                          onTap: () => _inReview.contains('location')
                              ? null
                              : _showListOfOptions(
                                  context, EnglishLang.location),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(4.0)),
                                  border: Border.all(color: AppColors.grey40),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 10, bottom: 10),
                                  child: Text(
                                    _selectedLocation != null &&
                                            _selectedLocation != ''
                                        ? _selectedLocation
                                        : EnglishLang.selectFromDropdown,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        _inReviewWidget('location'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.doj),

                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Container(
                            height: 40,
                            // padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: TextFormField(
                                enabled:
                                    _inReview.contains('doj') ? false : true,
                                keyboardType: TextInputType.datetime,
                                textInputAction: TextInputAction.next,
                                focusNode: _dateOfJoiningFocus,
                                readOnly: true,
                                onTap: () async {
                                  DateTime newDate = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDate == null
                                          ? ((_dateOfJoiningController.text !=
                                                      null &&
                                                  _dateOfJoiningController
                                                          .text !=
                                                      '')
                                              ? DateTime.parse(
                                                  _dateOfJoiningController.text
                                                      .toString()
                                                      .split('-')
                                                      .reversed
                                                      .join('-'))
                                              : DateTime.now())
                                          : _selectedDate,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));
                                  if (newDate == null) {
                                    return null;
                                  }
                                  setState(() {
                                    _selectedDate = newDate;
                                    _dateOfJoiningController.text = newDate
                                        .toString()
                                        .split(' ')
                                        .first
                                        .split('-')
                                        .reversed
                                        .join('-');
                                  });
                                },
                                onFieldSubmitted: (term) {
                                  _fieldFocusChange(context,
                                      _dateOfJoiningFocus, _descriptionFocus);
                                },
                                controller: _dateOfJoiningController,
                                style: GoogleFonts.lato(fontSize: 14.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 0.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.grey16)),
                                  hintText: _dateOfJoiningController.text != ''
                                      ? _dateOfJoiningController.text
                                      : EnglishLang.chooseDate,
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
                        ),
                        _inReviewWidget('doj'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _fieldNameWidget(EnglishLang.description),

                            // Icon(Icons.check_circle_outline)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: TextFormField(
                              style: GoogleFonts.lato(fontSize: 14.0),
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.sentences,
                              // focusNode: _yearOfPassing10thFocus,
                              // onFieldSubmitted: (term) {
                              //   _fieldFocusChange(
                              //       context,
                              //       _yearOfPassing10thFocus,
                              //       _schoolName12thFocus);
                              // },
                              controller: _descriptionController,
                              minLines: 6,
                              maxLines: 10,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
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
                                      color: AppColors.primaryThree,
                                      width: 1.0),
                                ),
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 8, right: 16, bottom: 24),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                _descriptionController.text.length.toString() +
                                    '/500 ' +
                                    EnglishLang.chacters,
                                style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _inReviewWidget('responsibilities'),
                        )
                      ],
                    ),
                  ),
                  _titleFieldWidget(EnglishLang.otherDetailsOfGovtEmployees),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 24, bottom: 5),
                  //   alignment: Alignment.topLeft,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 16),
                  //     child: Text(
                  //       EnglishLang.otherDetailsOfGovtEmployees,
                  //       style: GoogleFonts.lato(
                  //         color: AppColors.greys87,
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 16,
                  //         letterSpacing: 0.12,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                      width: double.infinity,
                      color: Colors.white,
                      // margin: EdgeInsets.only(top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(EnglishLang.payBand),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          InkWell(
                            onTap: () => _showListOfOptions(
                                context, EnglishLang.payBand),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(4.0)),
                                    border: Border.all(color: AppColors.grey40),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 10, bottom: 10),
                                    child: Text(
                                      _selectedGradePay != null &&
                                              _selectedGradePay != ''
                                          ? _selectedGradePay
                                          : EnglishLang.selectFromDropdown,
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(EnglishLang.service),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          InkWell(
                            onTap: () => _showListOfOptions(
                                context, EnglishLang.service),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(4.0)),
                                    border: Border.all(color: AppColors.grey40),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 10, bottom: 10),
                                    child: Text(
                                      _selectedService != null &&
                                              _selectedService != ''
                                          ? _selectedService
                                          : EnglishLang.selectFromDropdown,
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(EnglishLang.cadre),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          InkWell(
                            onTap: () =>
                                _showListOfOptions(context, EnglishLang.cadre),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(4.0)),
                                    border: Border.all(color: AppColors.grey40),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 10, bottom: 10),
                                    child: Text(
                                      _selectedCadre != null &&
                                              _selectedCadre != ''
                                          ? _selectedCadre
                                          : EnglishLang.selectFromDropdown,
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(
                                  EnglishLang.allotmentYearOfService),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _allotmentYearOfServiceFocus,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(
                                        context,
                                        _allotmentYearOfServiceFocus,
                                        _dateOfJoiningExpFocus);
                                  },
                                  controller: _allotmentYearOfServiceController,
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(EnglishLang.doj),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _dateOfJoiningExpFocus,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime newDate = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate == null
                                            ? ((_dateOfJoiningExpController
                                                            .text !=
                                                        null &&
                                                    _dateOfJoiningExpController
                                                            .text !=
                                                        '')
                                                ? DateTime.parse(
                                                    _dateOfJoiningExpController
                                                        .text
                                                        .toString()
                                                        .split('-')
                                                        .reversed
                                                        .join('-'))
                                                : DateTime.now())
                                            : _selectedDate,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (newDate == null) {
                                      return null;
                                    }
                                    setState(() {
                                      _selectedDate = newDate;
                                      _dateOfJoiningExpController.text = newDate
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
                                        context,
                                        _dateOfJoiningExpFocus,
                                        _civilListNumberFocus);
                                  },
                                  controller: _dateOfJoiningExpController,
                                  style: GoogleFonts.lato(fontSize: 14.0),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 0.0, 10.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.grey16)),
                                    hintText:
                                        _dateOfJoiningExpController.text != ''
                                            ? _dateOfJoiningExpController.text
                                            : EnglishLang.chooseDate,
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _fieldNameWidget(EnglishLang.civilListNumber),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _civilListNumberFocus,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(
                                        context,
                                        _civilListNumberFocus,
                                        _employeeCodeFocus);
                                  },
                                  controller: _civilListNumberController,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(EnglishLang.employeeCode),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  focusNode: _employeeCodeFocus,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(
                                        context,
                                        _employeeCodeFocus,
                                        _officialPostalAddressFocus);
                                  },
                                  controller: _employeeCodeController,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(
                                  EnglishLang.officialPostalAddress),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                focusNode: _officialPostalAddressFocus,
                                onFieldSubmitted: (term) {
                                  _fieldFocusChange(
                                      context,
                                      _officialPostalAddressFocus,
                                      _pinCodeFocus);
                                },
                                controller: _officialPostalAddressController,
                                style: GoogleFonts.lato(fontSize: 14.0),
                                minLines: 6,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 0.0, 10.0),
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
                                        color: AppColors.primaryThree,
                                        width: 1.0),
                                  ),
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, right: 16, bottom: 0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  _officialPostalAddressController.text.length
                                          .toString() +
                                      '/500 ' +
                                      EnglishLang.chacters,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _fieldNameWidget(EnglishLang.pinCode),

                              // Icon(Icons.check_circle_outline)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _pinCodeFocus,
                                  controller: _pinCodeController,
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
                          ),
                        ],
                      )),
                  Container(
                    height: 100,
                  )
                ]));
              }
              // else {
              //   return PageLoader(
              //     bottom: 200,
              //   );
              // }
            }));
  }
}
