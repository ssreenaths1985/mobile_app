import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/_constants/color_constants.dart';

// ignore: must_be_immutable
class CompetencyFilterItems extends StatefulWidget {
  final int index;
  final String name;
  bool isSelected;
  final bool isCompetencyArea;
  final updateSelection;
  CompetencyFilterItems(
      {Key key,
      this.index,
      this.name = '',
      this.isSelected,
      this.updateSelection,
      this.isCompetencyArea})
      : super(key: key);

  @override
  State<CompetencyFilterItems> createState() => _CompetencyFilterItemsState();
}

class _CompetencyFilterItemsState extends State<CompetencyFilterItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: widget.isSelected,
              onChanged: (value) {
                setState(() {
                  widget.isSelected = value;
                });

                widget.isCompetencyArea
                    ? widget.updateSelection(widget.index, value, widget.name,
                        isCompetencyArea: true)
                    : widget.updateSelection(widget.index, value, widget.name,
                        isCompetencyType: true);

                // if (!_formKey.currentState.validate()) {
                //   return;
                // }
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.78,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w400,
                      height: 1.429,
                      letterSpacing: 0.25,
                      fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }
}
