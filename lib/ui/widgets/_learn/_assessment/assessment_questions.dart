import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import '../../../../constants/_constants/telemetry_constants.dart';
import './../../../../feedback/constants.dart';
import './../../../../constants/index.dart';
import './../../../../services/index.dart';
import './../../../../util/telemetry.dart';
import './../../../../util/telemetry_db_helper.dart';
// import 'dart:developer' as developer;
// import 'dart:convert';

class AssessmentQuestions extends StatefulWidget {
  // static const route = FeedbackPageRoute.microSurveyPage;
  final course;
  final String title;
  final String identifier;
  final microSurvey;
  final ValueChanged<double> parentAction;
  final String batchId;
  final duration;
  AssessmentQuestions(this.course, this.title, this.identifier,
      this.microSurvey, this.parentAction, this.batchId, this.duration);

  @override
  _AssessmentQuestionsState createState() => _AssessmentQuestionsState();
}

class _AssessmentQuestionsState extends State<AssessmentQuestions> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LearnService learnService = LearnService();
  final TelemetryService telemetryService = TelemetryService();

  List _microSurvey = [];
  List _questionAnswers = [];
  int _questionIndex = 0;
  bool _nextQuestion = false;
  bool _showAnswer = false;
  int _wrongAnswers = 0;
  List _options = [];
  int _questionShuffled;

  Timer _timer;
  int _start;
  String _timeFormat;
  Map _apiResponse;
  bool _assessmentCompleted = false;
  int timeLimit;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  String pageIdentifier;
  String telemetryType;
  String pageUri;
  List allEventsData = [];
  String deviceIdentifier;
  var telemetryEventData;

  @override
  void initState() {
    super.initState();
    timeLimit = Helper.getMilliSecondsFromTimeFormat(
        widget.duration.toString().split('-').last.trim());
    // _start = widget.microSurvey['timeLimit'];
    _start = timeLimit;
    _microSurvey = widget.microSurvey['questions'];
    if (_start == timeLimit) {
      telemetryType = TelemetryType.player;
      pageIdentifier = TelemetryPageIdentifier.assessmentPlayerPageId;
      pageUri =
          "viewer/quiz/${widget.identifier}?primaryCategory=Learning%20Resource&collectionId=${widget.course['identifier']}&collectionType=Course&batchId=${widget.course['batches'] != null ? (widget.course['batches'].runtimeType == String ? jsonDecode(widget.course['batches']).last['batchId'] : widget.course['batches'].last['batchId']) : ''}";
      _generateTelemetryData();
    }
    startTimer();
  }

  void _generateTelemetryData() async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();

    Map eventData1 = Telemetry.getStartTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        telemetryType,
        pageUri);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData1);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    Map eventData2 = Telemetry.getImpressionTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        telemetryType,
        pageUri);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData2);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    allEventsData.add(eventData1);
    allEventsData.add(eventData2);
    // await telemetryService.triggerEvent(allEventsData);
  }

  void _generateInteractTelemetryData(String contentId, String subtype) async {
    deviceIdentifier = await Telemetry.getDeviceIdentifier();
    userId = await Telemetry.getUserId();
    userSessionId = await Telemetry.generateUserSessionId();
    messageIdentifier = await Telemetry.generateUserSessionId();
    departmentId = await Telemetry.getUserDeptId();
    Map eventData = Telemetry.getInteractTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        contentId,
        subtype);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
  }

  @override
  void dispose() async {
    super.dispose();
    Map eventData = Telemetry.getEndTelemetryEvent(
        deviceIdentifier,
        userId,
        departmentId,
        pageIdentifier,
        userSessionId,
        messageIdentifier,
        _start * 1000,
        telemetryType,
        pageUri, {});
    allEventsData.add(eventData);
    telemetryEventData =
        TelemetryEventModel(userId: userId, eventData: eventData);
    await TelemetryDbHelper.insertEvent(telemetryEventData.toMap());
    // telemetryService.triggerEvent(allEventsData);
    _timer.cancel();
  }

  Future<void> _updateContentProgress() async {
    List<String> current = [];

    current.add(_microSurvey.length.toString());
    String courseId = widget.course['identifier'];
    String batchId = widget.batchId;
    String contentId = widget.identifier;
    int status = 2;
    String contentType = EMimeTypes.assessment;
    var maxSize = widget.course['duration'];
    // double completionPercentage =
    //     status == 2 ? 100.0 : (_start / maxSize) * 100;
    double completionPercentage = 100.0;
    await learnService.updateContentProgress(courseId, batchId, contentId,
        status, contentType, current, maxSize, completionPercentage,
        isAssessment: true);
    // print('response: ' + response.toString());
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

  void startTimer() {
    _timeFormat = formatHHMMSS(_start);
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _questionIndex = _microSurvey.length;
          });
        } else {
          setState(() {
            _start--;
          });
        }
        _timeFormat = formatHHMMSS(_start);
      },
    );
  }

  void updateQuestionIndex(int value) {
    setState(() {
      _questionIndex = value;
    });
  }

  void setUserAnswer(Map answer) {
    bool matchDetected = false;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['index'] == answer['index']) {
        setState(() {
          _questionAnswers[i]['value'] = answer['value'];
          _questionAnswers[i]['isCorrect'] = answer['isCorrect'];
          matchDetected = true;
        });
      }
    }
    if (!matchDetected) {
      setState(() {
        _questionAnswers.add(answer);
      });
    }
    // print(_questionAnswers);
  }

  bool _answerGiven(_questionIndex) {
    bool answerGiven = false;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['index'] == _questionIndex) {
        if (_questionAnswers[i]['value'] != null) {
          if (_questionAnswers[i]['value'].length > 0) {
            answerGiven = true;
          }
        } else {
          answerGiven = false;
        }
      }
    }
    return answerGiven;
  }

  Future<void> _submitSurvey() async {
    // print(_questionAnswers);
    for (int i = 0; i < _microSurvey.length; i++) {
      var userSelected;
      for (int j = 0; j < _questionAnswers.length; j++) {
        if (_questionAnswers[j]['index'] == _microSurvey[i]['questionId']) {
          if (_questionAnswers[j]['value'] != null) {
            userSelected = _questionAnswers[j];
          }
        }
        if (_microSurvey[i]['questionType'] ==
            AssessmentQuestionType.matchCase) {
          for (int k = 0; k < _microSurvey[i]['options'].length; k++) {
            _microSurvey[i]['options'][k]['response'] =
                userSelected != null ? userSelected['value'][k] : '';
          }
        } else if (_microSurvey[i]['questionType'] ==
            AssessmentQuestionType.radioType) {
          for (int k = 0; k < _microSurvey[i]['options'].length; k++) {
            _microSurvey[i]['options'][k]['userSelected'] = false;
            if (userSelected != null) {
              if (_microSurvey[i]['options'][k]['text'] ==
                  userSelected['value']) {
                _microSurvey[i]['options'][k]['userSelected'] =
                    userSelected['isCorrect'];
                _microSurvey[i]['options'][k]['userSelected'] = true;
              }
            }
          }
        } else if (_microSurvey[i]['questionType'] ==
            AssessmentQuestionType.matchCase) {
          for (int k = 0; k < _microSurvey[i]['options'].length; k++) {
            _microSurvey[i]['options'][k]['userSelected'] = false;
            if (userSelected != null &&
                userSelected['value']
                    .contains(_microSurvey[i]['options'][k]['optionId'])) {
              _microSurvey[i]['options'][k]['userSelected'] = true;
            }
          }
        } else {
          if (userSelected != null &&
              _microSurvey[i]['questionType'] == AssessmentQuestionType.fitb) {
            _microSurvey[i]['options'][0]['isCorrect'] = true;
            _microSurvey[i]['options'][0]['optionId'] =
                userSelected['optionId'];
            _microSurvey[i]['options'][0]['response'] = userSelected['value'];
            _microSurvey[i]['options'][0]['text'] = userSelected['text'];
          }
        }
      }
    }
    // developer.log(jsonEncode(_questionAnswers));
    // developer.log(jsonEncode(_microSurvey));
    Map surveyData = {
      'identifier': widget.identifier,
      'title': widget.title,
      // 'timeLimit': widget.microSurvey['timeLimit'],
      'timeLimit': timeLimit,
      'isAssessment': true,
      'questions': _microSurvey
    };

    Map response = await learnService.submitAssessment(surveyData);
    setState(() {
      _assessmentCompleted = true;
      _apiResponse = response;
    });
    if (widget.course['batches'] != null) {
      _updateContentProgress();
      widget.parentAction(100.0);
    }
    // print(_apiResponse.toString());
  }

  int _getRadioQuestionCorrectAnswer(List options) {
    int answerIndex;
    for (int i = 0; i < options.length; i++) {
      if (options[i]['isCorrect']) {
        answerIndex = i;
      }
    }
    // print(answerIndex.toString());
    return answerIndex;
  }

  List _shuffleOptions(List options) {
    if (_questionShuffled != _questionIndex) {
      _options = [];
      for (int i = 0; i < options.length; i++) {
        _options.add(options[i]['match']);
      }
      _options = _options..shuffle();
      _questionShuffled = _questionIndex;
    }
    // print(_options);
    return _options;
  }

  Widget _getAppbar() {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      // expandedHeight: ,
      leading: IconButton(
        icon: Icon(Icons.clear, color: FeedbackColors.black60),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(children: [
        Icon(Icons.book, color: FeedbackColors.black60),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.title,
                overflow: TextOverflow.fade,
                style: GoogleFonts.montserrat(
                  color: FeedbackColors.black87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              )),
        ),
        Spacer(),
        // _timeFormat != null && _questionIndex < _microSurvey.length
        //     ? Wrap(
        //         children: [
        //           Text(
        //             '$_timeFormat' + ' ',
        //             style: GoogleFonts.montserrat(
        //               color: FeedbackColors.black60,
        //               fontSize: 14.0,
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //           Padding(
        //               padding: const EdgeInsets.only(right: 10),
        //               child: Icon(
        //                 Icons.timer,
        //                 color: FeedbackColors.black60,
        //               ))
        //         ],
        //       )
        //     : Center()
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            Icons.info,
            color: AppColors.grey40,
          ),
        )
      ]),

      // centerTitle: true,
    );
  }

  _getQuestionAnswer(_index) {
    var givenAnswer;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['index'] == _index) {
        givenAnswer = _questionAnswers[i]['value'];
      }
    }
    if (_microSurvey[_questionIndex]['questionType'] ==
            AssessmentQuestionType.radioType ||
        _microSurvey[_questionIndex]['questionType'] ==
            AssessmentQuestionType.fitb) {
      return givenAnswer != null ? givenAnswer : '';
    } else {
      return givenAnswer != null ? givenAnswer : [];
    }
  }

  Widget _generatePagination() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: Text(
          'Question ${_questionIndex + 1} of ${_microSurvey.length}',
          style: GoogleFonts.lato(
            color: FeedbackColors.black60,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 5, top: 20),
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _microSurvey.length,
          itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {
                _generateInteractTelemetryData(
                    _microSurvey[index]['questionId'], TelemetrySubType.click);
                setState(() {
                  if (_answerGiven(_microSurvey[index]['questionId'])) {
                    _showAnswer = true;
                    _nextQuestion = true;
                  } else {
                    _showAnswer = false;
                    _nextQuestion = false;
                  }
                  _questionIndex = index;
                });
              },
              child: Container(
                height: 40,
                width: 60,
                margin: const EdgeInsets.only(left: 10),
                // padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.lato(
                      color: _questionIndex == index
                          ? FeedbackColors.black87
                          : FeedbackColors.black60,
                      fontWeight: _questionIndex == index
                          ? FontWeight.w700
                          : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: _answerGiven(_microSurvey[index]['questionId'])
                      ? FeedbackColors.black04
                      : Colors.white,
                  borderRadius: BorderRadius.all(const Radius.circular(22.0)),
                  border: Border.all(
                      color: _questionIndex == index
                          ? FeedbackColors.primaryBlue
                          : _answerGiven(_microSurvey[index]['questionId'])
                              ? FeedbackColors.lightGrey
                              : FeedbackColors.black16),
                ),
              )),
        ),
      )
    ]);
  }

  Future<bool> _onSubmitPressed(contextMain) {
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
                          height: 190.0,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  child: Text(
                                    'You have still time left, do you want to answer all the questions?',
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _questionIndex++;
                                  });
                                  _timer.cancel();
                                  _submitSurvey();
                                  Navigator.of(context).pop(true);
                                },
                                child: roundedButton('No, submit', Colors.white,
                                    FeedbackColors.primaryBlue),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(true),
                                  child: roundedButton('Yes, take me back',
                                      FeedbackColors.primaryBlue, Colors.white),
                                ),
                              )
                            ],
                          ),
                        )))
              ],
            ));
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var optionButton = Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.all(10),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        border: bgColor == Colors.white
            ? Border.all(color: FeedbackColors.black40)
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
    return optionButton;
  }

  @override
  Widget build(BuildContext context) {
    // _submitSurvey();
    // print(widget.course['batches'].last['batchId'].toString());
    return Scaffold(
      key: _scaffoldKey,
      appBar: _getAppbar(),
      body: SingleChildScrollView(
          child: Container(
              // height: MediaQuery.of(context).size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            _questionIndex >= _microSurvey.length
                ? Center()
                : Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _timeFormat != null &&
                                _questionIndex < _microSurvey.length
                            ? Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      '$_timeFormat' + ' ',
                                      style: GoogleFonts.montserrat(
                                        color: FeedbackColors.black60,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.timer,
                                        color: FeedbackColors.black60,
                                      ))
                                ],
                              )
                            : Center(),
                      ],
                    )),
            _questionIndex < _microSurvey.length
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                        color: Colors.white, child: _generatePagination()),
                  )
                : Center(),
            _questionIndex >= _microSurvey.length
                ? _assessmentCompleted
                    ? AssessmentCompleted(
                        _microSurvey.length,
                        _questionAnswers.length,
                        _wrongAnswers,
                        formatHHMMSS(timeLimit - _start),
                        _apiResponse,
                        updateQuestionIndex,
                      )
                    : PageLoader(
                        bottom: 200,
                      )
                : _microSurvey[_questionIndex]['questionType'] ==
                        AssessmentQuestionType.radioType
                    ? Container(
                        color: Colors.white,
                        child: RadioQuestion(
                            _microSurvey[_questionIndex],
                            _questionIndex + 1,
                            _getQuestionAnswer(
                                _microSurvey[_questionIndex]['questionId']),
                            _showAnswer,
                            _getRadioQuestionCorrectAnswer(
                                _microSurvey[_questionIndex]['options']),
                            setUserAnswer))
                    : _microSurvey[_questionIndex]['questionType'] ==
                            AssessmentQuestionType.checkBoxType
                        ? Container(
                            color: Colors.white,
                            child: MultiSelectQuestion(
                                _microSurvey[_questionIndex],
                                _questionIndex + 1,
                                _getQuestionAnswer(
                                    _microSurvey[_questionIndex]['questionId']),
                                _showAnswer,
                                setUserAnswer))
                        : _microSurvey[_questionIndex]['questionType'] ==
                                AssessmentQuestionType.matchCase
                            ? Container(
                                color: Colors.white,
                                child: MatchCaseQuestion(
                                    _microSurvey[_questionIndex],
                                    _shuffleOptions(_microSurvey[_questionIndex]
                                        ['options']),
                                    _questionIndex + 1,
                                    _getQuestionAnswer(
                                        _microSurvey[_questionIndex]
                                            ['questionId']),
                                    _showAnswer,
                                    setUserAnswer))
                            : Container(
                                color: Colors.white,
                                child: FillInTheBlankQuestion(_microSurvey[_questionIndex], _questionIndex + 1, _getQuestionAnswer(_microSurvey[_questionIndex]['questionId']), _showAnswer, setUserAnswer))
          ]))),
      bottomSheet: _questionIndex < _microSurvey.length
          ? Container(
              height: _questionIndex >= _microSurvey.length ? 0 : 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: FeedbackColors.black08,
                  blurRadius: 6.0,
                  spreadRadius: 0,
                  offset: Offset(
                    0,
                    -3,
                  ),
                ),
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  !_nextQuestion
                      ? Container(
                          height: 58,
                          width: MediaQuery.of(context).size.width - 40,
                          child: TextButton(
                            onPressed: () {
                              if (_answerGiven(
                                  _microSurvey[_questionIndex]['questionId'])) {
                                setState(() {
                                  _nextQuestion = true;
                                  _showAnswer = true;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please select an option"),
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              // primary: Colors.white,
                              backgroundColor: _answerGiven(
                                      _microSurvey[_questionIndex]
                                          ['questionId'])
                                  ? FeedbackColors.primaryBlue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide(
                                      color: FeedbackColors.primaryBlue)),
                              // onSurface: Colors.grey,
                            ),
                            child: Text(
                              ' Show answer',
                              style: GoogleFonts.lato(
                                color: !_answerGiven(
                                        _microSurvey[_questionIndex]
                                            ['questionId'])
                                    ? FeedbackColors.primaryBlue
                                    : Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : Center(),
                  _nextQuestion
                      ? Container(
                          height: 58,
                          width: MediaQuery.of(context).size.width - 40,
                          child: TextButton(
                            onPressed: () {
                              _generateInteractTelemetryData(
                                  widget.identifier, TelemetrySubType.submit);
                              if (_questionIndex == _microSurvey.length - 1 &&
                                  _questionAnswers.length <
                                      _microSurvey.length) {
                                // Code for confirm modal
                                _onSubmitPressed(context);
                              } else if (_questionIndex ==
                                  _microSurvey.length - 1) {
                                setState(() {
                                  _questionIndex++;
                                  _nextQuestion = false;
                                  _showAnswer = false;
                                });
                                _submitSurvey();
                                _timer.cancel();
                              } else {
                                if (_answerGiven(
                                    _microSurvey[_questionIndex + 1]
                                        ['questionId'])) {
                                  // print('1');
                                  setState(() {
                                    _questionIndex++;
                                    _nextQuestion = true;
                                    _showAnswer = true;
                                  });
                                } else {
                                  // print('2');
                                  setState(() {
                                    _questionIndex++;
                                    _nextQuestion = false;
                                    _showAnswer = false;
                                  });
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              // primary: Colors.white,
                              backgroundColor: FeedbackColors.customBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide(
                                      color: FeedbackColors.black16)),
                              // onSurface: Colors.grey,
                            ),
                            child: Text(
                              _questionIndex < _microSurvey.length - 1
                                  ? 'Next question'
                                  : 'Done',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : Center(),
                ],
              ),
            )
          : Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: FeedbackColors.black08,
                  blurRadius: 6.0,
                  spreadRadius: 0,
                  offset: Offset(
                    0,
                    -3,
                  ),
                ),
              ]),
              // width: 180,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  // primary: Colors.white,
                  backgroundColor: FeedbackColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // onSurface: Colors.grey,
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
    );
  }
}
