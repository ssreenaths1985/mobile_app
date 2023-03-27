import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/index.dart';
import '../../../util/helper.dart';

class PeopleItemCard extends StatelessWidget {
  final bool isCurrent;
  final String name;
  final String duration;
  final String image;

  PeopleItemCard(
      {this.name, this.duration, this.isCurrent = false, this.image = ''});

  @override
  Widget build(BuildContext context) {
    // print('name:' + name);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.grey04,
      margin: EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: AppColors.lightBackground, width: 2.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.positiveLight,
                      borderRadius:
                          BorderRadius.all(const Radius.circular(4.0)),
                    ),
                    // Image.network(
                    //   'https://www.pngitem.com/pimgs/m/326-3263548_transparent-training-icon-png-training-icon-png-png.png',
                    //   // width: 48,
                    //   // height: 48,
                    //   fit: BoxFit.cover,
                    // )
                    child: image == ''
                        ? Center(
                            child: Text(Helper.getInitialsNew(name),
                                style: GoogleFonts.lato(color: Colors.white)),
                          )
                        : Image.network(
                            image,
                            // width: 48,
                            // height: 48,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text(
                            duration,
                            style: GoogleFonts.lato(
                                color: !isCurrent
                                    ? AppColors.greys60
                                    : AppColors.primaryThree,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
