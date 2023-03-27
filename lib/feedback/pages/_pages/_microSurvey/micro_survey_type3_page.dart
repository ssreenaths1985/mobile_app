import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import './../../../constants.dart';
import './../../../services/micro_survey_service.dart';
import './../../../models/micro_survey_model.dart';
import './../../../widgets/index.dart';

class MicroSurveyType3Screen extends StatefulWidget {
  // static const route = FeedbackPageRoute.microSurveyPage;
  final String microSurveyType;
  MicroSurveyType3Screen(this.microSurveyType);

  @override
  _MicroSurveyType3ScreenState createState() {
    return _MicroSurveyType3ScreenState();
  }
}

class _MicroSurveyType3ScreenState extends State<MicroSurveyType3Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MicroSurveyService microSurveyService = MicroSurveyService();
  List<MicroSurvey> _microSurveys = [];
  List _questionAnswers = [];
  int _questionIndex = 0;
  bool _nextQuestion = false;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
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
        await microSurveyService.getMicroSurveyDetails('1620802159340');
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
          'Question ${_questionIndex + 1} of ${_microSurveys.length}',
          style: GoogleFonts.lato(
            color: FeedbackColors.black60,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 2, top: 20),
        padding: const EdgeInsets.only(
          left: 3,
        ),
        height: 6,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _microSurveys.length,
            itemBuilder: (BuildContext context, int index) =>
                // InkWell(
                // onTap: () {
                //   setState(() {
                //     _questionIndex = index;
                //   });
                // },
                // child:
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 40,
                  child: Text(
                    '',
                  ),
                  decoration: BoxDecoration(
                    color: _questionIndex == index
                        ? FeedbackColors.primaryBlue
                        : FeedbackColors.black04,
                    borderRadius: BorderRadius.all(const Radius.circular(2)),
                    border: Border.all(
                        color: _questionIndex == index
                            ? FeedbackColors.primaryBlue
                            : FeedbackColors.black04),
                  ),
                )),
      ),
      // )
    ]);
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
                                ? _generatePagination()
                                : Center(),
                            _questionIndex >= _microSurveys.length
                                ? SurveyCompleted(
                                    _microSurveys.length,
                                    _questionAnswers.length,
                                    '',
                                    updateQuestionIndex)
                                : _microSurveys[_questionIndex].fieldType ==
                                        QuestionType.radio
                                    ? RadioTypeQuestion(
                                        _microSurveys[_questionIndex],
                                        _questionIndex + 1,
                                        _getQuestionAnswer(_questionIndex),
                                        _showAnswer,
                                        setUserAnswer)
                                    : _microSurveys[_questionIndex].fieldType ==
                                            QuestionType.checkbox
                                        ? CheckboxTypeQuestion(
                                            _microSurveys[_questionIndex],
                                            _questionIndex + 1,
                                            _getQuestionAnswer(_questionIndex),
                                            _showAnswer,
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
                          !_nextQuestion
                              ? Container(
                                  height: 58,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: TextButton(
                                    onPressed: () {
                                      if (_answerGiven(_questionIndex)) {
                                        setState(() {
                                          _nextQuestion = true;
                                          _showAnswer = true;
                                        });
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      // primary: Colors.white,
                                      backgroundColor:
                                          _answerGiven(_questionIndex)
                                              ? FeedbackColors.primaryBlue
                                              : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: BorderSide(
                                              color:
                                                  FeedbackColors.primaryBlue)),
                                      // onSurface: Colors.grey,
                                    ),
                                    child: Text(
                                      ' Show answer',
                                      style: GoogleFonts.lato(
                                        color: !_answerGiven(_questionIndex)
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
                                      setState(() {
                                        _questionIndex++;
                                        _nextQuestion = false;
                                        _showAnswer = false;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      // primary: Colors.white,
                                      backgroundColor:
                                          FeedbackColors.customBlue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: BorderSide(
                                              color: FeedbackColors.black16)),
                                      // onSurface: Colors.grey,
                                    ),
                                    child: Text(
                                      _questionIndex < _microSurveys.length - 1
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
