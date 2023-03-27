import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class Hobbies extends StatelessWidget {
  final List hobbies;

  Hobbies(this.hobbies);

  generateHobbies(context, hobbies) {
    var hobbiesWidgets = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    for (var hobby in hobbies) {
      hobbiesWidgets.children.add(
        ElevatedButton(
          // elevation: false,
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.lightGrey),
          ),
          // color: AppColors.lightGrey,
          child: Text(
            hobby,
            style: GoogleFonts.lato(
                fontSize: 14,
                color: AppColors.greys87,
                letterSpacing: 0.25,
                fontWeight: FontWeight.w400),
          ),
        ),
      );
    }
    // hobbiesWidgets.children.add(Container(
    //   padding: EdgeInsets.only(top: 20),
    //   child: Row(
    //     children: <Widget>[
    //       Spacer(),
    //       Row(children: <Widget>[
    //         InkWell(
    //           onTap: () => Navigator.push(
    //             context,
    //             FadeRoute(page: ComingSoonScreen()),
    //           ),
    //           child: Text(
    //             'See all',
    //             style: GoogleFonts.lato(
    //                 fontSize: 14,
    //                 fontWeight: FontWeight.w700,
    //                 color: AppColors.primaryThree),
    //           ),
    //         ),
    //         Icon(Icons.chevron_right, color: AppColors.primaryThree)
    //       ])
    //     ],
    //   ),
    // ));
    return hobbiesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      alignment: Alignment.topLeft,
      child: generateHobbies(context, hobbies),
    );
  }
}
