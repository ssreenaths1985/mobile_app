import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/localization/_langs/english_lang.dart';
import './../../../../constants/index.dart';

class CourseFilters extends StatefulWidget {
  final String filterName;
  final List items;
  final List selectedItems;
  final ValueChanged<Map> parentAction1;
  final ValueChanged<String> parentAction2;

  CourseFilters(
      {Key key,
      this.filterName,
      this.items,
      this.selectedItems,
      this.parentAction1,
      this.parentAction2})
      : super(key: key);
  @override
  _CourseFiltersState createState() => _CourseFiltersState();
}

class _CourseFiltersState extends State<CourseFilters> {
  Map data;

  void _updateFilter(i) {
    // print('$i: ' + widget.items[i]);
    data = {'filter': widget.filterName, 'item': widget.items[i]};
    widget.parentAction1(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(children: [
            Container(
              child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.greys87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  widget.filterName,
                  style: GoogleFonts.montserrat(
                    color: AppColors.greys87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ))
          ]),
        ),
        // Tab controller
        body: SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            // color: Colors.white,
            child: Column(children: <Widget>[
              for (int i = 0; i < widget.items.length; i++)
                Container(
                    margin: const EdgeInsets.only(bottom: 1),
                    child: ListTile(
                      title: Text(
                        widget.items[i],
                        style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700),
                      ),
                      onTap: () => {_updateFilter(i)},
                      selected: widget.filterName == EnglishLang.resourceType
                          ? (widget.selectedItems.contains(widget.items[i])
                              ? true
                              : false)
                          : (widget.selectedItems
                                  .contains(widget.items[i].toLowerCase())
                              ? true
                              : false),
                      selectedTileColor: AppColors.selectedTile,
                    )),
            ]),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    widget.parentAction2(widget.filterName);
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Reset to default',
                    style: GoogleFonts.lato(
                      color: AppColors.primaryThree,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  width: 180,
                  color: AppColors.primaryThree,
                  child: TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      // primary: Colors.white,
                      backgroundColor: AppColors.primaryThree,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // onSurface: Colors.grey,
                    ),
                    child: Text(
                      'Apply Filters',
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
