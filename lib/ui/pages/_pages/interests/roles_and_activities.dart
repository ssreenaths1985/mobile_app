import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_rolesAndActivities/activities_info.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_rolesAndActivities/roles_and_activities_card.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_rolesAndActivities/roles_info.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/color_constants.dart';
import '../../../../constants/_constants/storage_constants.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../respositories/_respositories/profile_repository.dart';
import '../../../../services/_services/profile_service.dart';
import '../../../../util/telemetry.dart';
import '../../../../util/telemetry_db_helper.dart';

class RolesAndActivities extends StatefulWidget {
  final getRoleFilledStatus;
  const RolesAndActivities({Key key, this.getRoleFilledStatus})
      : super(key: key);

  @override
  State<RolesAndActivities> createState() => _RolesAndActivitiesState();
}

class _RolesAndActivitiesState extends State<RolesAndActivities> {
  final _storage = FlutterSecureStorage();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final ProfileService profileService = ProfileService();

  List<Profile> _profileDetails;

  List<dynamic> _activities = [];
  List<dynamic> _rolesAndActivities = [];
  String _designation = '';
  bool _isEditing = false;
  int _editIndex;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  // List allEventsData;
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    _generateTelemetryData();
    _getProfileDetails();
    _getDesignation();
    widget.getRoleFilledStatus(true);
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData1 = Telemetry.getImpressionTelemetryEvent(
      deviceIdentifier,
      userId,
      departmentId,
      TelemetryPageIdentifier.rolesPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.rolesPageUri,
    );
    // print('event data: ' + eventData1.toString());
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  Future<List<Profile>> _getProfileDetails() async {
    _profileDetails =
        await Provider.of<ProfileRepository>(context, listen: false)
            .getProfileDetailsById('');
    // print('Profile data: ' + _profileDetails[0].rawDetails.toString());
    await _populateFields();
    return _profileDetails;
  }

  Future<void> _populateFields() async {
    if (_profileDetails != null) {
      setState(() {
        _rolesAndActivities = _profileDetails[0].userRoles;
      });
    }
  }

  _getDesignation() async {
    final designation = await _storage.read(key: Storage.designation);
    setState(() {
      _designation = designation.toString();
    });
  }

  _clearRole() async {
    setState(() {
      _roleController.clear();
      _activityController.clear();
      _activities.clear();
    });
  }

  _addRoleAndActivities(String role, List<dynamic> activities,
      {bool isEditing = false}) async {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    dynamic data = {
      'name': role,
      'id': id,
      'activities': activities.sublist(0)
    };
    if (!isEditing) {
      // _rolesAndActivities.add(data);
      setState(() {
        _rolesAndActivities.add(data);
      });
      _saveProfile(succussMessage: "Added successfully");
    } else {
      setState(() {
        _rolesAndActivities[_editIndex] = data;
        _isEditing = false;
      });
      _saveProfile(succussMessage: 'Updated successfully');
    }
  }

