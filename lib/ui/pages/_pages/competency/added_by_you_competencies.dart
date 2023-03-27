import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/models/_models/browse_competency_card_model.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/competency/competency_details.dart';
import 'package:karmayogi_mobile/ui/screens/_screens/interests_screen.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
// import './../../../../constants/index.dart';
// import './../../../widgets/index.dart';
// import './../../../../services/index.dart';

class CompetenciesAddedByYou extends StatefulWidget {
  final ValueChanged<bool> checkAddCompetencyStatus;
  final List<BrowseCompetencyCardModel> profileCompetencies;
  final ValueChanged<bool> updateAddedCompetencies;
  final bool isDesired;
  CompetenciesAddedByYou(
      {this.checkAddCompetencyStatus,
      this.profileCompetencies,
      this.updateAddedCompetencies,
      this.isDesired = false});
  @override
  _CompetenciesAddedByYouState createState() => _CompetenciesAddedByYouState();
}

class _CompetenciesAddedByYouState extends State<CompetenciesAddedByYou> {
  List<BrowseCompetencyCardModel> _filteredProfileCompetencies = [];

  String dropdownValue;
  List<String> dropdownItems = [
    EnglishLang.ascentAtoZ,
    EnglishLang.descentZtoA
  ];

  @override
  void initState() {
    _filteredProfileCompetencies = widget.profileCompetencies;
    super.initState();
  }

  void _sortCompetencies(sortBy) {
    setState(() {
      if (sortBy == EnglishLang.ascentAtoZ) {
        // _filteredProfileCompetencies.sort((a, b) => a.name.compareTo(b.name));
        _filteredProfileCompetencies.sort((a, b) => b.name.compareTo(a.name));
      } else
        // _filteredProfileCompetencies.sort((a, b) => b.name.compareTo(a.name));
        _filteredProfileCompetencies.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _filterAddedCompetencies(value) {
    setState(() {
      _filteredProfileCompetencies = widget.profileCompetencies
          .where((competency) => competency.name.toLowerCase().contains(value))
          .toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.updateAddedCompetencies(true);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompetencyLevelBar(
                text: EnglishLang.fromWorkOrder, isWorkOrder: true),
            CompetencyLevelBar(
                text: EnglishLang.levelBasedOnEvaluation, isEvaluation: true),
            CompetencyLevelBar(
                text: EnglishLang.competencyLevelGap, isGap: true),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.70,
                      // width: 316,
                      height: 48,
                      child: TextFormField(
                          onChanged: (value) {
                            // filterCompetencies(value);
                            _filterAddedCompetencies(value);
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
                            hintText: EnglishLang.search,
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
                      height: 48,
                      width: MediaQuery.of(context).size.width * 0.20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.grey16,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        // color: AppColors.lightGrey,
                      ),
                      // color: Colors.white,
                      // width: double.infinity,
                      // margin: EdgeInsets.only(right: 225, top: 2),
                      child: DropdownButton<String>(
                        value: dropdownValue != null ? dropdownValue : null,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.greys60,
                          size: 18,
                        ),
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                              alignment: Alignment.center,
                              child: Text('Sort by')),
                        ),
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
                                    padding: EdgeInsets.fromLTRB(
                                        15.0, 15.0, 0, 15.0),
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
                            dropdownValue = newValue;
                          });
                          _sortCompetencies(dropdownValue);
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
                  ],
                ),
              ),
            ),
            !widget.isDesired
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      height: 40,
                      child: ButtonTheme(
                        child: OutlinedButton(
                          onPressed: () {
                            widget.checkAddCompetencyStatus(true);
                          },
                          style: OutlinedButton.styleFrom(
                            // primary: Colors.white,
                            side: BorderSide(
                                width: 1, color: AppColors.primaryThree),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // onSurface: Colors.grey,
                          ),
                          child: Text(
                            EnglishLang.addACompetency,
                            style: GoogleFonts.lato(
                                color: AppColors.primaryThree,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(),
            _filteredProfileCompetencies.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: _filteredProfileCompetencies.length * 190.0,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredProfileCompetencies.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                      page: CompetencyDetailsPage(
                                    _filteredProfileCompetencies[index],
                                    updateRemoveCompetencyStatus:
                                        widget.checkAddCompetencyStatus,
                                  )),
                                );
                              },
                              child: CompetencyLevelDetailsCard(
                                profileCompetency:
                                    _filteredProfileCompetencies[index],
                                isDesired: widget.isDesired,
                              ));

                          // CompetencyLevelDetailsCard(
                          //   profileCompetency: _filteredProfileCompetencies[index],
                          // );
                        },
                      ),
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: SvgPicture.asset(
                                  'assets/img/empty_competency.svg',
                                  alignment: Alignment.center,
                                  color: AppColors.grey16,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              EnglishLang.noCompetenciesFound,
                              style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1.5,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
