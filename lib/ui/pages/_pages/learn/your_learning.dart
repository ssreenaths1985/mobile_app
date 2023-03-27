import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:provider/provider.dart';
import '../../../../constants/_constants/color_constants.dart';
import '../../../../models/_models/course_model.dart';
// import 'dart:developer' as developer;

// ignore: must_be_immutable
class YourLearningPage extends StatefulWidget {
  YourLearningPage();

  @override
  _YourLearningPageState createState() => _YourLearningPageState();
}

class _YourLearningPageState extends State<YourLearningPage> {
  final service = HttpClient();
  int pageNo = 1;
  int pageCount;
  int currentPage;

  List<Course> _continueLearningcourses = [];

  @override
  void initState() {
    super.initState();
    _getContinueLearningCourses();
  }

  Future<dynamic> _getContinueLearningCourses() async {
    try {
      List _data = await Provider.of<LearnRepository>(context, listen: false)
          .getContinueLearningCourses();
      return _data;
    } catch (err) {
      return err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      // scrollDirection: Axis.horizontal,
      child: FutureBuilder(
        future: _getContinueLearningCourses(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _continueLearningcourses = snapshot.data;
            return _continueLearningcourses.length > 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8, bottom: 165),
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          // shrinkWrap: true,
                          itemCount: _continueLearningcourses.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: MyLearningCard(
                                  _continueLearningcourses[index]),
                            );
                          },
                        ),
                      )
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 125),
                                child: SvgPicture.asset(
                                  'assets/img/empty_search.svg',
                                  alignment: Alignment.center,
                                  // color: AppColors.grey16,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              "You haven't started with any course",
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1.5,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "Enroll for a course, to get started!",
                                style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 1.5,
                                  letterSpacing: 0.25,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ),
                          )
                        ],
                      ),
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