  Widget _addActivities() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () {
          if (_activityController.text != null &&
              (_activityController.text.toString().trim().length > 1) &&
              !_activities.any((element) =>
                  element['name'] ==
                  _activityController.text.toString().trim())) {
            String id = DateTime.now().microsecondsSinceEpoch.toString();
            setState(() {
              _activities
                  .add({'name': _activityController.text.trim(), 'id': id});
              // _activities.toSet().toList();
            });

            _activityController.clear();
          }
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
      ),
    );
  }

  _deleteRoleAndActivities(index) async {
    setState(() {
      _rolesAndActivities.removeAt(index);
    });
    _saveProfile(succussMessage: 'Deleted successfully');
  }

  Future<bool> _confirmDeletion(index) {
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
                      height: 215.0,
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 15),
                                child: Text(
                                  'Do you want to delete this role and associated activities?',
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: GestureDetector(
                                onTap: () {
                                  _deleteRoleAndActivities(index);
                                  // setState(() {
                                  //   _isAlreadyAdded = false;
                                  // });
                                  Navigator.of(context).pop(true);
                                },
                                child: roundedButton(EnglishLang.yesRemove,
                                    Colors.white, AppColors.primaryThree),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 15),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(false),
                                child: roundedButton('No, take me back',
                                    AppColors.primaryThree, Colors.white),
                              ),
                            ),
                          ])),
                ))
              ],
            ));
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width,
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

  _editRoleAndActivities(index) async {
    setState(() {
      _roleController.text = _rolesAndActivities[index]['name'];
      _activities = _rolesAndActivities[index]['activities'];
      _isEditing = true;
      _editIndex = index;
    });
  }

  // _showUpdatedStatusSnackBar({bool isUpdated = false}) async {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     duration: Duration(seconds: 2),
  //     backgroundColor: AppColors.positiveLight,
  //     content: Text(isUpdated ? 'Updated successfully' : 'Added successfully'),
  //   ));
  // }

  Future<void> _saveProfile({String succussMessage}) async {
    Map _profileData;
    _profileData = {'userRoles': _rolesAndActivities};
    var response;
    try {
      response = await profileService.updateProfileDetails(_profileData);
      // print(response.toString());
      if (response['params']['status'] == 'success' ||
          response['params']['status'] == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(succussMessage),
            backgroundColor: AppColors.positiveLight,
          ),
        );
        widget.getRoleFilledStatus(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.errorMessage),
            backgroundColor: AppColors.negativeLight,
          ),
        );
      }
    } catch (err) {
      return err;
    }
  }

  @override
  void dispose() {
    _roleController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            margin: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: AppColors.grey04, spreadRadius: 3),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.info,
                        color: AppColors.greys60,
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Text(
                      "Please list down your roles & activities as part of your position " +
                          ((_designation != null &&
                                  (_designation != '' &&
                                      _designation != 'null'))
                              ? _designation
                              : ''),
                      style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.25,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Add a role',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.info_outline,
                          color: AppColors.grey40,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context, builder: (ctx) => RolesInfo());
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text("What is a role?",
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              letterSpacing: 0.12,
                              fontSize: 16)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Focus(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  // focusNode: _firstNameFocus,
                  // onFieldSubmitted: (term) {
                  //   _fieldFocusChange(
                  //       context, _firstNameFocus, _middleNameFocus);
                  // },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if ((value.isEmpty || value.trim().length == 0) &&
                        _rolesAndActivities.length == 0) {
                      return "Role is mandatory";
                    } else if ((_rolesAndActivities
                            .any((element) => element['name'] == value) &&
                        !_isEditing)) {
                      return 'Role already exist';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _roleController,
                  style: GoogleFonts.lato(fontSize: 14.0),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    // labelText: "Add a role",
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey16)),
                    hintText: 'Type the role name',
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
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Add activities',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.info_outline,
                          color: AppColors.grey40,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => ActivitiesInfo());
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text("What is activity?",
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              letterSpacing: 0.12,
                              fontSize: 16)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // height: 40.0,
                  child: Focus(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.go,
                      // textCapitalization: TextCapitalization.sentences,
                      validator: (String activity) {
                        if (_activities.any((element) =>
                            element['name'] == activity.toString().trim())) {
                          return 'Activity already exist';
                        } else if (activity.toString().trim().length == 1) {
                          return 'Please add a valid activity name';
                        } else if (((activity.isEmpty ||
                                    activity.toString().trim().length == 0) &&
                                _activities.length == 0) &&
                            (_isEditing
                                ? true
                                : _rolesAndActivities.length == 0)) {
                          return 'Activity is mandatory';
                        }
                        return null;
                      },
                      controller: _activityController,
                      style: GoogleFonts.lato(fontSize: 14.0),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey16)),
                        hintText: 'Type the activity and press Add',
                        helperText: 'Start adding activities',
                        isDense: false,
                        isCollapsed: false,
                        suffix: _addActivities(),
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
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    children: [
                      for (var i in _activities)
                        Container(
                          margin: const EdgeInsets.only(right: 12.0),
                          child: InputChip(
                            padding: EdgeInsets.all(8.0),
                            backgroundColor: AppColors.primaryThree,
                            label: Text(
                              i['name'],
                              style: GoogleFonts.lato(
                                color: Colors.white,
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
                                      size: 25.0, color: Colors.white),
                                ),
                              ],
                            ),
                            onDeleted: () {
                              setState(() {
                                _activities.removeAt(_activities.indexOf(i));
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
          !_isEditing
              ? Container(
                  margin: EdgeInsets.only(top: 16),
                  width: 75,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: ((_roleController.text.trim().length > 0 &&
                                  _activities.length > 0) &&
                              !(_rolesAndActivities.any((element) =>
                                  element['name'] ==
                                  _roleController.text.trim())))
                          ? InkSplash.splashFactory
                          : NoSplash.splashFactory,
                      enableFeedback:
                          (((_roleController.text.trim().length > 0 &&
                                      _activities.length > 0) &&
                                  !(_rolesAndActivities.any((element) =>
                                      element['name'] ==
                                      _roleController.text.trim()))))
                              ? true
                              : false,
                      shadowColor: AppColors.grey04,
                      primary: Colors.transparent,
                      minimumSize: const Size.fromHeight(36), // NEW
                      side: BorderSide(
                        width: 1,
                        color: (((_roleController.text.trim().length > 0 &&
                                    _activities.length > 0) &&
                                !(_rolesAndActivities.any((element) =>
                                    element['name'] ==
                                    _roleController.text.trim()))))
                            ? AppColors.primaryThree
                            : AppColors.grey40,
                      ),
                    ),
                    onPressed: ((_roleController.text.trim().length > 0 &&
                                _activities.length > 0) &&
                            !(_rolesAndActivities.any((element) =>
                                element['name'] ==
                                _roleController.text.trim())))
                        ? () async {
                            if (_roleController.text.trim().length != 0 &&
                                _activities.length > 0) {
                              _addRoleAndActivities(
                                  _roleController.text, _activities);
                              _clearRole();
                            } else if (_roleController.text.trim().length ==
                                0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please add a role'),
                                  backgroundColor: AppColors.negativeLight,
                                ),
                              );
                            }

                            // await _showUpdatedStatusSnackBar();
                            // await _saveProfile();
                          }
                        : () {},
                    child: Text(
                      'Add',
                      style: TextStyle(
                          fontSize: 14,
                          color: ((_roleController.text.trim().length > 0 &&
                                      _activities.length > 0) &&
                                  !(_rolesAndActivities.any((element) =>
                                      element['name'] ==
                                      _roleController.text.trim())))
                              ? AppColors.primaryThree
                              : AppColors.grey40,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 16),
                  width: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: (_roleController.text.trim().length > 0 &&
                              _activities.length > 0)
                          ? InkSplash.splashFactory
                          : NoSplash.splashFactory,
                      enableFeedback: (_roleController.text.trim().length > 0 &&
                              _activities.length > 0)
                          ? true
                          : false,
                      shadowColor: AppColors.grey04,
                      primary: Colors.transparent,
                      minimumSize: const Size.fromHeight(36), // NEW
                      side: BorderSide(
                        width: 1,
                        color: (_roleController.text.trim().length > 0 &&
                                _activities.length > 0)
                            ? AppColors.primaryThree
                            : AppColors.grey40,
                      ),
                    ),
                    onPressed: (_roleController.text.trim().length > 0 &&
                            _activities.length > 0)
                        ? () {
                            if (_roleController.text.trim().length != 0 &&
                                _activities.length > 0) {
                              _addRoleAndActivities(
                                  _roleController.text, _activities,
                                  isEditing: true);
                              _clearRole();
                            } else if (_roleController.text.trim().length ==
                                0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please add a role'),
                                  backgroundColor: AppColors.negativeLight,
                                ),
                              );
                            }

                            // await _saveProfile();
                            // await _showUpdatedStatusSnackBar(
                            //     isUpdated: true);
                          }
                        : () {},
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 14,
                          color: (_roleController.text.trim().length > 0 &&
                                  _activities.length > 0)
                              ? AppColors.primaryThree
                              : AppColors.grey40,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
          SizedBox(
            height: 12,
          ),
          Container(
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _rolesAndActivities.length,
              itemBuilder: (context, index) {
                return RolesAndActivitiesCard(
                  roleAndActivities: _rolesAndActivities[index],
                  index: index,
                  editAction: _editRoleAndActivities,
                  deleteAction: _confirmDeletion,
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Your selections are automatically saved.',
              style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 12,
                  letterSpacing: 0.25,
                  height: 1.33,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 120,
          ),
        ],
      ),
    ));
  }
}
