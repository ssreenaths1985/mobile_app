import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/_constants/color_constants.dart';

class Dropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final String selectedItem;
  Dropdown({Key key, this.label, this.items, this.selectedItem})
      : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropdownState extends State<Dropdown> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    initializeDropdown();
  }

  void initializeDropdown() {
    setState(() {
      dropdownValue = widget.selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down_outlined),
      iconSize: 26,
      elevation: 16,
      style: TextStyle(color: AppColors.greys87),
      underline: Container(
        // height: 2,
        color: AppColors.lightGrey,
      ),
      selectedItemBuilder: (BuildContext context) {
        return widget.items.map<Widget>((String item) {
          return Row(
            children: [
              Text(
                widget.label + ' | ',
                style: GoogleFonts.lato(
                  color: AppColors.greys60,
                  fontSize: 12,
                ),
              ),
              Text(
                item,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          );
        }).toList();
      },
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
