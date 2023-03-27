import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_topics/add_new_topic.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_topics/added_topics.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_topics/topic_details_card.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:provider/provider.dart';

import '../../../../constants/_constants/color_constants.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import '../../../../localization/_langs/english_lang.dart';
import '../../../../models/_models/course_topics_model.dart';
import '../../../../models/_models/profile_model.dart';
import '../../../../models/_models/telemetry_event_model.dart';
import '../../../../respositories/_respositories/learn_repository.dart';

// import 'dart:developer' as developer;

import '../../../../respositories/_respositories/profile_repository.dart';
import '../../../../services/_services/profile_service.dart';
import '../../../../util/telemetry.dart';
import '../../../../util/telemetry_db_helper.dart';

class Topics extends StatefulWidget {
  final getTopicSelectedStatus;
  const Topics({Key key, this.getTopicSelectedStatus}) : super(key: key);

  @override
  State<Topics> createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  final ProfileService profileService = ProfileService();
  bool _pageInitilized = false;
  List<Profile> _profileDetails;
  List<CourseTopics> _courseTopics = [];
  List<CourseTopics> _filteredCourseTopics = [];
  final _textController = TextEditingController();
  List<dynamic> _selectedTopics = [];
  List<dynamic> _desiredTopics = [];

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
    widget.getTopicSelectedStatus(true);
    _textController.addListener(_filterTopics);
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
      TelemetryPageIdentifier.topicsPageId,
      userSessionId,
      messageIdentifier,
      TelemetryType.page,
      TelemetryPageIdentifier.topicsPageUri,
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
        _selectedTopics = _profileDetails[0].selectedTopics;
        _desiredTopics = _profileDetails[0].desiredTopics;
      });
    }
  }

  Future<List<CourseTopics>> _getCourseTopics() async {
    if (!_pageInitilized) {
      _courseTopics = await Provider.of<LearnRepository>(context, listen: false)
          .getCourseTopics();
      setState(() {
        _filteredCourseTopics = _courseTopics;
        _pageInitilized = true;
      });
    }
    return _courseTopics;
  }

  _filterTopics() {
    // print('_filterTopics...');
    String value = _textController.text;
    setState(() {
      _filteredCourseTopics = _courseTopics
          .where((topic) =>
              topic.name.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
      // });
    });
  }

  _addToDesiredTopic(String value) async {
    setState(() {
      _desiredTopics.add(value);
      _desiredTopics = _desiredTopics.toSet().toList();
    });
    _saveProfile(isDesiredTopics: true);
  }

  _removeFromDesiredTopic(String value) async {
    setState(() {
      _desiredTopics.remove(value);
    });
    _saveProfile(isDesiredTopics: true);
  }

  Future<void> _saveProfile(
      {String succussMessage = 'Updated successfully',
      bool isDesiredTopics = false}) async {
    Map _profileData;
    if (isDesiredTopics) {
      _profileData = {'desiredTopics': _desiredTopics};
    } else {
      _profileData = {'systemTopics': _selectedTopics};
    }
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
        widget.getTopicSelectedStatus(true);
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: _getCourseTopics(),
            builder: (context, AsyncSnapshot<List<CourseTopics>> snapshot) {
              return (snapshot.data != null && snapshot.data.length > 0)
                  ? Container(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  'Not finding a topic of your interest?',
                                  style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      letterSpacing: 0.25,
                                      height: 1.429,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // splashFactory: InkSplash.splashFactory,
                                  // enableFeedback: true,
                                  shadowColor: AppColors.grey04,
                                  primary: Colors.transparent,
                                  // minimumSize: const Size.fromHeight(36), // NEW
                                  side: BorderSide(
                                    width: 1,
                                    color: AppColors.primaryThree,
                                  ),
                                ),
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (ctx) => AddNewTopic(
                                          addToDesiredTopics:
                                              _addToDesiredTopic,
                                          desiredTopics: _desiredTopics,
                                        )),
                                child: Text(
                                  'Add topic',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryThree,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            // color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            // width: 316,
                            height: 48,
                            child: TextFormField(
                                controller: _textController,
                                onChanged: (value) {},
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                style: GoogleFonts.lato(fontSize: 14.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: Icon(Icons.search),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      16.0, 10.0, 0.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: BorderSide(
                                      color: AppColors.grey16,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(1.0),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryThree,
                                    ),
                                  ),
                                  hintText: EnglishLang.search,
                                  hintStyle: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: '',
                                )),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          _desiredTopics.length > 0
                              ? AddedTopics(
                                  addedTopics: _desiredTopics,
                                  removeFromAddedTopic: _removeFromDesiredTopic,
                                )
                              : Center(),
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredCourseTopics.length,
                            itemBuilder: (context, index) {
                              return TopicDetailsCard(
                                topic: _filteredCourseTopics[index],
                                selectedTopics: _selectedTopics,
                                getTopicSelectedStatus:
                                    widget.getTopicSelectedStatus,
                                saveProfile: _saveProfile,
                              );
                            },
                          ),
                          SizedBox(
                            height: 120,
                          )
                        ],
                      ),
                    )
                  : PageLoader(
                      bottom: 200,
                    );
            }),
      ),
    );
  }
}
