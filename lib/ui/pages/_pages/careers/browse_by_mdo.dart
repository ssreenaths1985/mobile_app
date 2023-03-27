import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/feedback/widgets/_microSurvey/page_loader.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_career/browse_by_mdo_item.dart';

class BrowseByMDO extends StatefulWidget {
  const BrowseByMDO({Key key}) : super(key: key);

  @override
  _BrowseByMDOState createState() => _BrowseByMDOState();
}

class _BrowseByMDOState extends State<BrowseByMDO> {
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
                        child: Text(EnglishLang.browseCareersByMDO,
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
                              hintText: EnglishLang.searchMDOs,
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
                  ],
                ),
              ),
              Container(
                // width: 182,
                height: 1000,
                padding: const EdgeInsets.only(top: 20, bottom: 20, right: 8),
                child: FutureBuilder(
                  future: _getFromMDOYouFollow(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // List<Suggestion> suggestions = snapshot.data;
                      return GridView.count(
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(8, (index) {
                          return BrowseByMDOItem();
                        }),
                      );
                      // ListView.builder(
                      //   scrollDirection: Axis.vertical,
                      //   itemCount: 3,
                      //   itemBuilder: (context, index) {
                      //     return BrowseByMDOItem();
                      //     // return Center();
                      //   },
                      // );
                    } else {
                      // return Center(child: CircularProgressIndicator());
                      return Center();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
