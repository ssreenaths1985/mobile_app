import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/color_constants.dart';
import '../../../../models/_models/course_model.dart';

// ignore: must_be_immutable
class MandatoryCoursesPage extends StatefulWidget {
  MandatoryCoursesPage();

  @override
  _MandatoryCoursesPageState createState() => _MandatoryCoursesPageState();
}

class _MandatoryCoursesPageState extends State<MandatoryCoursesPage> {
  final service = HttpClient();
  // int pageNo = 1;
  // int pageCount;
  // int currentPage;

  List _mandatoryCourses = [];
  int _notStarted = 0;
  int _inProgress = 0;
  int _completed = 0;

  @override
  void initState() {
    super.initState();
    // _getMandatoryCourses();
  }

  Future<List<Course>> _getMandatoryCourses() async {
    try {
      List<Course> _data =
          await Provider.of<LearnRepository>(context, listen: false)
              .getMandatoryCourses();
      _notStarted = _data
          .where((course) => course.raw['completionPercentage'] == 0)
          .toList()
          .length;
      _inProgress = _data
          .where((course) => (course.raw['completionPercentage'] > 0 &&
              course.raw['completionPercentage'] < 100))
          .toList()
          .length;
      _completed = _data
          .where((course) => (course.raw['completionPercentage'] == 100))
          .toList()
          .length;
      // print(_data.length);
      return _data;
    } catch (err) {
      return err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'All mandatory courses',
            style: GoogleFonts.montserrat(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: FutureBuilder(
            future: _getMandatoryCourses(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                _mandatoryCourses = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          child: ClipPath(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Total course assigned',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.25,
                                                    height: 1.429,
                                                    color: AppColors.greys60),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  _mandatoryCourses.length
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.12,
                                                      height: 1.4,
                                                      color:
                                                          AppColors.greys87)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 1,
                                        width: 20,
                                        color: AppColors.grey16,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'In progress',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.25,
                                                    height: 1.429,
                                                    color: AppColors.greys60),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  _inProgress.toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.12,
                                                      height: 1.4,
                                                      color:
                                                          AppColors.greys87)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Not started',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.25,
                                                    height: 1.429,
                                                    color: AppColors.greys60),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  _notStarted.toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.12,
                                                      height: 1.4,
                                                      color:
                                                          AppColors.greys87)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 1,
                                        width: 20,
                                        color: AppColors.grey16,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Completed',
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.25,
                                                    height: 1.429,
                                                    color: AppColors.greys60),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                _completed.toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.12,
                                                    height: 1.4,
                                                    color: AppColors.greys87),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        // height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _mandatoryCourses.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: MyLearningCard(
                                _mandatoryCourses[index],
                                isMandatory: true,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return PageLoader(
                  bottom: 150,
                );
              }
            },
          ),
        ));
  }
}
