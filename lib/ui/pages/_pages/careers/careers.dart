import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/feedback/widgets/_microSurvey/page_loader.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/models/_models/career_opening_model.dart';
import 'package:karmayogi_mobile/respositories/_respositories/career_repository.dart';
import 'package:karmayogi_mobile/services/_services/career_opening_service.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/career_card_view.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/career_detailed_view.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import 'package:provider/provider.dart';

class CareersPage extends StatefulWidget {
  static const route = '/careersPage';

  @override
  _CareersPageState createState() => _CareersPageState();
}

class _CareersPageState extends State<CareersPage> {
  String _dropdownValue = EnglishLang.recent;
  final CareerOpeningService careerService = CareerOpeningService();
  List<CareerOpening> _careerOpenings = [];
  List<CareerOpening> _filteredCareerOpenings = [];
  List<CareerOpening> _sortedCareerOpenings = [];
  bool _pageInitilized = false;
  int pageNo = 1;
  int pageCount;

  List<String> dropdownItems = [EnglishLang.recent, EnglishLang.mostViewed];

  @override
  void initState() {
    super.initState();
    // if (_isMostViewed) {
    //   setState(() {
    //     _dropdownValue = EnglishLang.mostViewed;
    //   });
    // } else {
    //   setState(() {
    //     _dropdownValue = EnglishLang.recent;
    //   });
    // }
    _getCareers();
    _getPageDetails();
    // if (_start == 0) {
    //   allEventsData = [];
    //   _generateTelemetryData();
    // }
  }

  Future<List<CareerOpening>> _getCareers() async {
    if (!_pageInitilized) {
      if (pageNo == 1) {
        _careerOpenings =
            await Provider.of<CareerRepository>(context, listen: false)
                .getCareerOpenings(pageNo);
      } else {
        _careerOpenings.addAll(
            await Provider.of<CareerRepository>(context, listen: false)
                .getCareerOpenings(pageNo));
      }

      _sortedCareerOpenings = _careerOpenings;

      setState(() {
        _filteredCareerOpenings = _sortedCareerOpenings;
        _pageInitilized = true;
      });
    }

    if (_dropdownValue == EnglishLang.recent) {
      _sortedCareerOpenings.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    } else {
      _sortedCareerOpenings.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    }

    return _sortedCareerOpenings;
  }

  Future<void> _getPageDetails() async {
    var pageDetails;

    pageDetails = await Provider.of<CareerRepository>(context, listen: false)
        .getCareerPageCount(pageNo);

    setState(() {
      pageCount = pageDetails.pageCount;
    });
  }

  _navigateToDetail(careerTitle, description, views, postedTime, tags) {
    // _generateInteractTelemetryData(tid.toString());

    Navigator.push(
        context,
        FadeRoute(
            page: ChangeNotifierProvider<CareerRepository>(
                create: (context) => CareerRepository(),
                child: CareerDetailedView(
                  title: careerTitle,
                  description: description,
                  viewCount: views,
                  postedTime: postedTime,
                  tags: tags,
                ))));
  }

  void filterCareer(value) {
    setState(() {
      _filteredCareerOpenings = _sortedCareerOpenings
          .where((career) => career.title.toLowerCase().contains(value))
          .toList();
    });
  }

  /// Load cards on scroll
  _loadMore() {
    setState(() {
      if (pageNo < pageCount) {
        pageNo = pageNo + 1;
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMore();
          }
        },
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: FutureBuilder(
            future: _getCareers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return PageLoader(
                  bottom: 175,
                );
              }
              return Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      // width: 316,
                      height: 48,
                      child: TextFormField(
                          onChanged: (value) {
                            filterCareer(value);
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.lato(fontSize: 14.0),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 10.0),
                            // border: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //         color: AppColors
                            //             .primaryThree, width: 10),),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: AppColors.grey16,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
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
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(right: 200, top: 2),
                    child: DropdownButton<String>(
                      value: _dropdownValue != null ? _dropdownValue : null,
                      icon: Icon(Icons.arrow_drop_down_outlined),
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
                        setState(() {
                          _dropdownValue = newValue;
                          // _isMostViewed = !_isMostViewed;
                          // pageNo = 1;
                          // widget.parentAction();
                        });
                      },
                      items: dropdownItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    height: 5.0,
                  ),
                  _filteredCareerOpenings.length > 0
                      ? Wrap(
                          children: [
                            for (int i = 0;
                                i < _filteredCareerOpenings.length;
                                i++)
                              InkWell(
                                  onTap: () {
                                    _navigateToDetail(
                                        _filteredCareerOpenings[i].title,
                                        _filteredCareerOpenings[i].description,
                                        _filteredCareerOpenings[i].viewCount,
                                        _filteredCareerOpenings[i].timeStamp,
                                        _filteredCareerOpenings[i].tags);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => CareerDetailedView(
                                    //             careerOpening: _careerOpenings[i],
                                    //           )),
                                    // );
                                    // _navigateToDetail(
                                    //     _data[i].tid,
                                    //     _data[i].user['fullname'],
                                    //     _data[i].title,
                                    //     _data[i].user['uid']);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CareerCardView(
                                      careerOpening: _filteredCareerOpenings[i],
                                    ),
                                  )),
                          ],
                        )
                      : Stack(
                          children: <Widget>[
                            Column(
                              children: [
                                Container(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 100),
                                      child: SvgPicture.asset(
                                        'assets/img/empty_search.svg',
                                        alignment: Alignment.center,
                                        // color: AppColors.grey16,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "No Opening found",
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
                        ),
                ],
              );
            },
          ),
        ));
  }
}
