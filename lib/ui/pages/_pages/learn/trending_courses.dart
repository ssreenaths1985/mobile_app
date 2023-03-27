import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
import 'package:karmayogi_mobile/services/_services/learn_service.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/_models/provider_model.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/filter/course_filters.dart';
import 'package:provider/provider.dart';
import '../text_search_results/text_search_page.dart';
import './../../../../constants/index.dart';

// ignore: must_be_immutable
class TrendingCoursesPage extends StatefulWidget {
  String selectedContentType;
  final bool isProgram;
  TrendingCoursesPage(
      {Key key, this.selectedContentType = 'course', this.isProgram = false});

  @override
  _TrendingCoursesPageState createState() => _TrendingCoursesPageState();
}

class _TrendingCoursesPageState extends State<TrendingCoursesPage> {
  final service = HttpClient();
  final LearnService learnService = LearnService();
  int pageNo = 1;
  int pageCount;
  int currentPage;

  List _data = [];
  RouteSettings settings;

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.trendingCourses,
    EnglishLang.recentCourses
  ];

  List contentTypes = [
    EnglishLang.program,
    EnglishLang.course,
    // EnglishLang.learningResource,
  ];

  List resourceTypes = [
    EnglishLang.interactiveContent,
    EnglishLang.image,
    EnglishLang.webpage,
    EnglishLang.assessment,
    EnglishLang.pdf,
    EnglishLang.course,
    EnglishLang.video,
    EnglishLang.audio
  ];

  List providers = [];
  List<ProviderCardModel> _providersList = [];

  List<String> selectedContentTypes = ['course'];
  List<String> selectedResourceTypes = [];
  List<String> actualResourceTypes = [];
  List<String> selectedProviders = [];
  Map resourceTypeMapping = {
    EnglishLang.interactiveContent: [
      'application/vnd.ekstep.html-archive',
      'application/vnd.ekstep.ecml-archive'
    ],
    EnglishLang.image: ['image/jpeg', 'image/png'],
    EnglishLang.webpage: ['text/x-url'],
    EnglishLang.assessment: ['application/json', 'application/quiz'],
    EnglishLang.pdf: ['application/pdf'],
    EnglishLang.course: ['application/vnd.ekstep.content-collection'],
    EnglishLang.video: [
      'video/mp4',
      'video/x-youtube',
      'application/x-mpegURL'
    ],
    EnglishLang.audio: ['audio/mpeg'],
  };

  bool _showLoader = true;

  @override
  void initState() {
    super.initState();
    _getTrendingCourses();
    _getPageDetails();
    _getListOfProviders();
    setState(() {
      dropdownValue = EnglishLang.trendingCourses;
    });
    if (widget.isProgram) {
      setState(() {
        selectedContentTypes = ['program'];
      });
    }
  }

  Future<List<ProviderCardModel>> _getListOfProviders() async {
    _providersList = await Provider.of<LearnRepository>(context, listen: false)
        .getListOfProviders();

    for (var provider in _providersList) {
      providers.add(provider.name);
    }
    providers.removeWhere((value) => value == null);
    return _providersList;
  }

  /// Get recent discussions
  Future<dynamic> _getTrendingCourses() async {
    try {
      // if (pageNo == 1) {
      //   setState(() {
      //     _data = [];
      //   });
      // }
      _data.addAll(await Provider.of<LearnRepository>(context, listen: false)
          .getCourses(pageNo, '', selectedContentTypes, actualResourceTypes,
              selectedProviders));

      // setState(() {
      _data = _data.toSet().toList();
      _showLoader = false;
      // });
      return _data;
    } catch (err) {
      return err;
    }
  }

  /// Get pageDetails
  Future<void> _getPageDetails() async {
    int pageNos;
    try {
      pageNos = await learnService.getTotalCoursePages();
      setState(() {
        pageCount = pageNos;
      });
    } catch (err) {
      return err;
    }
  }

  void updateFilters(Map data) async {
    setState(() {
      pageNo = 1;
      _data = [];
      _showLoader = true;
    });
    switch (data['filter']) {
      case EnglishLang.contentType:
        if (selectedContentTypes.contains(data['item'].toLowerCase()))
          selectedContentTypes.remove(data['item'].toLowerCase());
        else
          selectedContentTypes.add(data['item'].toLowerCase());
        break;
      case EnglishLang.resourceType:
        if (selectedResourceTypes.contains(data['item']))
          selectedResourceTypes.remove(data['item']);
        else
          selectedResourceTypes.add(data['item']);
        actualResourceTypes = [];
        for (var resource in selectedResourceTypes) {
          actualResourceTypes.addAll(resourceTypeMapping[resource]);
        }
        break;
      default:
        // if (!selectedProviders.contains(data['item'].toLowerCase()) &&
        //     selectedProviders.length > 0)
        //   selectedProviders.remove(selectedProviders[0]);
        if (selectedProviders.contains(data['item'].toLowerCase()))
          selectedProviders.remove(data['item'].toLowerCase());
        else
          selectedProviders.add(data['item'].toLowerCase());
        break;
    }
    // print("content types: " + selectedContentTypes.toString());
    // print("resource type: " + selectedResourceTypes.toString());
    // print("providers: " + selectedProviders.toString());
    _getTrendingCourses();
  }

  Future<void> setDefault(String filter) async {
    setState(() {
      pageNo = 1;
      _data = [];
      _showLoader = true;
    });
    switch (filter) {
      case EnglishLang.contentType:
        setState(() {
          selectedContentTypes = [];
          // _data = [];
        });

        break;
      case EnglishLang.resourceType:
        setState(() {
          selectedResourceTypes = [];
        });
        break;
      default:
        setState(() {
          selectedProviders = [];
        });
    }
    _getTrendingCourses();

    setState(() {});
  }

  // Future<bool> _displaySortOptions() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => Stack(
  //             children: [
  //               Positioned(
  //                   child: Align(
  //                       // alignment: FractionalOffset.center,
  //                       alignment: FractionalOffset.bottomCenter,
  //                       child: Container(
  //                           padding: EdgeInsets.all(20),
  //                           // margin: EdgeInsets.only(left: 20, right: 20),
  //                           width: double.infinity,
  //                           height: 170.0,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.only(
  //                                 topLeft: Radius.circular(12.0),
  //                                 topRight: Radius.circular(12.0)),
  //                             color: Colors.white,
  //                           ),
  //                           child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 for (int i = 0; i < dropdownItems.length; i++)
  //                                   GestureDetector(
  //                                     onTap: () {
  //                                       setState(() {
  //                                         dropdownValue = dropdownItems[i];
  //                                       });
  //                                       Navigator.of(context).pop(false);
  //                                     },
  //                                     child: Container(
  //                                       padding: const EdgeInsets.all(16),
  //                                       width:
  //                                           MediaQuery.of(context).size.width -
  //                                               40,
  //                                       decoration: BoxDecoration(
  //                                         color:
  //                                             dropdownItems[i] == dropdownValue
  //                                                 ? AppColors.selectedTile
  //                                                 : Colors.white,
  //                                         borderRadius: BorderRadius.all(
  //                                             const Radius.circular(4.0)),
  //                                       ),
  //                                       child: Text(
  //                                         dropdownItems[i],
  //                                         style: GoogleFonts.montserrat(
  //                                             decoration: TextDecoration.none,
  //                                             color: Colors.black87,
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.w400),
  //                                       ),
  //                                     ),
  //                                   ),
  //                               ]))))
  //             ],
  //           ));
  // }

  /// Load cards on scroll
  _loadMore() {
    if (pageNo < pageCount) {
      setState(() {
        pageNo = pageNo + 1;
      });
      _getTrendingCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          // leading: IconButton(
          //   icon: Icon(Icons.clear, color: AppColors.greys60),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          title: Row(
            children: [
              Text(
                widget.isProgram != true
                    ? EnglishLang.allRecentlyAddedCBPs
                    : EnglishLang.allPrograms,
                style: GoogleFonts.montserrat(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppColors.greys60,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TextSearchPage()));
                    }),
              ),
            ],
          ),
        ),
        body: NotificationListener<ScrollNotification>(
          // ignore: missing_return
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _loadMore();
            }
          },
          child: SingleChildScrollView(
            // scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: _getTrendingCourses(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if ((snapshot.hasData && snapshot.data != null) &&
                    !_showLoader) {
                  // print('Loading cards...' + _showLoader.toString());

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Container(
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.all(15),
                      //   margin: EdgeInsets.only(right: 200, top: 2),
                      //   child: InkWell(
                      //       onTap: () => _displaySortOptions(),
                      //       child: Row(
                      //         children: [
                      //           Text(dropdownValue,
                      //               style: GoogleFonts.lato(
                      //                 color: AppColors.greys60,
                      //                 fontWeight: FontWeight.w700,
                      //                 fontSize: 14,
                      //                 letterSpacing: 0.12,
                      //               )),
                      //           Icon(
                      //             Icons.arrow_drop_down,
                      //             size: 30,
                      //             color: AppColors.greys60,
                      //           )
                      //         ],
                      //       )),
                      // ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8),
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          // shrinkWrap: true,
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: BrowseCourseCard(
                                course: _data[index],
                                isProgram:
                                    widget.selectedContentType == 'program'
                                        ? true
                                        : false,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (_data.length == 0) {
                  return Stack(
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                EnglishLang.noFilterResultInfo,
                                style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 1.5,
                                  letterSpacing: 0.25,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  return PageLoader(
                    bottom: 150,
                  );
                }
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            // height: _activeTabIndex == 0 ? 60 : 0,
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
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseFilters(
                                filterName: EnglishLang.contentType,
                                items: contentTypes,
                                selectedItems: selectedContentTypes,
                                parentAction1: updateFilters,
                                parentAction2: setDefault,
                              ),
                            ),
                          ),
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            height: 40,
                            child: FilterCard(
                                EnglishLang.contentType,
                                selectedContentTypes.length == 1
                                    ? selectedContentTypes[0].toUpperCase()
                                    : selectedContentTypes.length == 0
                                        ? EnglishLang.all
                                        : (selectedResourceTypes.length == 0
                                            ? EnglishLang.all
                                            : EnglishLang.multipleSelected))),
                      ),
                      // InkWell(
                      //   onTap: () => {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => CourseFilters(
                      //           filterName: EnglishLang.resourceType,
                      //           items: resourceTypes,
                      //           selectedItems: selectedResourceTypes,
                      //           parentAction1: updateFilters,
                      //           parentAction2: setDefault,
                      //         ),
                      //       ),
                      //     ),
                      //   },
                      //   child: Container(
                      //       margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      //       padding: const EdgeInsets.only(left: 10, right: 10),
                      //       height: 40,
                      //       child: FilterCard(
                      //           EnglishLang.resourceType,
                      //           selectedResourceTypes.length == 1
                      //               ? selectedResourceTypes[0].toUpperCase()
                      //               : (selectedResourceTypes.length == 0
                      //                   ? EnglishLang.all
                      //                   : EnglishLang.multipleSelected))),
                      // ),
                      InkWell(
                          onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseFilters(
                                      filterName: EnglishLang.providers,
                                      items: providers,
                                      selectedItems: selectedProviders,
                                      parentAction1: updateFilters,
                                      parentAction2: setDefault,
                                    ),
                                  ),
                                ),
                              },
                          child: Container(
                              margin: const EdgeInsets.fromLTRB(8, 10, 0, 10),
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              height: 40,
                              child: FilterCard(
                                  EnglishLang.providers,
                                  selectedProviders.length == 1
                                      ? selectedProviders[0].toUpperCase()
                                      : (selectedProviders.length == 0
                                          ? EnglishLang.all
                                          : EnglishLang.multipleSelected)))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
