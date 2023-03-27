import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import './../../../constants.dart';
import './../../../services/micro_survey_service.dart';
import './../../../models/micro_survey_model.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class MicroSurveyType1Screen extends StatefulWidget {
  // static const route = FeedbackPageRoute.microSurveyPage;
  final String microSurveyType;
  final microSurvey;
  MicroSurveyType1Screen(this.microSurveyType, this.microSurvey);

  @override
  _MicroSurveyType1ScreenState createState() {
    return _MicroSurveyType1ScreenState();
  }
}

class _MicroSurveyType1ScreenState extends State<MicroSurveyType1Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MicroSurveyService microSurveyService = MicroSurveyService();
  List<MicroSurvey> _microSurvey = [];
  List _questionAnswers = [];
  int _questionIndex = 0;

  Timer _timer;
  int _start = 5 * 60;
  String _timeFormat;

  @override
  void initState() {
    super.initState();
    _microSurvey = widget.microSurvey['questions'];
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
          if (_microSurvey[_questionIndex].fieldType != QuestionType.rating) {
            if (_questionAnswers[i]['value'].length > 0) {
              answerGiven = true;
            }
          } else if (_questionAnswers[i]['value'] != '') {
            if (_questionAnswers[i]['value'] > 0) {
              answerGiven = true;
            } else {
              answerGiven = false;
            }
          }
        } else {
          answerGiven = false;
        }
      }
    }
    return answerGiven;
  }

  Future<void> _submitSurvey() async {
    Map dataObject = {};
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['question'] != null) {
        dataObject[_questionAnswers[i]['question']] =
            _questionAnswers[i]['value'];
      }
    }
    // print(dataObject);
    Map surveyData = {
      'id': widget.microSurvey['id'],
      'version': widget.microSurvey['version'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'dataObject': dataObject
    };

    await microSurveyService.saveMicroSurvey(surveyData);
    // print(response);
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
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.microSurvey['title'],
              style: GoogleFonts.montserrat(
                color: FeedbackColors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            )),
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

  _getQuestionAnswer(_questionIndex) {
    var givenAnswer;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['index'] == _questionIndex) {
        givenAnswer = _questionAnswers[i]['value'];
      }
    }
    return givenAnswer;
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
                setState(() {
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
                  color: _answerGiven(index)
                      ? FeedbackColors.black04
                      : Colors.white,
                  borderRadius: BorderRadius.all(const Radius.circular(22.0)),
                  border: Border.all(
                      color: _questionIndex == index
                          ? FeedbackColors.primaryBlue
                          : _answerGiven(index)
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: _getAppbar(),
      body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
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
                                            padding:
                                                const EdgeInsets.only(top: 3),
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
                                              padding: const EdgeInsets.only(
                                                  right: 10),
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
                                color: Colors.white,
                                child: _generatePagination()),
                          )
                        : Center(),
                    _questionIndex >= _microSurvey.length
                        ? SurveyCompleted(
                            _microSurvey.length,
                            _questionAnswers.length,
                            formatHHMMSS(5 * 60 - _start),
                            updateQuestionIndex)
                        : _microSurvey[_questionIndex].fieldType ==
                                QuestionType.radio
                            ? Container(
                                color: Colors.white,
                                child: RadioTypeQuestion(
                                    _microSurvey[_questionIndex],
                                    _questionIndex + 1,
                                    _getQuestionAnswer(_questionIndex),
                                    false,
                                    setUserAnswer),
                              )
                            : _microSurvey[_questionIndex].fieldType ==
                                    QuestionType.boolean
                                ? Container(
                                    color: Colors.white,
                                    child: BooleanTypeQuestion(
                                        _microSurvey[_questionIndex],
                                        _questionIndex + 1,
                                        _getQuestionAnswer(_questionIndex),
                                        false,
                                        setUserAnswer),
                                  )
                                : _microSurvey[_questionIndex].fieldType ==
                                        QuestionType.checkbox
                                    ? Container(
                                        color: Colors.white,
                                        child: CheckboxTypeQuestion(
                                            _microSurvey[_questionIndex],
                                            _questionIndex + 1,
                                            _getQuestionAnswer(_questionIndex),
                                            false,
                                            setUserAnswer),
                                      )
                                    : _microSurvey[_questionIndex].fieldType ==
                                            QuestionType.rating
                                        ? Container(
                                            color: Colors.white,
                                            child: RatingTypeQuestion(
                                                _microSurvey[_questionIndex],
                                                _questionIndex + 1,
                                                _getQuestionAnswer(
                                                    _questionIndex),
                                                setUserAnswer),
                                          )
                                        : _microSurvey[_questionIndex]
                                                        .fieldType ==
                                                    QuestionType.textarea ||
                                                _microSurvey[_questionIndex]
                                                        .fieldType ==
                                                    QuestionType.text ||
                                                _microSurvey[_questionIndex]
                                                        .fieldType ==
                                                    QuestionType.numeric ||
                                                _microSurvey[_questionIndex]
                                                        .fieldType ==
                                                    QuestionType.email
                                            ? Container(
                                                color: Colors.white,
                                                child:
                                                    new TextFieldTypeQuestion(
                                                        _microSurvey[
                                                            _questionIndex],
                                                        _questionIndex + 1,
                                                        _getQuestionAnswer(
                                                            _questionIndex),
                                                        setUserAnswer),
                                              )
                                            : Center()
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
                  _questionIndex > 0
                      ? Container(
                          height: 58,
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: TextButton(
                            onPressed: () {
                              // print('backPress');
                              setState(() {
                                _questionIndex--;
                              });
                            },
                            style: TextButton.styleFrom(
                              // primary: Colors.white,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide(
                                      color: FeedbackColors.black16)),
                              // onSurface: Colors.grey,
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: AppColors.greys60,
                                    ),
                                  ),
                                  Text(
                                    ' Previous',
                                    style: GoogleFonts.lato(
                                      color: FeedbackColors.black87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      : Center(),
                  Spacer(),
                  Container(
                    height: 58,
                    width: _questionIndex == 0
                        ? MediaQuery.of(context).size.width - 40
                        : MediaQuery.of(context).size.width / 2 + 20,
                    child: TextButton(
                      onPressed: () {
                        // if (_answerGiven(_questionIndex)) {
                        if (_questionIndex == _microSurvey.length - 1 &&
                            _questionAnswers.length < _microSurvey.length) {
                          // Code for confirm modal
                          _onSubmitPressed(context);
                        } else if (_questionIndex == _microSurvey.length - 1) {
                          setState(() {
                            _questionIndex++;
                          });
                          _submitSurvey();
                          _timer.cancel();
                        } else {
                          setState(() {
                            _questionIndex++;
                          });
                        }
                        // }
                      },
                      style: TextButton.styleFrom(
                        // primary: Colors.white,
                        backgroundColor: FeedbackColors.customBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: FeedbackColors.black16)),
                        // onSurface: Colors.grey,
                      ),
                      child: Text(
                        _questionIndex < _microSurvey.length - 1
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
  }
}
