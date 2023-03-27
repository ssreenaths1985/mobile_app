import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/models/_models/register_organisation_model.dart';
import 'package:karmayogi_mobile/models/_models/registration_position_model.dart';
import 'package:karmayogi_mobile/respositories/_respositories/login_respository.dart';
import 'package:karmayogi_mobile/services/_services/registration_service.dart';
import 'package:karmayogi_mobile/ui/widgets/_signup/field_info.dart';
import 'package:karmayogi_mobile/ui/widgets/custom_tabs.dart';
import 'package:karmayogi_mobile/util/terms_of_service.dart';
import 'package:provider/provider.dart';

import 'constants/_constants/color_constants.dart';
import 'constants/_constants/storage_constants.dart';
import 'localization/_langs/english_lang.dart';

// import 'dart:developer' as developer;

import 'models/_models/login_user_details.dart';
import 'oAuth2_login.dart';

class SignUpPage extends StatefulWidget {
  final bool isParichayUser;
  final LoginUser parichayLoginInfo;
  const SignUpPage(
      {Key key, this.isParichayUser = false, this.parichayLoginInfo})
      : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _ministryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _organisationController = TextEditingController();

  final RegistrationService registrationService = RegistrationService();

  TextEditingController _searchController = TextEditingController();

  List _categoryTypesRadio = [EnglishLang.center, EnglishLang.state];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _firstName;
  String _surName;
  // String _selectedPositionId;
  String _email;
  String _category;
  String _selectedMinistryId;
  String _selectedStateId;
  String _selectedDepartmentId;

  bool _isConfirmed = false;
  bool _isAcceptedTC = false;

  List<RegistrationPosition> _positionList = [];
  List<OrganisationModel> _ministryList = [];
  List<OrganisationModel> _stateList = [];
  List<OrganisationModel> _departmentList = [];
  List<OrganisationModel> _organisationList = [];
  List<dynamic> _filteredItems = [];
  OrganisationModel _selectedOrg;

  @override
  void initState() {
    super.initState();
    setState(() {
      _category = EnglishLang.center;
      if (widget.isParichayUser) {
        _firstNameController.text = widget.parichayLoginInfo.firstName;
        _surNameController.text = widget.parichayLoginInfo.lastName;
        _emailController.text = widget.parichayLoginInfo.email;
      }
    });
  }

  _getPositions() async {
    final response = await registrationService.getPositions();
    setState(() {
      _positionList = response;
    });
  }

