import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './../../../models/index.dart';
import './../../../respositories/index.dart';
import './../../../constants/index.dart';
import './../../../ui/pages/index.dart';
import './../../../ui/widgets/index.dart';
import './../../../localization/index.dart';

class KnowledgeResourcesScreen extends StatefulWidget {
  static const route = AppUrl.knowledgeResourcesPage;

  @override
  _KnowledgeResourcesScreenState createState() {
    return _KnowledgeResourcesScreenState();
  }
}

class _KnowledgeResourcesScreenState extends State<KnowledgeResourcesScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List tabNames = [EnglishLang.all, EnglishLang.saved];

  List<KnowledgeResource> _knowledgeResources = [];
  String filterPositionId = '';
  String filterPosition = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (filterPositionId == '') {
      await _getKnowledgeResources();
    } else {
      _filerByPositionKnowledgeResource(filterPositionId);
    }
  }

  void setFilter(Map position) {
    // print('setFilter');
    setState(() {
      filterPosition = position['position'];
      filterPositionId = position['id'];
    });
    fetchData();
  }

  Future<List<KnowledgeResource>> _getKnowledgeResources() async {
    try {
      // print('_getKnowledgeResources');
      var knowledgeResources = [];
      knowledgeResources = await Provider.of<KnowledgeResourceRespository>(
              context,
              listen: false)
          .getKnowledgeResources();
      setState(() {
        _knowledgeResources = knowledgeResources;
      });
      return _knowledgeResources;
    } catch (err) {
      return err;
    }
  }

  Future<dynamic> _filerByPositionKnowledgeResource(String id) async {
    try {
      // print('_filerByPositionKnowledgeResource');
      List<KnowledgeResource> knowledgeResources = [];
      knowledgeResources = await Provider.of<KnowledgeResourceRespository>(
              context,
              listen: false)
          .filerByPositionKnowledgeResource(id);
      setState(() {
        _knowledgeResources = knowledgeResources;
      });
      // print(
      //     "Filtered Knowledge Resources" + knowledgeResources.length.toString());
    } catch (err) {
      return err;
    }
    return _knowledgeResources;
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          leading: BackButton(color: AppColors.greys60),
          title: Row(children: [
            Icon(
              Icons.menu_book,
              color: AppColors.greys60,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  EnglishLang.knowledgeResources,
                  style: GoogleFonts.montserrat(
                    color: AppColors.greys87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ))
          ]),
        ),
        // Tab controller
        body: DefaultTabController(
            length: tabNames.length,
            child: SafeArea(
                child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
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
                          for (var tabItem in tabNames)
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              // padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Tab(
                                child: Text(
                                  tabItem,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
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
                child: TabBarView(
                  controller: _controller,
                  children: [
                    AllResourcesPage(
                        knowledgeResources: _knowledgeResources,
                        parentAction: fetchData),
                    SavedResourcesPage(
                        knowledgeResources: _knowledgeResources,
                        parentAction: fetchData),
                  ],
                ),
              ),
            ))),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 60,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryThree,
                  ),
                  height: 40,
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // InkWell(
                      //   onTap: () => {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => MDOFilters(),
                      //       ),
                      //     ),
                      //   },
                      //   child: Container(
                      //       margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      //       padding: const EdgeInsets.only(left: 0, right: 0),
                      //       height: 40,
                      //       child: FilterCard('MDO', 'All')),
                      // ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  KnowledeResourcePositionFilter(
                                selectedId: filterPositionId,
                                selectedPosition: filterPosition,
                                parentAction: setFilter,
                              ),
                            ),
                          ),
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            height: 40,
                            child: FilterCard(
                                EnglishLang.position,
                                filterPosition == ''
                                    ? EnglishLang.allPositions
                                    : filterPosition)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
