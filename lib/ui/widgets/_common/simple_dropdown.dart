import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/_constants/color_constants.dart';

class SimpleDropdown extends StatefulWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> parentAction;
  SimpleDropdown({Key key, this.items, this.selectedItem, this.parentAction})
      : super(key: key);

  @override
  _SimpleDropdownState createState() => _SimpleDropdownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SimpleDropdownState extends State<SimpleDropdown> {
  String dropdownValue;
  List<String> dropdownItems;

  @override
  void initState() {
    super.initState();
    dropdownItems = widget.items.toSet().toList();
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
      value: dropdownValue.isNotEmpty ? dropdownValue : null,
      icon: Icon(Icons.arrow_drop_down_outlined),
      iconSize: 26,
      elevation: 16,
      style:
          TextStyle(color: AppColors.greys87, overflow: TextOverflow.ellipsis),
      underline: Container(
        // height: 2,
        color: AppColors.lightGrey,
      ),
      selectedItemBuilder: (BuildContext context) {
        return dropdownItems.map<Widget>((String item) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Row(
              children: [
                // Text(
                //   widget.label + ' | ',
                //   style: GoogleFonts.lato(
                //     color: AppColors.greys60,
                //     fontSize: 12,
                //   ),
                // ),
                HtmlWidget(
                  item,
                  textStyle: GoogleFonts.lato(
                    color: AppColors.greys60,
                    fontSize: 14,
                    // fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          );
        }).toList();
      },
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.parentAction(newValue);
        });
      },
      items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: HtmlWidget(value),
        );
      }).toList(),
    );
  }
}
