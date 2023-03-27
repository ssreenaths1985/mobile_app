import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/feedback/pages/_pages/_cbpSurvey/survey_page.dart';
import './../../../../feedback/widgets/index.dart';
import './../../../../constants/index.dart';
import './../../../../feedback/constants.dart';
import './../../../services/micro_survey_service.dart';

class ContentFeedback extends StatefulWidget {
  static const route = FeedbackPageRoute.surveyDetails;
  final String surveyUrl;
  final String surveyName;
  final course;
  final String identifier;
  final String batchId;
  // final String microSurveyType;
  ContentFeedback(this.surveyUrl, this.surveyName, this.course, this.identifier,
      this.batchId);

  @override
  _ContentFeedbackState createState() {
    return _ContentFeedbackState();
  }
}

class _ContentFeedbackState extends State<ContentFeedback> {
  final MicroSurveyService microSurveyService = MicroSurveyService();
  Map _microSurvey;
  int i = 1;
  bool _isPageInitialized = false;
  var _submittedFeedbacks;

  @override
  void initState() {
    super.initState();
  }

  Future<Map> _getMicroSurveys() async {
    if (!_isPageInitialized) {
      String id = widget.surveyUrl.split('/').last;
      _microSurvey = await microSurveyService.getMicroSurveyDetails(id,
          isContentFeedback: true);
      // _submittedFeedbacks = await microSurveyService.getSubmittedFeedback(id);
      // print('Submitted: ' + _submittedFeedbacks['Status'].toString());
      setState(() {
        _isPageInitialized = true;
      });
    }
    return _microSurvey;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getMicroSurveys(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return SurveyPage(
                context,
                _microSurvey,
                _submittedFeedbacks,
                widget.surveyName,
                widget.course,
                widget.identifier,
                widget.batchId);
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
