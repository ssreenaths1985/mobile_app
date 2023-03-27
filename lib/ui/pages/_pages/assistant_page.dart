import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:provider/provider.dart';
import '../index.dart';
import './../../../constants/index.dart';
import './../../../respositories/_respositories/discuss_repository.dart';
import './../../../services/_services/current_course.dart';
import './../../../ui/widgets/_assistant/recently_searched.dart';
// import './../../../ui/widgets/_common/section_heading.dart';
import './../../../ui/widgets/index.dart';
import './../../../util/faderoute.dart';
import './../../../models/_models/course_model.dart';

class AssistantPage extends StatefulWidget {
  static const route = AppUrl.assistantPage;
  @override
  _AssistantPageState createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  List _data = [];
  List<Course> _continueLearningcourses;
  final CurrentCourseService currentCourseService = CurrentCourseService();
  List recentlySearchedNames = [
    'Raman Srivastava',
    'Communication Skills',
    'Administrative Law'
  ];

  Future<dynamic> _getContinueLearningCourses() async {
    try {
      var courses;
      courses = await Provider.of<LearnRepository>(context, listen: false)
          .getContinueLearningCourses();
      return courses;
    } catch (err) {
      return err;
    }
  }

  /// Get trending discussions
  Future<void> _trendingDiscussion() async {
    try {
      _data = await Provider.of<DiscussRepository>(context, listen: false)
          .getTrendingDiscussions(1);
    } catch (err) {
      return err;
    }
  }

  _navigateToDetail(tid, userName, title, uid) {
    Navigator.push(
      context,
      FadeRoute(
          page: ChangeNotifierProvider<DiscussRepository>(
        create: (context) => DiscussRepository(),
        child: DiscussionPage(
          tid: tid,
          userName: userName,
          title: title,
          uid: uid,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: SectionHeading('You were doing'),
          ),
          FutureBuilder(
              future: _getContinueLearningCourses(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  _continueLearningcourses = snapshot.data;
                  return Container(
                      height: 348,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 5, bottom: 15),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _continueLearningcourses.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () => Navigator.push(
                                    context,
                                    FadeRoute(
                                        page: CourseDetailsPage(
                                      id: _continueLearningcourses[index]
                                          .raw['courseId'],
                                      isContinueLearning: true,
                                    )),
                                  ),
                              child: CourseItem(
                                course: _continueLearningcourses[index],
                                progress: (_continueLearningcourses[index]
                                        .raw['completionPercentage'] /
                                    100),
                                displayProgress: true,
                              ));
                        },
                      ));
                } else {
                  return Center();
                }
              }),

          //  Padding(
          //   padding: const EdgeInsets.only(right: 16.0, left: 8, top: 8),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          // child: CourseItem(Course(
          //     appIcon:
          //         'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
          //     name: 'Basics of Administrative law',
          //     description: 'Administrative law',
          //     duration: 2,
          //     rating: 4.5)),
          //     child: FutureBuilder(
          //       future: currentCourseService.getCurrentCourse(),
          //       builder:
          //           (BuildContext context, AsyncSnapshot<Course> snapshot) {
          //         if (snapshot.hasData) {
          //           Course course = snapshot.data;
          //           return InkWell(
          //               onTap: () => Navigator.push(
          //                     context,
          //                     FadeRoute(page: CourseDetailsPage(id: course.id)),
          //                   ),
          //               child: CourseItem(
          //                 course: course,
          //                 displayProgress: true,
          //               ));
          //         } else {
          //           return Center();
          //         }
          //       },
          //     ),
          //   ),
          // ),

          // Container(
          //   alignment: Alignment.topLeft,
          //   child: SectionHeading('Recently searched'),
          // ),
          // Container(
          //   // margin: const EdgeInsets.only(left: 0),
          //   padding: const EdgeInsets.only(right: 0, top: 8),
          //   height: 50,
          //   child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: recentlySearchedNames.length,
          //       itemBuilder: (BuildContext context, int index) =>
          //           buildRecentlySearchedList(context, index)),
          // ),

          // Container(
          //   alignment: Alignment.topLeft,
          //   child: SectionHeading('Last 30 days'),
          // ),
          // Container(
          //     margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          //     padding: const EdgeInsets.all(15),
          //     color: Colors.white,
          //     child: UsageVisualization()),
          // Container(
          //   height: 120,
          //   width: double.infinity,
          //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: AT_A_GLANCE
          //         .map(
          //           (hub) => Card(
          //               color: Colors.white,
          //               margin: const EdgeInsets.only(left: 20),
          //               child: new Container(
          //                   width: 150,
          //                   child: RectangleList(hub.id, hub.title, hub.icon,
          //                       hub.iconColor, hub.points, hub.svgIcon))),
          //         )
          //         .toList(),
          //   ),
          // ),
          // Container(
          //     margin: const EdgeInsets.fromLTRB(20, 0, 16, 0),
          //     // padding: const EdgeInsets.all(10),
          //     child: ExploreDashboard()),
          // Container(
          //   alignment: Alignment.topLeft,
          //   child: SectionHeading('Last viewed Discussions'),
          // ),
          // // AiAssistantPage()
          // // Container(
          // //   height: 260,
          // //   margin: const EdgeInsets.only(top: 50, bottom: 10),
          // //   child: Row(
          // //     children: <Widget>[
          // //       ListView.builder(
          // //         scrollDirection: Axis.horizontal,
          // //         physics: NeverScrollableScrollPhysics(),
          // //         shrinkWrap: true,
          // //         // itemCount: 2,
          // //         itemBuilder: (context, index) {
          // //           return InkWell(
          // //               onTap: () => _navigateToDetail(_data[index].tid,
          // //                   _data[index].user['fullname'], _data[index].title),
          // //               child: (DiscussCardAssistantView(data: _data[index])));
          // //         },
          // //       ),
          // //     ],
          // //   ),
          // // ),
          // FutureBuilder(
          //     future: _trendingDiscussion(),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasData) {
          //         return Container(
          //           height: 260,
          //           width: double.infinity,
          //           margin: const EdgeInsets.only(bottom: 100),
          //           child: ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             // physics: NeverScrollableScrollPhysics(),
          //             shrinkWrap: true,
          //             itemCount: 4,
          //             itemBuilder: (context, index) {
          //               // return DiscussionItem(
          //               //     discussions[index].user,
          //               //     discussions[index].hrs,
          //               //     discussions[index].title,
          //               //     discussions[index].category,
          //               //     discussions[index].tag,
          //               //     discussions[index].votes,
          //               //     discussions[index].comments);
          //               return InkWell(
          //                   onTap: () => _navigateToDetail(
          //                       _data[index].tid,
          //                       _data[index].user['fullname'],
          //                       _data[index].title,
          //                       _data[index].user['uid']),
          //                   child:
          //                       (DiscussCardAssistantView(data: _data[index])));
          //             },
          //           ),
          //         );
          //       } else {
          //         return Center();
          //       }
          //     }),
        ],
      ),
    );
  }

  Widget buildRecentlySearchedList(BuildContext context, int index) {
    final recent = recentlySearchedNames[index];
    return Center(
      child: RecentlySearched(recent),
    );
  }
}
