import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';
import './../../../widgets/index.dart';

class CourseVideo extends StatefulWidget {
  final String identifier;
  final String fileUrl;
  CourseVideo(this.identifier, this.fileUrl);
  @override
  _CourseVideoState createState() => _CourseVideoState();
}

class _CourseVideoState extends State<CourseVideo> {
  VideoPlayerController _videoPlayerController1;
  // VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    // _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.fileUrl);
    // _videoPlayerController2 = VideoPlayerController.network(
    //     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      _videoPlayerController1.initialize(),
      // _videoPlayerController2.initialize()
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: AppColors.greys60),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Video player',
            style: GoogleFonts.montserrat(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null
                  ? Chewie(
                      controller: _chewieController,
                    )
                  : PageLoader(),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     _chewieController.enterFullScreen();
          //   },
          //   child: const Text('Full screen'),
          // ),
          Row(
            children: <Widget>[
              // Expanded(
              //   child: TextButton(
              //     onPressed: () {
              //       setState(() {
              //         _chewieController.dispose();
              //         _videoPlayerController1.pause();
              //         _videoPlayerController1.seekTo(const Duration());
              //         _chewieController = ChewieController(
              //           videoPlayerController: _videoPlayerController1,
              //           autoPlay: true,
              //           looping: true,
              //         );
              //       });
              //     },
              //     child: const Padding(
              //       padding: EdgeInsets.symmetric(vertical: 16.0),
              //       child: Text("Landscape Video"),
              //     ),
              //   ),
              // ),
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _chewieController.dispose();
              //             _videoPlayerController2.pause();
              //             _videoPlayerController2.seekTo(const Duration());
              //             _chewieController = ChewieController(
              //               videoPlayerController: _videoPlayerController2,
              //               autoPlay: true,
              //               looping: true,
              //             );
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("Portrait Video"),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _platform = TargetPlatform.android;
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("Android controls"),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _platform = TargetPlatform.iOS;
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("iOS controls"),
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ]));
  }
}
