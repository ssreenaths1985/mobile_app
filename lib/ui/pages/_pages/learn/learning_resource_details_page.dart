import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:photo_view/photo_view.dart';

import '../../../../constants/_constants/app_constants.dart';
import '../../../../constants/_constants/color_constants.dart';
import '../../../../services/_services/learn_service.dart';
import '../../../widgets/_learn/_contentPlayers/course_assessment_player.dart';
import '../../../widgets/_learn/_contentPlayers/course_audio_player.dart';
import '../../../widgets/_learn/_contentPlayers/course_html_player.dart';
import '../../../widgets/_learn/_contentPlayers/course_pdf_player.dart';
import '../../../widgets/_learn/_contentPlayers/course_video_player.dart';
import '../../../widgets/_learn/_contentPlayers/course_youtube_player.dart';

class LearningResourceDetailsPage extends StatefulWidget {
  final resource;
  const LearningResourceDetailsPage({Key key, this.resource}) : super(key: key);

  @override
  State<LearningResourceDetailsPage> createState() =>
      _LearningResourceDetailsPageState();
}

class _LearningResourceDetailsPageState
    extends State<LearningResourceDetailsPage> {
  final LearnService learnService = LearnService();
  Map navigationItem;
  bool _fullScreen = false;
  String _batchId;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    // print('Hello');
    // print(widget.resource.raw.toString());
    _generateNavigation();
  }

  void manageScreen(bool fullScreen) {
    setState(() {
      _fullScreen = fullScreen;
    });
  }

  void getBatchId() async {
    var batchDetails =
        await learnService.autoEnrollBatch(widget.resource['identifier']);
    // print('batchDetails $batchDetails');
    _batchId = batchDetails['batchId'];
  }

  void _generateNavigation() {
    if (widget.resource != null) {
      navigationItem = {
        'mimeType': widget.resource['mimeType'],
        'identifier': widget.resource['identifier'],
        'name': widget.resource['name'],
        'artifactUrl': widget.resource['artifactUrl'],
        'description': widget.resource['description'],
        'duration': widget.resource['duration'],
        'creator': widget.resource['creator'],
        'creatorContacts': widget.resource['creatorContacts'],
        'source': widget.resource['source']
      };
    }
  }

  void updateContentProgress(Map data) {
    // print("I'm in navigation page $data");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // print(navigationItem['mimeType']);
    // print(navigationItem['artifactUrl']);
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        duration: Duration(milliseconds: 0),
        child: SafeArea(
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  if (navigationItem['mimeType'] != EMimeTypes.assessment)
                    (SliverAppBar(
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding:
                            EdgeInsets.fromLTRB(60.0, 0.0, 10.0, 15.0),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.supervisor_account,
                              color: AppColors.primaryThree,
                            ),
                            // SvgPicture.asset(
                            //   'assets/img/Careers.svg',
                            //   width: 24.0,
                            //   height: 24.0,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 13.0, top: 3.0),
                              child: Text(
                                widget.resource['name'],
                                style: GoogleFonts.montserrat(
                                  color: AppColors.greys87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                ];
              },
              body: Container(
                height: 250,
                // ? MediaQuery.of(context).size.height - 100
                // : 250,
                // height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5.0),
                child: (navigationItem['mimeType'] == EMimeTypes.mp4 ||
                        navigationItem['mimeType'] == EMimeTypes.m3u8)
                    ? CourseVideoPlayer(
                        course: widget.resource,
                        identifier: navigationItem['identifier'],
                        fileUrl: navigationItem['artifactUrl'],
                        mimeType: navigationItem['mimeType'],
                        updateProgress: true,
                        currentProgress: 0,
                        status: navigationItem['status'],
                        // batchId: widget.batchId,
                      )
                    : navigationItem['mimeType'] == EMimeTypes.mp3
                        ? CourseAudioPlayer(
                            identifier: navigationItem['identifier'],
                            fileUrl: navigationItem['artifactUrl'],
                            batchId: _batchId,
                            course: widget.resource,
                            status: navigationItem['status'],
                            parentAction: updateContentProgress,
                          )
                        : navigationItem['mimeType'] == EMimeTypes.pdf
                            ? CoursePdfPlayer(
                                course: widget.resource,
                                identifier: navigationItem['identifier'],
                                fileUrl: navigationItem['artifactUrl'],
                                currentProgress: 0.toString(),
                                status: 0,
                                batchId: _batchId,
                                parentAction1: manageScreen,
                                parentAction2: updateContentProgress,
                              )
                            : navigationItem['mimeType'] == EMimeTypes.html
                                ? CourseHtmlPlayer(
                                    widget.resource,
                                    navigationItem['identifier'],
                                    navigationItem['artifactUrl'],
                                    _batchId,
                                    manageScreen,
                                    updateContentProgress,
                                    isLearningResource: true,
                                  )
                                : (navigationItem['mimeType'] ==
                                            EMimeTypes.externalLink ||
                                        navigationItem['mimeType'] ==
                                            EMimeTypes.youtubeLink)
                                    ? CourseYoutubePlayer(
                                        widget.resource,
                                        navigationItem['identifier'],
                                        navigationItem['artifactUrl'],
                                        0,
                                        0,
                                        _batchId,
                                        navigationItem['mimeType'])
                                    : (navigationItem['mimeType'] ==
                                            EMimeTypes.assessment)
                                        ? CourseAssessmentPlayer(
                                            widget.resource,
                                            navigationItem['name'],
                                            navigationItem['identifier'],
                                            navigationItem['artifactUrl'],
                                            updateContentProgress,
                                            '',
                                            navigationItem['duration'])
                                        : Container(
                                            //   child: PhotoView(
                                            //   imageProvider: NetworkImage(
                                            //       navigationItem['artifactUrl']),
                                            //   backgroundDecoration: BoxDecoration(
                                            //       color: Colors.white),
                                            // )
                                            child: Center(),
                                          )
                // Center(
                //     child: Text(
                //     'Tap on assessment to start',
                //     style: GoogleFonts.lato(
                //         height: 1.5,
                //         color: AppColors.greys87,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w400),
                //   ))
                ,
              )),
        ),
      ),
    );
  }
}
