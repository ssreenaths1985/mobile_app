import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/competency_level_detail_item.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/people_item_card.dart';
// import 'package:karmayogi_mobile/ui/widgets/_learn/author.dart';
// import 'package:karmayogi_mobile/ui/widgets/index.dart';

class PositionInfoPage extends StatefulWidget {
  const PositionInfoPage({Key key}) : super(key: key);

  @override
  State<PositionInfoPage> createState() => _PositionInfoPageState();
}

class _PositionInfoPageState extends State<PositionInfoPage> {
  bool aboutTrimText = true;
  bool openingTrimText = true;

  // int _maxLength = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              margin: EdgeInsets.only(top: 16),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              height: 170,
              color: Colors.white,
              child: Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   EnglishLang.presenters,
                        //   style: GoogleFonts.montserrat(
                        //       decoration: TextDecoration.none,
                        //       color: AppColors.greys87,
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w500),
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            color: AppColors.grey08,
                            height: 99,
                            width: 120,
                            child: Icon(
                              Icons.insights_outlined,
                              color: AppColors.grey40,
                            ),
                          ),
                        ),
                        Container(
                          width: 170,
                          margin: EdgeInsets.only(left: 10),
                          child: Wrap(
                            children: [
                              Text(
                                'Deputy Director (Implementation)',
                                // maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.12,
                                    height: 1.5),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Department of official language',
                                  // maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'New Delhi',
                                  // maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: AppColors.greys60,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '1 New opening',
                      style: GoogleFonts.lato(
                        color: AppColors.primaryThree,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          '1 New opening',
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '6th August 2020',
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys60,
                              fontSize: 14,
                              height: 1.429,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          'Filling up the post of Deputy Director (Implementation) on Deputation basis in Regional Implementation Offices under the department of Official Language - reg',
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 16,
                              height: 1.5,
                              letterSpacing: 0.12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '''The undersigned is directed to circulate the vacancy circular number 12013/4/2019-OL (Imp. I) dated 6th August, 2020 (along-with enclosures) received from Ministry of Home Affairs who proposes to fill up posts of Deputy Director (Implementation) in Level -11 (₹. 67700-208700) in the Regional Implementation Offices of the Department of Official Language, Ministry of Home Affairs on Deputation basis.

                          2. It may be noted that cadre clearance from C.S.I Division will be required in case of Under Secretary and above level officers of CSS applying for deputation

                          3. In case of any further clarification, applicants are requested to contact the .''',
                          maxLines: !openingTrimText ? 100 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 14,
                              height: 1.429,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    openingTrimText = !openingTrimText;
                                  });
                                },
                                child: Text(
                                  openingTrimText
                                      ? EnglishLang.readMore
                                      : EnglishLang.showLess,
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primaryThree,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                          ))
                    ])),
            Container(
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          EnglishLang.about,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Deputy Director (Implementation) on Deputation basis in Regional Implementation Offices under the department of Official Language - reg',
                          maxLines: !aboutTrimText ? 100 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 14,
                              height: 1.429,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    aboutTrimText = !aboutTrimText;
                                  });
                                },
                                child: Text(
                                  aboutTrimText
                                      ? EnglishLang.readMore
                                      : EnglishLang.showLess,
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: AppColors.primaryThree,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                          ))
                    ])),
            Container(
              margin: EdgeInsets.all(16),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.greenTwo,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'You are 60% Match to this position',
                        style: GoogleFonts.lato(
                            decoration: TextDecoration.none,
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.429,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 21),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 8,
                      backgroundColor: AppColors.white016,
                      valueColor: AlwaysStoppedAnimation(AppColors.lightGreen),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(EnglishLang.findGaps),
                      style: ElevatedButton.styleFrom(
                          primary: AppColors.customBlue,
                          onPrimary: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 16, top: 32),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          EnglishLang.matchingCompetencies,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.429,
                              letterSpacing: 0.25),
                        ),
                      ),
                      Container(
                        height: 3 * 80.0,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return CompetencyLevelDetailItem();
                          },
                        ),
                      ),
                    ])),
            Container(
                margin: const EdgeInsets.only(bottom: 16, top: 8),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          EnglishLang.competencyGaps,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.429,
                              letterSpacing: 0.25),
                        ),
                      ),
                      Container(
                        height: 3 * 80.0,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return CompetencyLevelDetailItem();
                          },
                        ),
                      ),
                    ])),
            Container(
                margin: const EdgeInsets.only(bottom: 16, top: 8),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          EnglishLang.people,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.429,
                              letterSpacing: 0.25),
                        ),
                      ),
                      PeopleItemCard(
                        name: 'Reshma Prasad',
                        duration: 'July 2018 - Present',
                        isCurrent: true,
                      ),
                      Container(
                        height: 2 * 80.0,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return PeopleItemCard(
                              name: 'Reshma Prasad',
                              duration: 'May 2016 - July 2018',
                            );
                          },
                        ),
                      ),
                    ])),
            Container(
                margin: const EdgeInsets.only(bottom: 16, top: 8),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          EnglishLang.recommendedCourses,
                          style: GoogleFonts.lato(
                              decoration: TextDecoration.none,
                              color: AppColors.greys87,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.429,
                              letterSpacing: 0.25),
                        ),
                      ),
                      Container(
                        height: 2 * 80.0,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return PeopleItemCard(
                              name: 'Basics of Administrative Law',
                              duration: 'Administrative Law',
                              image:
                                  'https://www.pngitem.com/pimgs/m/326-3263548_transparent-training-icon-png-training-icon-png-png.png',
                            );
                          },
                        ),
                      ),
                    ])),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            // height: _activeTabIndex == 0 ? 60 : 0,
            height: 100,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryThree,
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {},
                  child: const Text(
                    EnglishLang.showInterest,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: const Size.fromHeight(40), // NEW
                    side: BorderSide(width: 1, color: AppColors.primaryThree),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => SelfAttestCompetency(
                    //             levels: _levels,
                    //             currentCompetencySelected:
                    //                 widget.browseCompetencyCardModel,
                    //             profileCompetencies: _profileCompetencies,
                    //             isAlreadyAdded: _setAlreadyAdded,
                    //             addedStatus: _addedStatus,
                    //           )),
                    // );
                  },
                  child: const Text(
                    EnglishLang.follow,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryThree,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
