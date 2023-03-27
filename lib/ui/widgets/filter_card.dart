import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../constants/index.dart';

class FilterCard extends StatefulWidget {
  final String categoryName;
  final String selectedFilter;

  FilterCard(this.categoryName, this.selectedFilter);

  @override
  _FilterCardState createState() => new _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 0.0, top: 0),
          child: FittedBox(
            child: Container(
                height: 40,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.categoryName + ' | ',
                        style: GoogleFonts.lato(
                          color: AppColors.greys60,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      widget.selectedFilter,
                      style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(Icons.arrow_drop_down),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.grey08,
                    // width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppColors.lightGrey,
                )),
          ),
        ),
      ],
    );
  }
}
