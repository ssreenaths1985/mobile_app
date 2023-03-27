import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/_models/discuss_model.dart';
import 'package:karmayogi_mobile/respositories/_respositories/discuss_repository.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/discussion_page.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:provider/provider.dart';
import './../../../../ui/widgets/index.dart';
// import './../../../../util/faderoute.dart';

class CourseDiscussionPage extends StatefulWidget {
  // final String wid;
  final course;

  CourseDiscussionPage(this.course);

  @override
  _CourseDiscussionPageState createState() => _CourseDiscussionPageState();
}

class _CourseDiscussionPageState extends State<CourseDiscussionPage> {
  List<Discuss> _data = [];

  String _dropdownValue = EnglishLang.recent;
  List<String> dropdownItems = [EnglishLang.recent, EnglishLang.popular];

  // @override
  // void initState() {
  //   super.initState();
  // }

  /// Get course discussions
  Future<List<Discuss>> _getCourseDiscussion() async {
    try {
      final response =
          await Provider.of<DiscussRepository>(context, listen: false)
              .getCourseDiscussions(widget.course['identifier']);
      return response;
    } catch (err) {
      return err;
    }
  }

  /// Navigate to discussion detail
  _navigateToDetail(tid, userName, title, uid) {
    // _generateInteractTelemetryData(tid.toString());
    Navigator.push(
      context,
      FadeRoute(
        page: ChangeNotifierProvider<DiscussRepository>(
          create: (context) => DiscussRepository(),
          child: DiscussionPage(
              tid: tid, userName: userName, title: title, uid: uid),
        ),
      ),
    );
  }

  // @override
  // void dispose() async {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: _getCourseDiscussion(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              _data = snapshot.data;
              return (_data != null && _data.length > 0)
                  ? Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Container(
                          height: 10.0,
                        ),
                        // Container(
                        //   // width: double.infinity,
                        //   margin: EdgeInsets.only(top: 8, bottom: 8),
                        //   child: DropdownButton<String>(
                        //     value:
                        //         _dropdownValue != null ? _dropdownValue : null,
                        //     icon: Icon(Icons.arrow_drop_down_outlined),
                        //     iconSize: 26,
                        //     elevation: 16,
                        //     hint: Container(
                        //         alignment: Alignment.center,
                        //         margin: EdgeInsets.only(left: 16),
                        //         child: Text('Sort by: ')),
                        //     style: TextStyle(color: AppColors.greys87),
                        //     underline: Container(
                        //       // height: 2,
                        //       color: AppColors.lightGrey,
                        //     ),
                        //     selectedItemBuilder: (BuildContext context) {
                        //       return dropdownItems.map<Widget>((String item) {
                        //         return Row(
                        //           children: [
                        //             Padding(
                        //                 padding: EdgeInsets.fromLTRB(
                        //                     15.0, 15.0, 0, 15.0),
                        //                 child: Text(
                        //                   item,
                        //                   style: GoogleFonts.lato(
                        //                     color: AppColors.greys87,
                        //                     fontSize: 14,
                        //                     fontWeight: FontWeight.w400,
                        //                   ),
                        //                 ))
                        //           ],
                        //         );
                        //       }).toList();
                        //     },
                        //     onChanged: (String newValue) {
                        //       setState(() {
                        //         _dropdownValue = newValue;
                        //         // _sortMembers(_dropdownValue);
                        //       });
                        //     },
                        //     items: dropdownItems
                        //         .map<DropdownMenuItem<String>>((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Text(value),
                        //       );
                        //     }).toList(),
                        //   ),
                        // ),
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 200.0),
                              child: Wrap(
                                children: [
                                  for (int i = 0; i < _data.length; i++)
                                    InkWell(
                                      onTap: () {
                                        _navigateToDetail(
                                            _data[i].tid,
                                            _data[i].user['fullname'],
                                            _data[i].title,
                                            _data[i].user['uid']);
                                      },
                                      child: _data != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: DiscussCardView(
                                                data: _data[i],
                                              ),
                                            )
                                          : Center(
                                              child: Text(''),
                                            ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                          child: Column(children: [
                        SvgPicture.asset(
                          'assets/img/discussion-empty.svg',
                          fit: BoxFit.cover,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              EnglishLang.noDiscussions,
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
                      ])));
            } else {
              return Container(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                      child: Column(children: [
                    SvgPicture.asset(
                      'assets/img/discussion-empty.svg',
                      fit: BoxFit.cover,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          EnglishLang.noDiscussions,
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
                  ])));
            }
          }),
    );
  }
}
