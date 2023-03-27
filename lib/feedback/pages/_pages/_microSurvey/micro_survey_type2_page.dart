import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import './../../../constants.dart';
import './../../../services/micro_survey_service.dart';
import './../../../models/micro_survey_model.dart';
import './../../../widgets/index.dart';

class MicroSurveyType2Screen extends StatefulWidget {
  // static const route = FeedbackPageRoute.microSurveyPage;
  final String microSurveyType;
  MicroSurveyType2Screen(this.microSurveyType);

  @override
  _MicroSurveyType2ScreenState createState() {
    return _MicroSurveyType2ScreenState();
  }
}

class _MicroSurveyType2ScreenState extends State<MicroSurveyType2Screen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MicroSurveyService microSurveyService = MicroSurveyService();
  List<MicroSurvey> _microSurveys = [];
  List _questionAnswers = [];
  int _questionIndex = 0;

  Timer _timer;
  int _start = 60;
  double _progress = 1.0;
  String _timeFormat;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
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
          });
        } else {
          setState(() {
            _start--;
            _progress = _progress - 0.0166;
          });
          if (_start == 0) {
            _progress = 0.0;
            setState(() {
              _questionIndex++;
              _start = 60;
              _progress = 1.0;
            });
          }
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
    // print(_questionAnswers);
    bool answerGiven = false;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['index'] == _questionIndex) {
        if (_microSurveys[i].fieldType != QuestionType.rating) {
          if (_questionAnswers[i]['value'].length > 0) {
            answerGiven = true;
          }
        } else if (_questionAnswers[i]['value'] > 0) {
          answerGiven = true;
        }
      }
    }
    return answerGiven;
  }

  Future<List<MicroSurvey>> _getMicroSurveys() async {
    _microSurveys =
        await microSurveyService.getMicroSurveyDetails('1620384858269');
    return _microSurveys;
  }

  Widget _getAppbar() {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.clear, color: FeedbackColors.black60),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(children: [
        Icon(Icons.book, color: FeedbackColors.black60),
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.microSurveyType,
              style: GoogleFonts.montserrat(
                color: FeedbackColors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            )),
      ]),
      // centerTitle: true,
    );
  }

  // void _displayErrorMessage() {
  //   final snackBar = SnackBar(
  //       content: Text(
  //         'Please select any option to proceed.',
  //       ),
  //       // elevation: 6.0,
  //       margin: const EdgeInsets.only(bottom: 60),
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Theme.of(context).errorColor,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  _getQuestionAnswer(_questionIndex) {
    var givenAnswer;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['index'] == _questionIndex) {
        givenAnswer = _questionAnswers[i]['value'];
      }
    }
    return givenAnswer;
  }

  Widget _generateQuestionHeader() {
    return Container(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: Column(children: [
          Row(children: [
            Text(
              'Question ${_questionIndex + 1} of ${_microSurveys.length}',
              style: GoogleFonts.lato(
                color: FeedbackColors.black60,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            ),
            Spacer(),
            Text(
              '$_timeFormat' + ' ',
              style: GoogleFonts.montserrat(
                color: FeedbackColors.black60,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Icon(
                  Icons.timer,
                  color: FeedbackColors.black60,
                ))
          ]),
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  backgroundColor: FeedbackColors.black04,
                  minHeight: 8,
                  value: _progress,
                  valueColor: AlwaysStoppedAnimation<Color>(_start > 10
                      ? FeedbackColors.primaryBlue
                      : FeedbackColors.negativeLight),
                ),
              )))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getMicroSurveys(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: _getAppbar(),
              body: SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _questionIndex < _microSurveys.length
                                ? _generateQuestionHeader()
                                : Center(),
                            _questionIndex >= _microSurveys.length
                                ? SurveyCompleted(
                                    _microSurveys.length,
                                    _questionAnswers.length,
                                    formatHHMMSS(5 * 60 - _start),
                                    updateQuestionIndex)
                                : _microSurveys[_questionIndex].fieldType ==
                                        QuestionType.radio
                                    ? RadioTypeQuestion(
                                        _microSurveys[_questionIndex],
                                        _questionIndex + 1,
                                        _getQuestionAnswer(_questionIndex),
                                        false,
                                        setUserAnswer)
                                    : _microSurveys[_questionIndex].fieldType ==
                                            QuestionType.checkbox
                                        ? CheckboxTypeQuestion(
                                            _microSurveys[_questionIndex],
                                            _questionIndex + 1,
                                            _getQuestionAnswer(_questionIndex),
                                            false,
                                            setUserAnswer)
                                        : _microSurveys[_questionIndex]
                                                    .fieldType ==
                                                QuestionType.rating
                                            ? RatingTypeQuestion(
                                                _microSurveys[_questionIndex],
                                                _questionIndex + 1,
                                                _getQuestionAnswer(
                                                    _questionIndex),
                                                setUserAnswer)
                                            : _microSurveys[_questionIndex]
                                                            .fieldType ==
                                                        QuestionType.textarea ||
                                                    _microSurveys[
                                                                _questionIndex]
                                                            .fieldType ==
                                                        QuestionType.text
                                                ? TextFieldTypeQuestion(
                                                    _microSurveys[
                                                        _questionIndex],
                                                    _questionIndex + 1,
                                                    _getQuestionAnswer(
                                                        _questionIndex),
                                                    setUserAnswer)
                                                : Center()
                          ]))),
              bottomSheet: _questionIndex < _microSurveys.length
                  ? Container(
                      height: _questionIndex >= _microSurveys.length ? 0 : 80,
                      padding: const EdgeInsets.all(16),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
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
                          Container(
                            height: 58,
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            child: TextButton(
                              onPressed: () {
                                // print('backPress');
                                setState(() {
                                  _questionIndex++;
                                  _start = 60;
                                  _progress = 1.0;
                                });
                              },
                              style: TextButton.styleFrom(
                                // primary: Colors.white,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                        color: FeedbackColors.primaryBlue)),
                                // onSurface: Colors.grey,
                              ),
                              child: Text(
                                _questionIndex < _microSurveys.length - 1
                                    ? 'Skip'
                                    : 'Skip and submit',
                                style: GoogleFonts.lato(
                                  color: FeedbackColors.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 58,
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            child: TextButton(
                              onPressed: () {
                                if (_answerGiven(_questionIndex)) {
                                  setState(() {
                                    _questionIndex++;
                                    _start = 60;
                                    _progress = 1.0;
                                  });
                                }
                                // else {
                                //   _displayErrorMessage();
                                // }
                              },
                              style: TextButton.styleFrom(
                                // primary: Colors.white,
                                backgroundColor: _answerGiven(_questionIndex)
                                    ? FeedbackColors.customBlue
                                    : FeedbackColors.black16,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                        color: _answerGiven(_questionIndex)
                                            ? FeedbackColors.customBlue
                                            : FeedbackColors.black16)),
                                // onSurface: Colors.grey,
                              ),
                              child: Text(
                                _questionIndex < _microSurveys.length - 1
                                    ? 'Next question'
                                    : 'Submit',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
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
                        onPressed: () => Navigator.pop(context),
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
          } else {
            return Scaffold(appBar: _getAppbar(), body: PageLoader());
          }
        });
  }
}
