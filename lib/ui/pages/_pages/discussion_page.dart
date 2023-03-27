import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:karmayogi_mobile/respositories/_respositories/discuss_repository.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:karmayogi_mobile/util/telemetry.dart';
import 'package:provider/provider.dart';
// import 'package:karmayogi_mobile/util/helper.dart';
import './../../../ui/pages/index.dart';
import './../../../util/faderouteBottomUp.dart';
import '../../widgets/_discussion/detailed_view.dart';
import '../../../constants/index.dart';
import './../../../localization/index.dart';

class DiscussionPage extends StatefulWidget {
  final int tid;
  final String userName;
  final String title;
  final String backToTitle;
  final int uid;

  const DiscussionPage(
      {Key key,
      this.tid,
      this.userName,
      this.title,
      this.backToTitle = '',
      this.uid})
      : super(key: key);

  static const route = AppUrl.discussionsPage;

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  List<String> dropdownItems = [
    EnglishLang.deleteDiscussion,
    EnglishLang.editDiscussion
  ];
  String _uid;

  @override
  void initState() {
    super.initState();
    // print('IDS: ${widget.uid}');
    getUserNodeBbUid();
  }

  void getUserNodeBbUid() async {
    String uid = await Telemetry.getUserNodeBbUid();
    setState(() {
      _uid = uid;
    });
  }

  Future<void> _deleteDiscussion(context) async {
    var response;
    try {
      response = await Provider.of<DiscussRepository>(context, listen: false)
          .deleteDiscussion(widget.tid);
      // print(response.toString());
      if (response == 'ok') {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, AppUrl.discussionHub);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.discussionDeletedText),
            backgroundColor: AppColors.positiveLight,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EnglishLang.errorMessage),
            backgroundColor: AppColors.negativeLight,
          ),
        );
      }
    } catch (err) {
      return err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.greys60),
          // elevation: 0,
          titleSpacing: 0,
          actions: <Widget>[
            // IconButton(
            //     icon: Icon(
            //       Icons.bookmark,
            //       color: AppColors.grey16,
            //     ),
            //     onPressed: () {}),
            _uid == widget.uid.toString()
                ? Container(
                    // width: double.infinity,
                    margin: EdgeInsets.only(right: 10),
                    child: DropdownButton<String>(
                      value: null,
                      icon: Icon(Icons.more_vert),
                      iconSize: 26,
                      elevation: 16,
                      style: TextStyle(color: AppColors.greys87),
                      underline: Container(
                        // height: 2,
                        color: AppColors.lightGrey,
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return dropdownItems.map<Widget>((String item) {
                          return Row(
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(15.0, 15.0, 0, 15.0),
                                  child: Text(
                                    item,
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ))
                            ],
                          );
                        }).toList();
                      },
                      onChanged: (String newValue) {
                        if (newValue == EnglishLang.deleteDiscussion) {
                          _deleteDiscussion(context);
                        } else {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: NewDiscussionPage(tid: widget.tid),
                            ),
                          );
                        }
                      },
                      items: dropdownItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                : Center(),
          ],
          title: Text(
            widget.backToTitle,
            style: GoogleFonts.lato(
                color: AppColors.greys60,
                wordSpacing: 1.0,
                fontSize: 16.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
            color: AppColors.lightBackground,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailedView(
                      tid: widget.tid, backToTitle: widget.backToTitle),
                ],
              ),
            )),
        bottomNavigationBar: InkWell(
            onTap: () => {
                  Navigator.push(
                    context,
                    FadeRouteBottomUp(
                        page: ReplyToCommentPage(
                      tid: widget.tid,
                      userName: widget.userName,
                      title: widget.title,
                      uid: widget.uid,
                    )),
                  )
                },
            child: BottomAppBar(
              child: Container(
                height: 60,
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
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.only(left: 10),
                      child: SvgPicture.asset(
                        'assets/img/reply.svg',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        EnglishLang.addComment,
                        style: GoogleFonts.lato(
                          color: AppColors.greys60,
                          wordSpacing: 1.0,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
