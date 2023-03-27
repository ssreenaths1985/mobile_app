import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';
import './../../../../feedback/pages/_pages/_microSurvey/survey_details.dart';
// import './../../index.dart';
import './../../../constants.dart';

class MicroSurveysScreen extends StatefulWidget {
  static const route = FeedbackPageRoute.microSurveysPage;

  @override
  _MicroSurveysScreenState createState() {
    return _MicroSurveysScreenState();
  }
}

class _MicroSurveysScreenState extends State<MicroSurveysScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _getAppbar() {
    return AppBar(
      title: Row(children: [
        Icon(Icons.book, color: FeedbackColors.black60),
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Micro Surveys',
              style: GoogleFonts.montserrat(
                color: FeedbackColors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ))
      ]),
      // centerTitle: true,
    );
  }

  Widget _getSurvey(String surveyType) {
    return InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SurveyDetailsPage(surveyType)),
            ),
        child: Container(
          // margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/img/assessment_icon.svg',
                width: 25.0,
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(surveyType),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: AppColors.grey04,
            borderRadius: BorderRadius.all(const Radius.circular(4)),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppbar(),
        body: Container(
          height: 228,
          color: Colors.white,
          margin: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: _getSurvey(MicroSurveyType.microSurveyType1),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: _getSurvey(MicroSurveyType.microSurveyType2),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: _getSurvey(MicroSurveyType.microSurveyType3),
            ),
          ]),
        ));
  }
}
