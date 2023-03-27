import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import './../../../../respositories/index.dart';
import './../../../../util/faderoute.dart';
import './../../../pages/index.dart';
import './../../../../services/index.dart';
import './../../../../constants/index.dart';
import './../../../../localization/index.dart';

class ReplyToCommentPage extends StatefulWidget {
  static const route = AppUrl.profilePage;
  final int tid;
  final int pid;
  final String userName;
  final String title;
  final int uid;

  ReplyToCommentPage(
      {Key key, this.tid, this.pid = 0, this.userName, this.title, this.uid})
      : super(key: key);
  @override
  ReplyToCommentPageState createState() {
    return ReplyToCommentPageState();
  }
}

class ReplyToCommentPageState extends State<ReplyToCommentPage> {
  final ProfileService profileService = ProfileService();
  final textController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveComment(context, tid) async {
    var response;
    try {
      // print('_reply posted: ' + tid.toString());
      String content = textController.text;
      if (content.length >= 8) {
        if (widget.pid == 0) {
          // print('Hello');
          response =
              await Provider.of<DiscussRepository>(context, listen: false)
                  .replyDiscussion(tid, content);
        } else {
          // print('Bye');
          response =
              await Provider.of<DiscussRepository>(context, listen: false)
                  .replyComment(widget.pid, tid, content);
        }
        // print(response);
        if (response == 'ok') {
          // _discussionByTid(context, tid);
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            FadeRoute(
              page: DiscussionPage(
                  tid: tid,
                  userName: widget.userName,
                  title: widget.title,
                  uid: widget.uid),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(EnglishLang.commentPostedText),
              backgroundColor: AppColors.positiveLight,
            ),
          );
          // setState(() {});
        }
      } else {
        final snackBar = SnackBar(
          content: Text(
            EnglishLang.postMinLengthText,
          ),
          backgroundColor: AppColors.positiveLight,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      return err;
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: AppColors.greys60),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.pid == 0
                ? EnglishLang.addComment
                : EnglishLang.replyToComment,
            style: GoogleFonts.montserrat(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: AppColors.grey08,
              blurRadius: 6.0,
              spreadRadius: 0,
              offset: Offset(
                0,
                -3,
              ),
            ),
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _saveComment(context, widget.tid);
                },
                style: TextButton.styleFrom(
                  // primary: Colors.white,
                  backgroundColor: AppColors.customBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: AppColors.grey16)),
                  // onSurface: Colors.grey,
                ),
                // padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: Text(
                  'Post',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(bottom: 100),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: AppColors.lightGrey,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.pid == 0
                              ? Text(
                                  widget.userName != null
                                      ? widget.userName
                                      : '',
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontSize: 14.0,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text(
                                    widget.userName != null
                                        ? widget.userName
                                        : '',
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 14.0,
                                    ),
                                  )),
                          Padding(
                            // height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.only(top: 10),
                            child: widget.pid == 0
                                ? HtmlWidget(widget.title,
                                    textStyle: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14.0,
                                    ))
                                : HtmlWidget(widget.title,
                                    textStyle: TextStyle(
                                      fontFamily: 'lato',
                                      // padding: EdgeInsets.all(0),
                                      // margin: EdgeInsets.only(left: 0),
                                      wordSpacing: 1.0,
                                      color: AppColors.greys87,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        controller: textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: EnglishLang.replyMinLengthText,
                        ),
                        onTap: () {
                          // _saveComment(context, widget.tid);
                        },
                      ),
                    ),
                  ],
                ))));
  }
}
