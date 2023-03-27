import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
// import 'package:karmayogi_mobile/localization/index.dart';

// ignore: must_be_immutable
class CompetencyTypeFilter extends StatefulWidget {
  // const CompetencyTypeFilter({ Key? key }) : super(key: key);
  final allCompetencyTypes;
  ValueChanged<Map> selected;
  ValueChanged<Map> selectedIndex;
  final appliedIndex;
  CompetencyTypeFilter(
      {this.allCompetencyTypes,
      this.selected,
      this.selectedIndex,
      this.appliedIndex});

  @override
  _CompetencyTypeFilterState createState() => _CompetencyTypeFilterState();
}

class _CompetencyTypeFilterState extends State<CompetencyTypeFilter> {
  var selectedId;

  // List _types = ['All', 'Type 1', 'Type 2', 'Type 3', 'Type 4', 'Type 5'];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Container(
          color: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.allCompetencyTypes.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  groupValue: selectedId != null
                      ? selectedId
                      : widget.allCompetencyTypes[widget.appliedIndex != null
                          ? widget.appliedIndex
                          : 0],
                  title: Text(
                    widget.allCompetencyTypes[index],
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700),
                  ),
                  value: widget.allCompetencyTypes[index],
                  onChanged: (val) {
                    setState(() {
                      selectedId = val;
                      widget.selected({'type': selectedId});
                      selectedId == widget.allCompetencyTypes[index]
                          ? widget.selectedIndex({'type': index})
                          : widget.selectedIndex({'type': 0});
                      // selectedPosition =
                      //     _positions[index].name;
                    });
                  },
                  selected: (selectedId == widget.allCompetencyTypes[index]),
                  selectedTileColor: AppColors.selectedTile,
                );
              },
            ),
          ]),
        ));
  }
}
