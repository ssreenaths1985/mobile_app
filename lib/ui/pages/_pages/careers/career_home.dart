import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/feedback/widgets/_microSurvey/page_loader.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/ui/screens/_screens/career_browse_by.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/career_item.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/mdo_to_follow_item.dart';

class CareerHome extends StatefulWidget {
  const CareerHome({Key key}) : super(key: key);

  @override
  _CareerHomeState createState() => _CareerHomeState();
}

class _CareerHomeState extends State<CareerHome> {
  Future<dynamic> _getData() async {
    return 'data';
  }

  Future<dynamic> _getFromMDOYouFollow() async {
    return 'data';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // scrollDirection: Axis.horizontal,
      child: FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return PageLoader(
              bottom: 175,
            );
          }
          return Wrap(
            alignment: WrapAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 8),
                        child: Text(EnglishLang.searchCareerPosition,
                            style: GoogleFonts.lato(
                                decoration: TextDecoration.none,
                                color: AppColors.greys87,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        // width: 316,
                        height: 48,
                        child: TextFormField(
                            onChanged: (value) {
                              // filterCareer(value);
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
                              hintText: EnglishLang.careerHomeSearchHint,
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
                      margin: EdgeInsets.only(bottom: 16),
                      width: double.infinity,
                      height: 40,
                      child: ButtonTheme(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CareerBrowseBy()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // primary: Colors.white,
                            side: BorderSide(
                                width: 1, color: AppColors.primaryThree),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // onSurface: Colors.grey,
                          ),
                          child: Text(
                            EnglishLang.browseByMDO,
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      height: 40,
                      child: ButtonTheme(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CareerBrowseBy(
                                        tabIndex: 1,
                                      )),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // primary: Colors.white,
                            side: BorderSide(
                                width: 1, color: AppColors.primaryThree),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // onSurface: Colors.grey,
                          ),
                          child: Text(
                            EnglishLang.browseByLocation,
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      height: 40,
                      child: ButtonTheme(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CareerBrowseBy(
                                        tabIndex: 2,
                                      )),
                            );
                            // if (this.url != '') {
                            //   Navigator.pushNamed(context, this.url);
                            // }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // primary: Colors.white,
                            side: BorderSide(
                                width: 1, color: AppColors.primaryThree),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // onSurface: Colors.grey,
                          ),
                          child: Text(
                            EnglishLang.exploreByCompetency,
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(EnglishLang.openingsFromMDOs,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text(EnglishLang.seeAll,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.primaryThree,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              Container(
                height: 282,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 8),
                child: FutureBuilder(
                  future: _getFromMDOYouFollow(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // List<Suggestion> suggestions = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return CareerItem();
                          // return Center();
                        },
                      );
                    } else {
                      // return Center(child: CircularProgressIndicator());
                      return Center();
                    }
                  },
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(EnglishLang.recentlyViewedOpenings,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text(EnglishLang.seeAll,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.primaryThree,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              Container(
                height: 282,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 8),
                child: FutureBuilder(
                  future: _getFromMDOYouFollow(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // List<Suggestion> suggestions = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return CareerItem();
                          // return Center();
                        },
                      );
                    } else {
                      // return Center(child: CircularProgressIndicator());
                      return Center();
                    }
                  },
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 8),
                        child: Text(EnglishLang.yourCareerPath,
                            style: GoogleFonts.lato(
                                decoration: TextDecoration.none,
                                color: AppColors.greys87,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                      color: AppColors.lightSelected,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Joint Secretary',
                              style: GoogleFonts.montserrat(
                                  color: AppColors.greys87,
                                  fontSize: 16.0,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Ministry of Rural Development of India',
                              style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'New Delhi',
                              style: GoogleFonts.lato(
                                  color: AppColors.greys60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'July 2018 - Present',
                              style: GoogleFonts.lato(
                                  color: AppColors.primaryThree,
                                  fontSize: 14.0,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 16, top: 16),
                      width: double.infinity,
                      height: 40,
                      child: ButtonTheme(
                        child: OutlinedButton(
                          onPressed: () {
                            // if (this.url != '') {
                            //   Navigator.pushNamed(context, this.url);
                            // }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // primary: Colors.white,
                            side: BorderSide(
                                width: 1, color: AppColors.primaryThree),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // onSurface: Colors.grey,
                          ),
                          child: Text(
                            EnglishLang.yourCareerHistory,
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      width: double.infinity,
                      height: 40,
                      child: ButtonTheme(
                        child: OutlinedButton(
                          onPressed: () {
                            // if (this.url != '') {
                            //   Navigator.pushNamed(context, this.url);
                            // }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // primary: Colors.white,
                            side: BorderSide(
                                width: 1, color: AppColors.primaryThree),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // onSurface: Colors.grey,
                          ),
                          child: Text(
                            EnglishLang.careerPathRecommendations,
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(EnglishLang.openingsNearYou,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text(EnglishLang.seeAll,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.primaryThree,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              Container(
                height: 282,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 8),
                child: FutureBuilder(
                  future: _getFromMDOYouFollow(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // List<Suggestion> suggestions = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return CareerItem();
                          // return Center();
                        },
                      );
                    } else {
                      // return Center(child: CircularProgressIndicator());
                      return Center();
                    }
                  },
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(EnglishLang.mdoToFollow,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text(EnglishLang.seeAll,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.primaryThree,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              Container(
                height: 282,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 8),
                child: FutureBuilder(
                  future: _getFromMDOYouFollow(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // List<Suggestion> suggestions = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return MDOToFollowItem();
                          // return Center();
                        },
                      );
                    } else {
                      // return Center(child: CircularProgressIndicator());
                      return Center();
                    }
                  },
                ),
              ),
              Container(
                height: 50,
              )
            ],
          );
        },
      ),
    );
  }
}
