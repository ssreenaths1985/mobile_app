import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/respositories/_respositories/profile_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../respositories/index.dart';
import './../../../../services/index.dart';
import './../../../../ui/pages/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../util/faderoute.dart';
import './../../../../constants/_constants/color_constants.dart';

// ignore: must_be_immutable
class BestPostsPage extends StatefulWidget {
  final String wid;

  BestPostsPage(this.wid);

  @override
  _BestPostsPageState createState() => _BestPostsPageState();
}

class _BestPostsPageState extends State<BestPostsPage> {
  final ProfileService profileService = ProfileService();
  List _data = [];

  @override
  void initState() {
    super.initState();
    // print(widget.wid);
  }

  Future<dynamic> _userBestDiscussions(wid) async {
    List<dynamic> response = [];
    List<dynamic> data = [];
    try {
      String userName =
          await Provider.of<ProfileRepository>(context, listen: false)
              .getUserName(wid);
      response = await Provider.of<DiscussRepository>(context, listen: false)
          .getUserBestDiscussions(userName);
      List<int> tids = [];
      for (int i = 0; i < response.length; i++) {
        if (!tids.contains(response[i].tid)) {
          data.add(response[i]);
        }
        tids.add(response[i].tid);
      }
    } catch (err) {
      return err;
    }
    return data;
  }

  /// Navigate to discussion detail
  _navigateToDetail(tid, userName, title, uid) {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: _userBestDiscussions(widget.wid),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              _data = snapshot.data;
              return Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Container(
                    height: 5.0,
                  ),
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
                                    ? DiscussCardView(
                                        data: _data[i],
                                      )
                                    : Center(
                                        child: Text(''),
                                      ),
                              ),
                          ],
                        ),
                      ),
                      _data.length == 0
                          ? Container(
                              padding: const EdgeInsets.only(top: 100),
                              child: Center(
                                  child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/discussion-empty.svg',
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        'No posts',
                                        style: GoogleFonts.lato(
                                          color: AppColors.greys60,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      )),
                                ],
                              )))
                          : Center()
                    ],
                  ),
                ],
              );
            } else {
              return PageLoader();
            }
          }),
    );
  }
}
