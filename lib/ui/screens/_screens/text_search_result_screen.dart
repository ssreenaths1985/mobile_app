import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:provider/provider.dart';
import '../../../models/_models/course_model.dart';
import '../../../respositories/_respositories/learn_repository.dart';
import '../../../respositories/_respositories/network_respository.dart';
import './../../../ui/pages/_pages/ai_assistant_page.dart';
import './../../../ui/widgets/_assistant/assistant_tab.dart';
import './../../pages/index.dart';
import './../../widgets/index.dart';
import './../../../constants/index.dart';

//ignore: must_be_immutable
class TextSearchResultScreen extends StatefulWidget {
  static const route = AppUrl.dashboardPage;
  final String searchKeyword;
  TextSearchResultScreen({Key key, this.searchKeyword}) : super(key: key);

  @override
  TextSearchResultScreenState createState() => TextSearchResultScreenState();
}

class TextSearchResultScreenState extends State<TextSearchResultScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  // var searchActionIcon = Icons.mic_rounded;
  var searchActionIcon =
      VegaConfiguration.isEnabled ? Icons.mic_rounded : Icons.arrow_forward;
  final textController = TextEditingController();
  String _searchKeyword = '';
  List<dynamic> _networks = [];
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: AssistantTab.items.length, vsync: this, initialIndex: 0);
    // _controller.addListener(_setActiveTabIndex);
    if (VegaConfiguration.isEnabled) {
      textController.addListener(_manageSearchActionIcon);
    }
    _searchKeyword = widget.searchKeyword;
    textController.text = widget.searchKeyword;
    _getCourses();
    _getUsersByText();
  }

  void _manageSearchActionIcon() {
    var icon;
    if (textController.text != '') {
      icon = Icons.arrow_forward;
    } else {
      icon = Icons.mic_rounded;
    }

    setState(() {
      searchActionIcon = icon;
      _searchKeyword = textController.text;
    });
  }

  _navigateToSubPage(context) {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TextSearchResultScreen(searchKeyword: textController.text)));
    Future.delayed(Duration(seconds: 1), () {
      FocusManager.instance.primaryFocus.unfocus();
    });
  }

  Future<void> _getCourses() async {
    try {
      _courses = await Provider.of<LearnRepository>(context, listen: false)
          .getCourses(1, widget.searchKeyword, ['course'], [], []);

      setState(() {
        _courses = _courses;
      });
      // return _courses;
    } catch (err) {
      return err;
    }
  }

  Future<List> _getUsersByText() async {
    try {
      _networks = await Provider.of<NetworkRespository>(context, listen: false)
          .getUsersByText(_searchKeyword);
      // _networks = _networks.from(response);
      // developer.log(_networks[0].toString());
    } catch (err) {
      return err;
    }
    return _networks;
  }

  @override
  void dispose() {
    textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tab controller
      body: DefaultTabController(
          length: AssistantTab.items.length,
          child: SafeArea(
              child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    pinned: false,
                    // expandedHeight: 280,
                    flexibleSpace: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _searchKeyword != ''
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        top: 12, right: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: new BoxDecoration(
                                        color: AppColors.primaryThree,
                                        borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(16),
                                            bottomLeft:
                                                const Radius.circular(16),
                                            bottomRight:
                                                const Radius.circular(16))),
                                    child: Text(
                                      _searchKeyword != null
                                          ? _searchKeyword
                                          : '',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : Center(),
                          ],
                        ),
                      ],
                    )),
                SliverPersistentHeader(
                  delegate: SilverAppBarDelegate(
                    TabBar(
                      isScrollable: true,
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primaryThree,
                            width: 2.0,
                          ),
                        ),
                      ),
                      indicatorColor: Colors.white,
                      labelPadding: EdgeInsets.only(top: 0.0),
                      unselectedLabelColor: AppColors.greys60,
                      labelColor: AppColors.primaryThree,
                      labelStyle: GoogleFonts.lato(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.lato(
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                      ),
                      tabs: [
                        for (var tabItem in AssistantTab.items)
                          Container(
                            // width: 85,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Tab(
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  tabItem.title,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                      controller: _controller,
                    ),
                  ),
                  pinned: true,
                  floating: false,
                ),
              ];
            },

            // TabBar view
            body: Container(
              color: AppColors.lightBackground,
              child: FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 500)),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return TabBarView(
                      controller: _controller,
                      children: [
                        AllSearchPage(_searchKeyword, 1, _networks, _courses),
                        NetworkSearchPage(_networks),
                        // AllSearchPage(_searchKeyword, 2),
                        // AllSearchPage(_searchKeyword, 3, _networks, _courses),
                        DiscussSearchPage(),
                        LearnSearchPage(_courses),
                        CareersSearchPage(),
                        // AllSearchPage(_searchKeyword, 4, _networks),
                        // AllSearchPage(_searchKeyword, 5, _networks, _courses),
                        // AllSearchPage(_searchKeyword, 1),
                        // NetworkSearchPage(),
                        // DiscussSearchPage(),
                        // LearnSearchPage(),
                        // CareersSearchPage(),
                      ],
                    );
                  }),
            ),
          ))),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(35, 20, 0, 12),
        child: Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              // MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: Icon(
                          Icons.search,
                          color: AppColors.greys60,
                        )),
                    SizedBox(
                        height: 38,
                        width: MediaQuery.of(context).size.width - 150,
                        child: TextField(
                          autofocus: true,
                          controller: textController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // hintText: textController.text != ''
                            //     ? textController.text
                            //     : 'Ask Vega',
                            hintText: VegaConfiguration.isEnabled
                                ? (textController.text != ''
                                    ? textController.text
                                    : EnglishLang.askVega)
                                : EnglishLang.search,
                          ),
                        )),
                  ],
                ),
                Spacer(),
                Container(
                  // height: 55,
                  width: 46,
                  // margin: const EdgeInsets.only(left: 15),
                  child: FloatingActionButton(
                    // backgroundColor: AppColors.negativeLight,
                    backgroundColor: AppColors.primaryThree,
                    child: Icon(searchActionIcon),
                    onPressed: () {
                      if (searchActionIcon == Icons.mic_rounded) {
                        print('object...');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AiAssistantPage(
                                      searchKeyword: '...',
                                      index: 2,
                                    )));
                      } else {
                        _navigateToSubPage(context);
                      }
                    },
                    heroTag: null,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grey08,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(28)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey08,
                    blurRadius: 6.0,
                    spreadRadius: 0,
                    offset: Offset(
                      3,
                      3,
                    ),
                  ),
                ])),
      ),
    );
  }
}
