import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../localization/_langs/english_lang.dart';
import '../../../../respositories/_respositories/network_respository.dart';
import '../../../../util/faderoute.dart';
import '../network/network_profile.dart';
import './../../../../constants/index.dart';
import './../../../../models/index.dart';
import './../../../../ui/widgets/index.dart';
// import './../../../../util/faderoute.dart';

class CourseLearnersPage extends StatefulWidget {
  final course;
  final List<CourseLearner> courseLearners;

  CourseLearnersPage(this.course, this.courseLearners);

  @override
  _CourseLearnersPageState createState() => _CourseLearnersPageState();
}

class _CourseLearnersPageState extends State<CourseLearnersPage> {
  // var _courseLearners;
  List<CourseLearner> _filteredCourseLearners = [];

  @override
  void initState() {
    super.initState();
    // _courseLearners = widget.courseLearners;
    setState(() {
      _filteredCourseLearners = widget.courseLearners;
    });
  }

  void filterLearners(value) {
    setState(() {
      _filteredCourseLearners = widget.courseLearners
          .where((learner) =>
              learner.fullName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: widget.courseLearners.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 48,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          // override textField's icon color when selected
                          primaryColor: AppColors.grey16,
                        ),
                        child: TextFormField(
                            onChanged: (value) {
                              filterLearners(value);
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            style: GoogleFonts.lato(fontSize: 14.0),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.grey16)),
                              hintText: 'Search learners',
                              hintStyle: GoogleFonts.lato(
                                  color: AppColors.grey40,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide: const BorderSide(
                              //       color: AppColors.primaryThree, width: 1.0),
                              // ),
                              counterStyle: TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: '',
                            )),
                      ),
                    ),
                  ),
                  _filteredCourseLearners.length != 0
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 10, 16),
                                  child: Text(
                                    (_filteredCourseLearners.length)
                                            .toString() +
                                        ' Learners',
                                    style: GoogleFonts.lato(
                                        decoration: TextDecoration.none,
                                        color: AppColors.greys60,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 100),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: _filteredCourseLearners.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          FadeRoute(
                                            page: ChangeNotifierProvider<
                                                NetworkRespository>(
                                              create: (context) =>
                                                  NetworkRespository(),
                                              child: NetworkProfile(
                                                  _filteredCourseLearners[index]
                                                      .id),
                                            ),
                                          ),
                                        ),
                                        child: Learner(
                                            name: _filteredCourseLearners[index]
                                                    .firstName +
                                                " " +
                                                _filteredCourseLearners[index]
                                                    .lastName,
                                            designation:
                                                _filteredCourseLearners[index]
                                                    .department),
                                      );
                                    },
                                  ),
                                )
                              ]))
                      : Center(
                          child: Text('No learners found',
                              style: GoogleFonts.lato(
                                  color: AppColors.grey40,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ),
                ],
              )
            : Container(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                    child: Column(children: [
                  SvgPicture.asset(
                    'assets/img/connections_empty.svg',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        EnglishLang.noLearners,
                        style: GoogleFonts.lato(
                          color: AppColors.greys60,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      )),
                  // widget.wid == ''
                  // Padding(
                  //     padding: const EdgeInsets.only(
                  //         top: 20, left: 50, right: 50),
                  //     child: Text(
                  //       EnglishLang.startNewDiscussionText,
                  //       textAlign: TextAlign.center,
                  //       style: GoogleFonts.lato(
                  //         color: AppColors.greys60,
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 16,
                  //       ),
                  //     ))
                  //     : Center()
                ]))),
      ),
    );
  }
}
