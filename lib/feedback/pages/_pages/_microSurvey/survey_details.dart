import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../feedback/widgets/index.dart';
import './../../../../constants/index.dart';
import './../../../../feedback/constants.dart';
import './../../../../feedback/pages/index.dart';
import './../../../../feedback/widgets/_microSurvey/information_card.dart';
import './../../../services/micro_survey_service.dart';

class SurveyDetailsPage extends StatefulWidget {
  static const route = FeedbackPageRoute.surveyDetails;
  final String microSurveyType;
  SurveyDetailsPage(this.microSurveyType);

  @override
  _SurveyDetailsPageState createState() {
    return _SurveyDetailsPageState();
  }
}

class _SurveyDetailsPageState extends State<SurveyDetailsPage> {
  final MicroSurveyService microSurveyService = MicroSurveyService();
  Map _microSurvey;
  int i = 1;

  @override
  void initState() {
    super.initState();
  }

  Future<Map> _getMicroSurveys() async {
    _microSurvey =
        await microSurveyService.getMicroSurveyDetails(MICRO_SURVEY_ID);
    return _microSurvey;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getMicroSurveys(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
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
                        _microSurvey['title'],
                        style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  //   actions: [
                  //     widget.microSurveyType == MicroSurveyType.microSurveyType1
                  //         ? Padding(
                  //             padding: const EdgeInsets.only(right: 8, top: 20),
                  //             child: Text(
                  //               '01:40',
                  //               style: GoogleFonts.montserrat(
                  //                 color: AppColors.greys60,
                  //                 fontSize: 16.0,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           )
                  //         : Center(),
                  //     widget.microSurveyType == MicroSurveyType.microSurveyType1
                  //         ? Padding(
                  //             padding: const EdgeInsets.only(right: 16),
                  //             child: Icon(
                  //               Icons.timer,
                  //               color: AppColors.greys60,
                  //             ),
                  //           )
                  //         : Center()
                  //   ],
                ),
                body: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: SvgPicture.asset(
                                'assets/img/assessment.svg',
                                width: 40.0,
                                height: 56.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                'Assessment time',
                                style: GoogleFonts.lato(
                                  color: AppColors.greys87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 236,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 8.0, bottom: 8),
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
                            widget.microSurveyType ==
                                    MicroSurveyType.microSurveyType1
                                ? Column(
                                    children: SCENARIO_1_SUMMARY
                                        .map(
                                          (informationCard) => InformationCard(
                                              informationCard.scenarioNumber,
                                              informationCard.icon,
                                              informationCard.scenarioNumber ==
                                                      2
                                                  ? '${_microSurvey['questions'].length} questions'
                                                  : informationCard.information,
                                              informationCard.iconColor),
                                        )
                                        .toList(),
                                  )
                                : widget.microSurveyType ==
                                        MicroSurveyType.microSurveyType2
                                    ? Column(
                                        children: SCENARIO_2_SUMMARY
                                            .map(
                                              (informationCard) =>
                                                  InformationCard(
                                                      informationCard
                                                          .scenarioNumber,
                                                      informationCard.icon,
                                                      informationCard
                                                          .information,
                                                      informationCard
                                                          .iconColor),
                                            )
                                            .toList(),
                                      )
                                    : widget.microSurveyType ==
                                            MicroSurveyType.microSurveyType3
                                        ? Column(
                                            children: SCENARIO_3_SUMMARY
                                                .map(
                                                  (informationCard) =>
                                                      InformationCard(
                                                          informationCard
                                                              .scenarioNumber,
                                                          informationCard.icon,
                                                          informationCard
                                                              .information,
                                                          informationCard
                                                              .iconColor),
                                                )
                                                .toList(),
                                          )
                                        : Center()
                          ],
                        ),
                      ),
                      Container(
                        height: widget.microSurveyType ==
                                MicroSurveyType.microSurveyType3
                            ? 96
                            : 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.microSurveyType ==
                                      MicroSurveyType.microSurveyType1
                                  ? Column(
                                      children: SCENARIO_1_INFO
                                          .map(
                                            (informationCard) =>
                                                InformationCard(
                                                    informationCard
                                                        .scenarioNumber,
                                                    informationCard.icon,
                                                    informationCard.information,
                                                    informationCard.iconColor),
                                          )
                                          .toList(),
                                    )
                                  : widget.microSurveyType ==
                                          MicroSurveyType.microSurveyType2
                                      ? Column(
                                          children: SCENARIO_2_INFO
                                              .map(
                                                (informationCard) =>
                                                    InformationCard(
                                                        informationCard
                                                            .scenarioNumber,
                                                        informationCard.icon,
                                                        informationCard
                                                            .information,
                                                        informationCard
                                                            .iconColor),
                                              )
                                              .toList(),
                                        )
                                      : widget.microSurveyType ==
                                              MicroSurveyType.microSurveyType3
                                          ? Column(
                                              children: SCENARIO_3_INFO
                                                  .map(
                                                    (informationCard) =>
                                                        InformationCard(
                                                            informationCard
                                                                .scenarioNumber,
                                                            informationCard
                                                                .icon,
                                                            informationCard
                                                                .information,
                                                            informationCard
                                                                .iconColor),
                                                  )
                                                  .toList(),
                                            )
                                          : Center(),
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
                              builder: (context) => widget.microSurveyType ==
                                      MicroSurveyType.microSurveyType1
                                  ? MicroSurveyType1Screen(
                                      widget.microSurveyType, _microSurvey)
                                  : widget.microSurveyType ==
                                          MicroSurveyType.microSurveyType2
                                      ? MicroSurveyType2Screen(
                                          widget.microSurveyType)
                                      : widget.microSurveyType ==
                                              MicroSurveyType.microSurveyType3
                                          ? MicroSurveyType3Screen(
                                              widget.microSurveyType)
                                          : Center()));
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
                          'Start survey',
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