  _getMinistries() async {
    final response = await registrationService.getMinistries();
    setState(() {
      _ministryList = response;
      _ministryList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  _getStates() async {
    final response = await registrationService.getStates();
    setState(() {
      _stateList = response;
      _stateList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  _getDepartments(String id) async {
    final response = await registrationService.getMinistries(parentId: id);
    setState(() {
      _departmentList = response;
      _departmentList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  _getOrganisations(String id) async {
    final response = await registrationService.getMinistries(parentId: id);
    setState(() {
      _organisationList = response;
      _organisationList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  Future<void> _navigateToHomePage() async {
    final _storage = FlutterSecureStorage();
    String accessToken = await _storage.read(key: Storage.authToken);

    try {
      await Provider.of<LoginRespository>(context, listen: false)
          .getBasicUserInfo(accessToken, isParichayUser: true);

      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CustomTabs(
            customIndex: 0,
            token: accessToken,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _registerAccount() async {
    Response response;
    String email = widget.isParichayUser ? _emailController.text : _email;
    try {
      response = await registrationService.registerAccount(
          _firstName, email, _surName, _positionController.text, _selectedOrg,
          isParichayUser: widget.isParichayUser ? true : false);
      if (widget.isParichayUser &&
          (jsonDecode(response.body)['params']['errmsg'] == null ||
              jsonDecode(response.body)['params']['errmsg'] == '')) {
        await _navigateToHomePage();
      } else if (response.statusCode == 202) {
        await _showPopupForSuccessfulRegister();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonDecode(response.body)['params']['errmsg']),
            backgroundColor: AppColors.negativeLight,
          ),
        );
      }
    } catch (err) {
      return err;
    }
    // print('Response: ' + response);
  }

  Future<void> _showPopupForSuccessfulRegister() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(EnglishLang.thanksForRegistering,
            style: GoogleFonts.lato(
                color: AppColors.greys87,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.12,
                height: 1.5)),
        content: Text(
          EnglishLang.postRegisterInfo,
          style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.25,
              height: 1.5),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        actions: <Widget>[
          Container(
            width: 87,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryThree,
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => OAuth2Login(),
                ));
              },
              child: Text(
                EnglishLang.ok,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _filterItems(List items, String value) {
    setState(() {
      _filteredItems = items
          .where((item) => item.name.toLowerCase().contains(value))
          .toList();
    });
  }

  void _setListItem(String listType, dynamic item) {
    setState(() {
      switch (listType) {
        case EnglishLang.position:
          _positionController.text = item.name;
          break;
        case EnglishLang.ministry:
          _ministryController.text = item.name;
          _departmentController.clear();
          _organisationController.clear();
          setState(() {
            _selectedMinistryId = item.id;
            _selectedOrg = item;
          });
          break;
        case EnglishLang.state:
          _stateController.text = item.name;
          _departmentController.clear();
          _organisationController.clear();
          setState(() {
            _selectedStateId = item.id;
            _selectedOrg = item;
          });
          break;
        case EnglishLang.department:
          _departmentController.text = item.name;
          _organisationController.clear();
          setState(() {
            _selectedDepartmentId = item.id;
            _selectedOrg = item;
          });
          break;
        case EnglishLang.organisation:
          _organisationController.text = item.name;
          setState(() {
            _selectedOrg = item;
          });
          break;
      }
    });
  }

  Widget _options(String listType, dynamic item) {
    Color _color;
    switch (listType) {
      case EnglishLang.position:
        _color = _positionController.text == item.name
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.ministry:
        _color = _ministryController.text == item.name
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.state:
        _color = _stateController.text == item.name
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.department:
        _color = _departmentController.text == item.name
            ? AppColors.lightSelected
            : Colors.white;
        break;
      case EnglishLang.organisation:
        _color = _organisationController.text == item.name
            ? AppColors.lightSelected
            : Colors.white;
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          // height: 52,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 7, bottom: 7, left: 12, right: 4),
            child: Text(
              item.name,
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

  Future<bool> _showListOfOptions(contextMain, String listType) async {
    List<dynamic> items = [];
    switch (listType) {
      case EnglishLang.position:
        await _getPositions();
        items = _positionList;
        break;
      case EnglishLang.ministry:
        await _getMinistries();
        items = _ministryList;
        break;
      case EnglishLang.state:
        await _getStates();
        items = _stateList;
        break;
      case EnglishLang.department:
        await _getDepartments(_category == EnglishLang.center
            ? _selectedMinistryId
            : _selectedStateId);
        items = _departmentList;
        break;
      case EnglishLang.organisation:
        await _getOrganisations(_selectedDepartmentId);
        items = _organisationList;
        break;
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
                                child: Material(
                                    child: Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          height: 48,
                                          child: TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _filteredItems = items
                                                      .where((item) => item.name
                                                          .toLowerCase()
                                                          .contains(value))
                                                      .toList();
                                                });
                                                _filterItems(items, value);
                                              },
                                              controller: _searchController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.done,
                                              style: GoogleFonts.lato(
                                                  fontSize: 14.0),
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.search),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        16.0, 14.0, 0.0, 10.0),
                                                hintText: 'Search',
                                                hintStyle: GoogleFonts.lato(
                                                    color: AppColors.greys60,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: AppColors
                                                          .primaryThree,
                                                      width: 1.0),
                                                ),
                                                counterStyle: TextStyle(
                                                  height: double.minPositive,
                                                ),
                                                counterText: '',
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
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
                                                  _searchController.text = '';
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
                                      padding: const EdgeInsets.only(top: 10),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.685,
                                      child: ListView.builder(
                                          // controller: _controller,
                                          shrinkWrap: true,
                                          itemCount: _filteredItems.length,
                                          itemBuilder: (BuildContext context,
                                                  index) =>
                                              InkWell(
                                                  onTap: () {
                                                    _setListItem(listType,
                                                        _filteredItems[index]);
                                                    setState(() {
                                                      switch (listType) {
                                                        case EnglishLang
                                                            .position:
                                                          _positionController
                                                                  .text =
                                                              _filteredItems[
                                                                      index]
                                                                  .name;
                                                          break;
                                                        case EnglishLang
                                                            .ministry:
                                                          _ministryController
                                                                  .text =
                                                              _filteredItems[
                                                                      index]
                                                                  .name;
                                                          break;
                                                        case EnglishLang.state:
                                                          _stateController
                                                                  .text =
                                                              _filteredItems[
                                                                      index]
                                                                  .name;
                                                          break;
                                                        case EnglishLang
                                                            .department:
                                                          _departmentController
                                                                  .text =
                                                              _filteredItems[
                                                                      index]
                                                                  .name;
                                                          break;
                                                        case EnglishLang
                                                            .organisation:
                                                          _organisationController
                                                                  .text =
                                                              _filteredItems[
                                                                      index]
                                                                  .name;
                                                          break;
                                                      }
                                                    });
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: _options(listType,
                                                      _filteredItems[index])))),
                                ])),
                              ))))
                ],
              );
            }));
  }

  Widget _buildFirstNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: EnglishLang.firstName,
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: 0.12,
                  fontSize: 16),
              children: [
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ]),
        ),
        Container(
          padding: EdgeInsets.only(top: 6),
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
              controller: _firstNameController,
              onSaved: (String value) {
                _firstName = value;
              },
              onFieldSubmitted: (value) {
                if (value.isEmpty && !_formKey.currentState.validate()) {
                  return;
                }
              },
              style: GoogleFonts.lato(fontSize: 14.0),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.grey16)),
                hintText: EnglishLang.enterYourFirstName,
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
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildSurNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: EnglishLang.surName,
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: 0.12,
                  fontSize: 16),
              children: [
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ]),
        ),
        Container(
          padding: EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              if (value.isEmpty && !_formKey.currentState.validate()) {
                return;
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String value) {
              if (value.isEmpty) {
                return EnglishLang.firstNameMandatory
                    .replaceAll(EnglishLang.firstName, EnglishLang.surName);
              } else
                return null;
            },
            onSaved: (String value) {
              _surName = value;
            },
            controller: _surNameController,
            style: GoogleFonts.lato(fontSize: 14.0),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey16)),
              // hintText: 'Enter your last name',
              hintText: EnglishLang.enterYourFirstName.replaceAll(
                  EnglishLang.firstName.toLowerCase(),
                  EnglishLang.surName.toLowerCase()),
              hintStyle: GoogleFonts.lato(
                  color: AppColors.grey40,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.primaryThree, width: 1.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildPositionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: EnglishLang.position,
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: 0.12,
                  fontSize: 16),
              children: [
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ]),
        ),
        Container(
          padding: EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormField(
            readOnly: true,
            onTap: () async {
              await _showListOfOptions(context, EnglishLang.position);
            },
            textInputAction: TextInputAction.next,
            controller: _positionController,
            onFieldSubmitted: (value) {
              if (value.isEmpty && !_formKey.currentState.validate()) {
                return;
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String value) {
              if (value.isEmpty) {
                return EnglishLang.positionValidationText;
              } else
                return null;
            },
            // onSaved: (String value) {
            //   _position = value;
            // },
            // controller: _firstNameController,
            style: GoogleFonts.lato(fontSize: 14.0),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              // label: Text('data'),
              // labelText: "Add a role",
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey16)),
              hintText: EnglishLang.selectYourPosition,
              hintStyle: GoogleFonts.lato(
                  color: AppColors.grey40,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.primaryThree, width: 1.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: EnglishLang.email,
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: 0.12,
                  fontSize: 16),
              children: [
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ]),
        ),
        Container(
          padding: EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String value) {
              if (value.isEmpty) {
                return EnglishLang.firstNameMandatory
                    .replaceAll(EnglishLang.firstName, EnglishLang.emailId);
              } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return EnglishLang.emailValidationText;
              } else
                return null;
            },
            onSaved: (String value) {
              _email = value;
            },
            onFieldSubmitted: (value) {
              if (value.isEmpty && !_formKey.currentState.validate()) {
                return;
              }
            },
            readOnly: widget.isParichayUser ? true : false,
            controller: _emailController,
            style: GoogleFonts.lato(fontSize: 14.0),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              helperText: 'Only government email ids are allowed',
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey16)),
              // hintText: 'Enter your email id',
              hintText: EnglishLang.enterYourFirstName.replaceAll(
                  EnglishLang.firstName.toLowerCase(),
                  EnglishLang.emailId.toLowerCase()),
              hintStyle: GoogleFonts.lato(
                  color: AppColors.grey40,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.primaryThree, width: 1.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildCategoryChoose() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: EnglishLang.centerOrState,
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  letterSpacing: 0.12,
                  fontSize: 16),
              children: [
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // spacing: 16,
          children: [
            for (var index = 0; index < _categoryTypesRadio.length; index++)
              (Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(const Radius.circular(4.0)),
                    border: Border.all(
                        color: (_category == _categoryTypesRadio[index])
                            ? AppColors.primaryThree
                            : AppColors.grey16,
                        width: 1.5),
                  ),
                  child: RadioListTile(
                    dense: true,
                    groupValue: _category,
                    title: Text(
                      _categoryTypesRadio[index],
                      style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                    value: _categoryTypesRadio[index],
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                      // if (!_formKey.currentState.validate()) {
                      //   return;
                      // }
                      _ministryController.clear();
                      _stateController.clear();
                      _departmentController.clear();
                      _organisationController.clear();
                    },
                    selected: (_category == _categoryTypesRadio[index]),
                    selectedTileColor: AppColors.selectionBackgroundBlue,
                  ),
                ),
              ))
          ],
        )
      ],
    );
  }

  Widget _buildMinistryField() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                text: EnglishLang.ministry,
                style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    letterSpacing: 0.12,
                    fontSize: 16),
                children: [
                  TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16))
                ]),
          ),
          Container(
            padding: EdgeInsets.only(top: 6),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              readOnly: true,
              onTap: () async {
                await _showListOfOptions(context, EnglishLang.ministry);
              },
              textInputAction: TextInputAction.next,
              controller: _ministryController,
              onFieldSubmitted: (value) {
                if (value.isEmpty && !_formKey.currentState.validate()) {
                  return;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value.isEmpty) {
                  return '${_category == EnglishLang.center ? EnglishLang.ministry : EnglishLang.state} is mandatory';
                } else {
                  return null;
                }
              },
              style: GoogleFonts.lato(fontSize: 14.0),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.grey16)),
                // hintText: 'Select your ministry',
                hintText: EnglishLang.selectYourPosition.replaceAll(
                    EnglishLang.position.toLowerCase(),
                    EnglishLang.ministry.toLowerCase()),
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
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget _buildStateField() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                text: EnglishLang.state,
                style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    letterSpacing: 0.12,
                    fontSize: 16),
                children: [
                  TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16))
                ]),
          ),
          Container(
            padding: EdgeInsets.only(top: 6),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              readOnly: true,
              onTap: () async {
                await _showListOfOptions(context, EnglishLang.state);
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                if (value.isEmpty && !_formKey.currentState.validate()) {
                  return;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value.isEmpty) {
                  // return '$_category is mandatory';
                  return EnglishLang.firstNameMandatory
                      .replaceAll(EnglishLang.firstName, '$_category');
                } else {
                  return null;
                }
              },
              controller: _stateController,
              style: GoogleFonts.lato(fontSize: 14.0),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.grey16)),
                // hintText: 'Select your state',
                hintText: EnglishLang.selectYourPosition.replaceAll(
                    EnglishLang.position.toLowerCase(),
                    EnglishLang.state.toLowerCase()),
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
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget _buildDepartmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(EnglishLang.department,
                style: GoogleFonts.lato(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    letterSpacing: 0.12,
                    fontSize: 16)),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.grey40,
                ),
              ),
              onTap: () {
                showDialog(context: context, builder: (ctx) => FieldInfo());
              },
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormField(
            readOnly: true,
            onTap: () async {
              if ((_selectedMinistryId != null && _selectedMinistryId != '') ||
                  (_selectedStateId != null && _selectedStateId != '')) {
                await _showListOfOptions(context, EnglishLang.department);
              }
            },
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _departmentController,
            style: GoogleFonts.lato(fontSize: 14.0),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey16)),
              // hintText: 'Select your department',
              hintText: EnglishLang.selectYourPosition.replaceAll(
                  EnglishLang.position.toLowerCase(),
                  EnglishLang.department.toLowerCase()),
              hintStyle: GoogleFonts.lato(
                  color: AppColors.grey40,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.primaryThree, width: 1.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildOrganisationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                  text: EnglishLang.organisation,
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      letterSpacing: 0.12,
                      fontSize: 16),
                  children: [
                    _departmentController.text == 'NA'
                        ? TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                        : TextSpan(
                            text: '',
                          )
                  ]),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.grey40,
                ),
              ),
              onTap: () {
                showDialog(context: context, builder: (ctx) => FieldInfo());
              },
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormField(
            readOnly: true,
            onTap: () async {
              if (_selectedDepartmentId != null &&
                  _selectedDepartmentId != '') {
                await _showListOfOptions(context, EnglishLang.organisation);
              }
            },
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (_departmentController.text == 'NA' && value.isEmpty) {
                return EnglishLang.orgValidationText;
              } else {
                return null;
              }
            },
            controller: _organisationController,
            style: GoogleFonts.lato(fontSize: 14.0),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey16)),
              // hintText: 'Select your organisation',
              hintText: EnglishLang.selectYourPosition.replaceAll(
                  EnglishLang.position.toLowerCase(),
                  EnglishLang.organisation.toLowerCase()),
              hintStyle: GoogleFonts.lato(
                  color: AppColors.grey40,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.primaryThree, width: 1.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _surNameController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _ministryController.dispose();
    _organisationController.dispose();
    _stateController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(widget.isParichayUser
              ? EnglishLang.welcomeToiGOT
              : EnglishLang.back),
          titleSpacing: 0,
          centerTitle: widget.isParichayUser ? true : false,
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  EnglishLang.pleaseFillAll,
                  style: GoogleFonts.lato(
                      color: AppColors.greys60,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildFirstNameField(),
                      _buildSurNameField(),
                      _buildEmailField(),
                      _buildPositionField(),
                      _buildCategoryChoose(),
                      _category == EnglishLang.center
                          ? _buildMinistryField()
                          : _buildStateField(),
                      _buildDepartmentField(),
                      _buildOrganisationField(),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: _isConfirmed,
                              onChanged: (value) {
                                setState(() {
                                  _isConfirmed = value;
                                });

                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                              },
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(EnglishLang.signUpConfirmationText,
                                  overflow: TextOverflow.fade,
                                  style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontWeight: FontWeight.w400,
                                      height: 1.429,
                                      letterSpacing: 0.25,
                                      fontSize: 14)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: _isAcceptedTC,
                              onChanged: (value) {
                                setState(() {
                                  _isAcceptedTC = value;
                                });

                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                              },
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        style: GoogleFonts.lato(
                                            color: AppColors.greys60,
                                            fontWeight: FontWeight.w400,
                                            height: 1.429,
                                            letterSpacing: 0.25,
                                            fontSize: 14),
                                        text:
                                            "I agree to the iGOT Karmayogi's ",
                                      ),
                                      TextSpan(
                                        style: GoogleFonts.lato(
                                            color: AppColors.primaryThree,
                                            fontWeight: FontWeight.w600,
                                            height: 1.429,
                                            letterSpacing: 0.25,
                                            fontSize: 14),
                                        text: 'Terms of Service',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap =
                                              (() => Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TermsOfService(),
                                                    ),
                                                  )),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            // height: _activeTabIndex == 0 ? 60 : 0,
            height: 50,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryThree,
                    minimumSize: const Size.fromHeight(36), // NEW
                  ),
                  onPressed: ((_isConfirmed &&
                              (_formKey.currentState != null &&
                                  _formKey.currentState.validate())) &&
                          _isAcceptedTC)
                      ? () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          // developer.log(
                          //     "firsName: $_firstName, surname: $_surName, Email: $_email, Position: ${_positionController.text}, OrgName: ${_selectedOrg.name}, OrgType: ${_selectedOrg.orgType}, SubOrgType: ${_selectedOrg.subOrgType}, SubOrgId: ${_selectedOrg.subOrgId}, SubRootOrgId: ${_selectedOrg.subRootOrgId}, MapId: ${_selectedOrg.id} ");
                          _registerAccount();
                        }
                      : null,
                  child: Text(
                    widget.isParichayUser
                        ? EnglishLang.saveAndNext
                        : EnglishLang.signUp.toUpperCase(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
