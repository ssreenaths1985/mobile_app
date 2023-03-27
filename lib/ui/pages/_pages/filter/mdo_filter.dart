import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';

class MDOFilters extends StatefulWidget {
  @override
  _MDOFiltersState createState() {
    return new _MDOFiltersState();
  }
}

class _MDOFiltersState extends State<MDOFilters> {
  bool selectionStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: Container(
          //   child: IconButton(
          //       icon: Icon(
          //         Icons.close,
          //         color: AppColors.greys87,
          //       ),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       }),
          // ),
          elevation: 0,
          // titleSpacing: 0,
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
                  'MDOs',
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
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(children: <Widget>[
              ListTile(
                title: Text(
                  'All',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                title: Text(
                  'MDO 1',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
                onTap: () => {
                  setState(() {
                    selectionStatus = true;
                  })
                },
                selected: selectionStatus,
                selectedTileColor: Color.fromRGBO(0, 116, 182, 0.2),
              ),
              ListTile(
                title: Text(
                  'MDO 2',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                title: Text(
                  'MDO 3',
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ]),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Reset to default',
                style: GoogleFonts.lato(
                  color: AppColors.primaryThree,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
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
            ],
          ),
        )));
  }
}
