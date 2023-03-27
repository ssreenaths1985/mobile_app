import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/learn_repository.dart';
// import 'package:karmayogi_mobile/ui/pages/index.dart';
// import 'package:karmayogi_mobile/ui/widgets/filter_card.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:provider/provider.dart';
// import './../../../../constants/index.dart';
// import './../../../widgets/index.dart';
// import './../../../../services/index.dart';

class DesiredCompetenciesPage extends StatefulWidget {
  @override
  _DesiredCompetenciesPageState createState() =>
      _DesiredCompetenciesPageState();
}

class _DesiredCompetenciesPageState extends State<DesiredCompetenciesPage> {
  List<BrowseCompetencyCardModel> _listOfCompetencies = [];
  List<BrowseCompetencyCardModel> _filteredListOfCompetencies = [];

  List courses = [
    'Course 1',
    'Course 2',
    'Course 3',
    'Course 4',
    'Course 5',
  ];
  List subjects = [
    'Subject 1',
    'Subject 2',
    'Subject 3',
    'Subject 4',
    'Subject 5',
  ];
  List selectedCourses = [];
  List selectedSubjects = [];

  bool _pageInitilized = false;
  // bool _showLoader = true;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getListOfCompetencies() async {
    if (!_pageInitilized) {
      _listOfCompetencies =
          await Provider.of<LearnRepository>(context, listen: false)
              .getListOfCompetencies(context);

      setState(() {
        _filteredListOfCompetencies = _listOfCompetencies;
        _pageInitilized = true;
        // _showLoader = false;
      });
    }

    // listOfCompetencies = await courseService.getCompetenciesList();
    // print({'Browse by competencies page $_listOfCompetencies'});
    return _listOfCompetencies;
  }

  void filterCompetencies(value) {
    setState(() {
      _filteredListOfCompetencies = _listOfCompetencies
          .where((competency) => competency.name.toLowerCase().contains(value))
          .toList();
    });
  }

  void updateFilters(Map data) {
    switch (data['filter']) {
      case EnglishLang.type:
        if (selectedCourses.contains(data['item'].toLowerCase()))
          selectedCourses.remove(data['item'].toLowerCase());
        else
          selectedCourses.add(data['item'].toLowerCase());
        break;

      default:
        if (selectedSubjects.contains(data['item'].toLowerCase()))
          selectedSubjects.remove(data['item'].toLowerCase());
        else
          selectedSubjects.add(data['item'].toLowerCase());
        break;
    }
    setState(() {});
  }

  void setDefault(String filter) {
    switch (filter) {
      case EnglishLang.type:
        selectedCourses = [];
        break;
      default:
        selectedSubjects = [];
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: FutureBuilder(
          future: _getListOfCompetencies(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              // print('Loading cards...' + _showLoader.toString());

              return Container(
                // color: Color.fromRGBO(241, 244, 244, 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 0, bottom: 10),
                      child: Container(
                        // color: Colors.white,
                        width: double.infinity,
                        height: 117,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                EnglishLang.desiredCompetencies,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.12,
                                    height: 1.5),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      // width: 316,
                                      height: 48,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            filterCompetencies(value);
                                          },
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          style:
                                              GoogleFonts.lato(fontSize: 14.0),
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.search),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                16.0, 10.0, 0.0, 10.0),
                                            // border: OutlineInputBorder(
                                            //     borderSide: BorderSide(
                                            //         color: AppColors
                                            //             .primaryThree, width: 10),),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              borderSide: BorderSide(
                                                color: AppColors.grey16,
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              borderSide: BorderSide(
                                                color: AppColors.primaryThree,
                                              ),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.lato(
                                                color: AppColors.greys60,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400),
                                            // focusedBorder: OutlineInputBorder(
                                            //   borderSide: const BorderSide(
                                            //       color: AppColors.primaryThree, width: 1.0),
                                            // ),
                                            counterStyle: TextStyle(
                                              height: double.minPositive,
                                            ),
                                            counterText: '',
                                          )),
                                    ),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(4.0)),
                                        border:
                                            Border.all(color: AppColors.grey16),
                                      ),
                                      child: Icon(
                                        Icons.filter_list,
                                        color: AppColors.greys60,
                                        size: 24,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _listOfCompetencies.length > 1
                        ? Container(
                            // height: 100,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _filteredListOfCompetencies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: BrowseCompetencyCard(
                                      browseCompetencyCardModel:
                                          _filteredListOfCompetencies[index],
                                      isCompetencyDetails: true),
                                );
                              },
                            ),
                          )
                        : Text("No competencies found"),
                    // BrowseCompetencyCard(_listOfCompetencies)
                    // HubPage(),
                  ],
                ),
              );
            } else {
              return PageLoader(
                bottom: 200,
              );
            }
          },
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     // height: _activeTabIndex == 0 ? 60 : 0,
      //     height: 60,
      //     child: Row(
      //       children: [
      //         Container(
      //           margin: const EdgeInsets.all(10),
      //           child: IconButton(
      //               icon: Icon(
      //                 Icons.filter_list,
      //                 color: Colors.white,
      //               ),
      //               onPressed: () {}),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(8),
      //             color: AppColors.primaryThree,
      //           ),
      //           height: 40,
      //         ),
      //         Expanded(
      //           child: ListView(
      //             scrollDirection: Axis.horizontal,
      //             shrinkWrap: true,
      //             // mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               InkWell(
      //                 onTap: () => {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => CompetencyFilters(
      //                         filterName: EnglishLang.type,
      //                         items: courses,
      //                         selectedItems: selectedCourses,
      //                         parentAction1: updateFilters,
      //                         parentAction2: setDefault,
      //                       ),
      //                     ),
      //                   ),
      //                 },
      //                 child: Container(
      //                     margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      //                     padding: const EdgeInsets.only(left: 0, right: 0),
      //                     height: 40,
      //                     child: FilterCard(
      //                         EnglishLang.type, EnglishLang.allCourses)),
      //               ),
      //               InkWell(
      //                 onTap: () => {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => CompetencyFilters(
      //                         filterName: EnglishLang.subject,
      //                         items: subjects,
      //                         selectedItems: selectedSubjects,
      //                         parentAction1: updateFilters,
      //                         parentAction2: setDefault,
      //                       ),
      //                     ),
      //                   ),
      //                 },
      //                 child: Container(
      //                     margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      //                     padding: const EdgeInsets.only(left: 10, right: 10),
      //                     height: 40,
      //                     child: FilterCard(
      //                         EnglishLang.subject, EnglishLang.allSubjects)),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // )
    );
  }
}
