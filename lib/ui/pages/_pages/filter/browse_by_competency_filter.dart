import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/filter/competency_area_filter.dart';
import 'package:karmayogi_mobile/ui/pages/_pages/filter/competency_type_filter.dart';
import 'package:karmayogi_mobile/ui/widgets/_discussion/silverappbar_delegate.dart';
// import 'package:provider/provider.dart';
// import './../../../models/index.dart';
// import './../../../respositories/index.dart';
// import './../../../constants/index.dart';
// import './../../../ui/pages/index.dart';
// import './../../../ui/widgets/index.dart';
// import './../../../localization/index.dart';

class BrowseByCompetencyFilter extends StatefulWidget {
  // static const route = AppUrl.knowledgeResourcesPage;
  final allCompetencyTypes, allCompetencyArea;
  final ValueChanged<Map> parentAction1;
  final ValueChanged<Map> selectedFilterIndex;
  final int selectedTypeIndex;
  final int selectedAreaIndex;
  final ValueChanged<bool> isAppliedFilter;
  BrowseByCompetencyFilter(
      {this.allCompetencyTypes,
      this.allCompetencyArea,
      this.parentAction1,
      this.selectedFilterIndex,
      this.selectedTypeIndex,
      this.selectedAreaIndex,
      this.isAppliedFilter});

  @override
  _BrowseByCompetencyFilterState createState() {
    return _BrowseByCompetencyFilterState();
  }
}

class _BrowseByCompetencyFilterState extends State<BrowseByCompetencyFilter>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List tabNames = [EnglishLang.competencyType, EnglishLang.competencyArea];
  String _selectedType;
  String _selectedArea;
  Map _selectedFilter = {'type': EnglishLang.all, 'area': EnglishLang.all};
  // bool _isAppliedFilter;

  @override
  void initState() {
    super.initState();
  }

  void _selectedCompetencyFilter(Map filter) {
    setState(() {
      _selectedType = filter['type'] != null ? filter['type'] : EnglishLang.all;
      _selectedArea = filter['area'] != null ? filter['area'] : EnglishLang.all;
      _selectedFilter = {
        'type': _selectedType,
        'area': _selectedArea,
      };
    });
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
          title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                EnglishLang.filterBy,
                style: GoogleFonts.montserrat(
                  color: AppColors.greys87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              )),
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
                    CompetencyTypeFilter(
                      allCompetencyTypes: widget.allCompetencyTypes,
                      selected: _selectedCompetencyFilter,
                      selectedIndex: widget.selectedFilterIndex,
                      appliedIndex: widget.selectedTypeIndex,
                    ),
                    CompetencyAreaFilter(
                      allCompetencyArea: widget.allCompetencyArea,
                      selected: _selectedCompetencyFilter,
                      selectedIndex: widget.selectedFilterIndex,
                      appliedIndex: widget.selectedAreaIndex,
                    )
                    // AllResourcesPage(
                    //     knowledgeResources: _knowledgeResources,
                    //     parentAction: fetchData),
                    // SavedResourcesPage(
                    //     knowledgeResources: _knowledgeResources,
                    //     parentAction: fetchData),
                  ],
                ),
              ),
            ))),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () => setState(() {
                        widget.parentAction1({});
                        widget.selectedFilterIndex({
                          'type': 0,
                          'area': 0,
                        });
                        widget.isAppliedFilter(false);
                        // widget.parentAction({'id': '', 'position': ''});
                        Navigator.pop(context);
                      }),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      EnglishLang.resetToDefault,
                      style: GoogleFonts.lato(
                        color: AppColors.primaryThree,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  width: 180,
                  color: AppColors.primaryThree,
                  child: TextButton(
                    onPressed: () => setState(() {
                      widget.isAppliedFilter(true);
                      widget.parentAction1(_selectedFilter);
                      Navigator.pop(context);
                    }),
                    style: TextButton.styleFrom(
                      // primary: Colors.white,
                      backgroundColor: AppColors.primaryThree,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // onSurface: Colors.grey,
                    ),
                    child: Text(
                      EnglishLang.apply,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
