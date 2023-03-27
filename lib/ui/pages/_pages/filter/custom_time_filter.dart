import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';

class CustomTimeFilter extends StatefulWidget {
  @override
  _CustomTimeFilterState createState() => _CustomTimeFilterState();
}

class _CustomTimeFilterState extends State<CustomTimeFilter> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      // dateTimeRangePicker();
    });
  }

  dateTimeRangePicker() async {
    await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: DateTimeRange(
        end: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 2),
        start: DateTime.now(),
      ),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.greys87, //Head background
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light().copyWith(
              primary: AppColors.greys87,
            ), //Background color
          ),
          child: child,
        );
      },
    );
    // String _selectedDate = new DateFormat.yMMMd('en_US').format(picked).toString();
    // print(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {dateTimeRangePicker()},
      child: Center(
        child: Container(
          width: 180,
          color: AppColors.greys87,
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
              'Select date range',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
