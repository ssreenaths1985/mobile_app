import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/models/_models/multi_select_item.dart';
import 'package:karmayogi_mobile/ui/widgets/_interests/_currentCompetencies/competency_filter_items.dart';

import '../../../../localization/_langs/english_lang.dart';

class FilterCompetencies extends StatefulWidget {
  final List<Set<MultiSelectItem>> competencyTypes;
  final List<Set<MultiSelectItem>> competencyAreas;
  final updateSelection;
  final resetToDefault;
  final applyFilter;

  const FilterCompetencies(
      {Key key,
      this.competencyTypes,
      this.competencyAreas,
      this.updateSelection,
      this.resetToDefault,
      this.applyFilter})
      : super(key: key);

  @override
  State<FilterCompetencies> createState() => _FilterCompetenciesState();
}

class _FilterCompetenciesState extends State<FilterCompetencies> {
  List<Set<MultiSelectItem>> _filteredCompetencyAreas;
  // final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCompetencyAreas = widget.competencyAreas;
    // _textController.addListener(_filterCompetencies);
  }

  _filterCompetencies(value) {
    // String value = _textController.text;
    setState(() {
      _filteredCompetencyAreas = widget.competencyAreas
          .where((competency) => competency.first.itemName
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Types: ' + widget.competencyTypes.toString());
    // print('Areas: ' + widget.competencyAreas.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          titleSpacing: 0,
          foregroundColor: Colors.black,
          title: Text(
            'Filter by',
            style: GoogleFonts.montserrat(
                color: AppColors.greys87,
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: 0.12,
                fontSize: 16),
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0.25,
                      fontSize: 14)),
              SizedBox(
                height: 16,
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.competencyTypes.length,
                  itemBuilder: (context, index) {
                    return CompetencyFilterItems(
                      index: index,
                      name: widget.competencyTypes[index].first.itemName,
                      isSelected:
                          widget.competencyTypes[index].first.isSelected,
                      updateSelection: widget.updateSelection,
                      isCompetencyArea: false,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('Competency area',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0.25,
                      fontSize: 14)),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 48,
                margin: EdgeInsets.only(bottom: 16),
                child: TextFormField(
                    // controller: _textController,
                    onChanged: (value) {
                      _filterCompetencies(value);
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.lato(fontSize: 14.0),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      contentPadding:
                          EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 10.0),
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
                      counterStyle: TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: '',
                    )),
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredCompetencyAreas.length,
                  itemBuilder: (context, index) {
                    return CompetencyFilterItems(
                      index: index,
                      name: _filteredCompetencyAreas[index].first.itemName,
                      isSelected:
                          _filteredCompetencyAreas[index].first.isSelected,
                      updateSelection: widget.updateSelection,
                      isCompetencyArea: true,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: AppColors.primaryThree,
                    primary: Colors.white,
                    minimumSize: const Size.fromHeight(40), // NEW
                    // side: BorderSide(width: 1, color: AppColors.primaryThree),
                  ),
                  onPressed: () {
                    // await _shareCertificate();
                    widget.resetToDefault();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Reset to default',
                    style: GoogleFonts.lato(
                        height: 1.429,
                        letterSpacing: 0.5,
                        fontSize: 14,
                        color: AppColors.primaryThree,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryThree,
                    minimumSize: const Size.fromHeight(40), // NEW
                    side: BorderSide(width: 1, color: AppColors.primaryThree),
                  ),
                  onPressed: () async {
                    await widget.applyFilter();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'APPLY',
                    style: GoogleFonts.lato(
                        height: 1.429,
                        letterSpacing: 0.5,
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
