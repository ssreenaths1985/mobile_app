import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import 'dart:async';
import '../../../../services/_services/learn_service.dart';
import '../../../services/micro_survey_service.dart';
import './../../../constants.dart';
import './../../../models/micro_survey_model.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';
// import 'dart:developer' as developer;

// ignore: must_be_immutable
class SurveyPage extends StatefulWidget {
  final BuildContext mainContext;
  final Map submittedFeedbacks;
  // static const route = FeedbackPageRoute.microSurveyPage;
  // final String microSurveyType;
  Map microSurvey;
  final String surveyName;
  final course;
  final String identifier;
  final String batchId;
  SurveyPage(this.mainContext, this.microSurvey, this.submittedFeedbacks,
      this.surveyName, this.course, this.identifier, this.batchId);

  @override
  _SurveyPageState createState() {
    return _SurveyPageState();
  }
}

class _SurveyPageState extends State<SurveyPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MicroSurveyService microSurveyService = MicroSurveyService();
  final LearnService learnService = LearnService();
  List<MicroSurvey> _microSurvey = [];
  List _questionAnswers = [];
  int _questionIndex = 0;
  int count = 0;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _microSurvey = widget.microSurvey['questions'];
    // print('Qaz:' +
    //     widget.submittedFeedbacks.entries
    //         .where((element) => element.key == 'how was your experience')
    //         .first
    //         .value
    //         .toString());
    // for (var i = 0; i < _microSurvey.length; i++) {
    //   for (var j = 0; j < widget.submittedFeedbacks.entries.length; j++) {
    //     if (_microSurvey[i].question ==
    //         widget.submittedFeedbacks.entries.elementAt(j).key) {
    //       _microSurvey[i].answer =
    //           widget.submittedFeedbacks.entries.elementAt(j).value;
    //       print('key: ' +
    //           widget.submittedFeedbacks.entries.elementAt(j).key.toString());
    //     }
    //   }
    // }
    // developer.log(_microSurvey.first.answer.toString());
  }

  @override
  void dispose() {
    super.dispose();
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

  Future<bool> _submitSurvey(context) async {
    Map dataObject = {};
    bool isSubmitted = false;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['question'] != null) {
        dataObject[_questionAnswers[i]['question']] =
            _questionAnswers[i]['value'];
      }
    }
    // print(dataObject);
    Map surveyData = {
      'formId': widget.microSurvey['id'],
      'version': widget.microSurvey['version'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'dataObject': dataObject
    };

    // print('Submit: ' + surveyData.toString());
    var response = await microSurveyService.saveMicroSurvey(surveyData,
        isContentFeedback: true);
    if (response.toString() == 'true') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thanks for submitting the survey'),
          backgroundColor: AppColors.positiveLight,
        ),
      );
      await _updateContentProgress();
      Navigator.of(context).pop(true);
      isSubmitted = true;
      return isSubmitted;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EnglishLang.somethingWrong),
          backgroundColor: AppColors.negativeLight,
        ),
      );
      return isSubmitted;
    }
    // print('Submit: ' + response.toString());
  }

  Future<void> _updateContentProgress() async {
    List<String> current = [];

    current.add(_microSurvey.length.toString());
    String courseId = widget.course['identifier'];
    String batchId = widget.batchId;
    String contentId = widget.identifier;
    int status = 2;
    String contentType = EMimeTypes.survey;
    var maxSize = widget.course['duration'];
    // double completionPercentage =
    //     status == 2 ? 100.0 : (_start / maxSize) * 100;
    double completionPercentage = 100.0;
    await learnService.updateContentProgress(courseId, batchId, contentId,
        status, contentType, current, maxSize, completionPercentage,
        isAssessment: true);
    // print('response: ' + response.toString());
  }

  Widget _getAppbar() {
    return AppBar(
      titleSpacing: 0,
      elevation: 5,
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
              widget.surveyName,
              style: GoogleFonts.montserrat(
                color: FeedbackColors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            )),
        Spacer(),
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

  _getQuestionAnswer(_questionIndex, {bool isRadio = false}) {
    // print('Hy: $_questionAnswers');
    var givenAnswer;
    for (int i = 0; i < _questionAnswers.length; i++) {
      if (_questionAnswers[i]['index'] == _questionIndex) {
        // if (widget.submittedFeedbacks != null) {
        //   givenAnswer =
        //       widget.submittedFeedbacks['${_questionAnswers[i]['name']}'];
        // }
        givenAnswer = isRadio
            ? _questionAnswers[i]['value'].toString()
            : _questionAnswers[i]['value'];
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
                                    'Do you want to come back to your feedback?',
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              GestureDetector(
                                onTap: () async {
                                  final response =
                                      await _submitSurvey(contextMain);
                                  if (response) {
                                    Navigator.of(context).pop(true);
                                  }
                                },
                                child: roundedButton(EnglishLang.noSubmit,
                                    Colors.white, FeedbackColors.primaryBlue),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(true),
                                  child: roundedButton(
                                      EnglishLang.yesTakeMeBack,
                                      FeedbackColors.primaryBlue,
                                      Colors.white),
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
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: _getAppbar(),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: Text(
                          Helper.capitalize(
                              widget.microSurvey['title'].toString()),
                          style: GoogleFonts.lato(
                            color: FeedbackColors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      _questionIndex < _microSurvey.length
                          ? Container(
                              color: Colors.white, child: _generatePagination())
                          : Center(),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Divider(
                          thickness: 1,
                          color: AppColors.grey16,
                        ),
                      ),
                      _microSurvey[_questionIndex].fieldType ==
                              QuestionType.radio
                          ? Container(
                              color: Colors.white,
                              child: RadioTypeQuestion(
                                  _microSurvey[_questionIndex],
                                  _questionIndex + 1,
                                  _getQuestionAnswer(_questionIndex,
                                      isRadio: true),
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
                                              child: new TextFieldTypeQuestion(
                                                  _microSurvey[_questionIndex],
                                                  _questionIndex + 1,
                                                  _getQuestionAnswer(
                                                      _questionIndex),
                                                  setUserAnswer),
                                            )
                                          : Center()
                    ]))),
        bottomSheet: Container(
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
                              side: BorderSide(color: FeedbackColors.black16)),
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
                  onPressed: () async {
                    // if (_answerGiven(_questionIndex)) {
                    if (_questionIndex == _microSurvey.length - 1 &&
                        _questionAnswers.length < _microSurvey.length) {
                      await _onSubmitPressed(context);
                    } else if (_questionIndex == _microSurvey.length - 1) {
                      // setState(() {
                      //   _questionIndex = _microSurvey.length - 1;
                      // });
                      await _submitSurvey(context);
                      Navigator.of(context).pop(true);
                      // Navigator.pop(widget.mainContext);
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
        ));
  }
}
