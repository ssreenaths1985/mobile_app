import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';

// ignore: must_be_immutable
class CompetencyAreaFilter extends StatefulWidget {
  // const CompetencyTypeFilter({ Key? key }) : super(key: key);
  final allCompetencyArea;
  ValueChanged<Map> selected;
  ValueChanged<Map> selectedIndex;
  final appliedIndex;
  CompetencyAreaFilter(
      {this.allCompetencyArea,
      this.selected,
      this.appliedIndex,
      this.selectedIndex});

  @override
  _CompetencyAreaFilterState createState() => _CompetencyAreaFilterState();
}

class _CompetencyAreaFilterState extends State<CompetencyAreaFilter> {
  var selectedId;

  // List _types = ['All', 'Area 1', 'Area 2', 'Area 3', 'Area 4', 'Area 5'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.allCompetencyArea.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    groupValue: selectedId != null
                        ? selectedId
                        : widget.allCompetencyArea[widget.appliedIndex != null
                            ? widget.appliedIndex
                            : 0],
                    title: Text(
                      widget.allCompetencyArea[index],
                      style: GoogleFonts.lato(
                          color: AppColors.greys87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700),
                    ),
                    value: widget.allCompetencyArea[index],
                    onChanged: (val) {
                      setState(() {
                        selectedId = val;
                        widget.selected({'area': selectedId});
                        selectedId == widget.allCompetencyArea[index]
                            ? widget.selectedIndex({'area': index})
                            : widget.selectedIndex({'area': 0});
                        // selectedPosition =
                        //     _positions[index].name;
                      });
                    },
                    selected: (selectedId == widget.allCompetencyArea[index]),
                    selectedTileColor: AppColors.selectedTile,
                  );
                },
              ),
            ]),
          )),
    );
  }
}
