import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/services/_services/learn_service.dart';
import './../../../../constants/_constants/app_constants.dart';
import './../../../../constants/_constants/color_constants.dart';
import './../../../../feedback/constants.dart';
import './../../../../feedback/widgets/_microSurvey/information_card.dart';
import './../../../../ui/widgets/_learn/_assessment/assessment_questions.dart';
// import 'package:karmayogi_mobile/ui/widgets/index.dart';
import './../../../../util/helper.dart';
import './../../../../feedback/widgets/index.dart';

class CourseAssessmentPlayer extends StatefulWidget {
  final course;
  final String title;
  final String identifier;
  final String fileUrl;
  final ValueChanged<Map> parentAction;
  final String batchId;
  final duration;
  CourseAssessmentPlayer(this.course, this.title, this.identifier, this.fileUrl,
      this.parentAction, this.batchId, this.duration);
  @override
  _CourseAssessmentPlayerState createState() => _CourseAssessmentPlayerState();
}

class _CourseAssessmentPlayerState extends State<CourseAssessmentPlayer> {
  final LearnService learnService = LearnService();
  Map _microSurvey;
  double surveyCompletedPercent = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getAssessmentData() async {
    // print('_getAssessmentData...');
    var response = await learnService.getAssessmentData(widget.fileUrl);
    // print(response['timeLimit']);
    return response;
  }

  void markSurveyCompleted(double status) {
    // print('status: $status');
    surveyCompletedPercent = status;
    Map data = {
      'identifier': widget.identifier,
      'completionPercentage': surveyCompletedPercent,
      'current': '',
      'mimeType': EMimeTypes.assessment,
      // 'surveyCompleted': 100.0
    };
    widget.parentAction(data);
  }

  @override
  void dispose() {
    // Map data = {
    //   'identifier': widget.identifier,
    //   'completionPercentage': surveyCompletedPercent,
    //   'current': '',
    //   'mimeType': EMimeTypes.assessment,
    //   // 'surveyCompleted': 100.0
    // };
    // widget.parentAction(data);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAssessmentData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // print(MediaQuery.of(context).size.height.toString());
          _microSurvey = snapshot.data;
          // print(_microSurvey);
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  // automaticallyImplyLeading: false,
                  leading: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColors.greys87,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        widget.title,
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
                body: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        // margin: EdgeInsets.only(top: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/img/assessment_welcome_b.svg',
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // height: 250,
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 24),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 24, left: 24),
                              child: Text(
                                'Summary',
                                style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Column(
                              children: SCENARIO_1_SUMMARY
                                  .map(
                                    (informationCard) => InformationCard(
                                        informationCard.scenarioNumber,
                                        informationCard.icon,
                                        informationCard.scenarioNumber == 2
                                            ? '${_microSurvey['questions'].length} questions'
                                            // : 'Total ' +
                                            //     Helper.getFullTimeFormat(
                                            //         _microSurvey['timeLimit']
                                            //             .toString()),
                                            : 'Total ' +
                                                widget.duration
                                                    .toString()
                                                    .split('-')
                                                    .last,
                                        informationCard.iconColor),
                                  )
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        // height: 225,
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 24),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: SCENARIO_1_INFO
                                    .map(
                                      (informationCard) => InformationCard(
                                          informationCard.scenarioNumber,
                                          informationCard.icon,
                                          informationCard.information,
                                          informationCard.iconColor),
                                    )
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ])),
                bottomNavigationBar: BottomAppBar(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                        context, FeedbackPageRoute.surveyResults),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(const Radius.circular(4.0)),
                        color: AppColors.primaryThree,
                      ),
                      // width: 180,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AssessmentQuestions(
                                  widget.course,
                                  widget.title,
                                  widget.identifier,
                                  _microSurvey,
                                  markSurveyCompleted,
                                  widget.batchId,
                                  widget.duration)));
                        },
                        style: TextButton.styleFrom(
                          // primary: Colors.white,
                          backgroundColor: AppColors.primaryThree,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          // onSurface: Colors.grey,
                        ),
                        child: Text(
                          'Start assessment',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
          } else {
            return Scaffold(
                appBar: AppBar(
                    elevation: 0,
                    // automaticallyImplyLeading: false,
                    leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.greys87,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    title: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          '',
                          style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ))),
                body: PageLoader());
          }
        });
  }
}
