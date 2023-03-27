import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../localization/_langs/english_lang.dart';
import './../../../widgets/index.dart';
import './../../../../constants/index.dart';

class LearnSearchPage extends StatefulWidget {
  static const route = AppUrl.dashboardProfilePage;
  final courses;

  LearnSearchPage(this.courses);
  @override
  _LearnSearchPageState createState() => _LearnSearchPageState();
}

class _LearnSearchPageState extends State<LearnSearchPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 5),
              alignment: Alignment.topLeft,
              child: SectionHeading('Learn search results'),
            ),
            widget.courses.length > 0
                ? (Container(
                    // height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.courses.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: BrowseCourseCard(
                            course: widget.courses[index],
                          ),
                        );
                      },
                    ),
                  ))
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
                              EnglishLang.noResultsFound,
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1.5,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
