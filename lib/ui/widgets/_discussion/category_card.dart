import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/_constants/color_constants.dart';

class CategoryCard extends StatelessWidget {
  final data;

  CategoryCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/img/category_image_1.svg',
                  width: 35.0,
                  height: 35.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            data.title,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: AppColors.greys87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      Container(
                        child: Text(
                          data.description != null
                              ? data.description
                              : 'Category description',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            color: AppColors.greys87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(60.0, 0.0, 15.0, 20.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  child: Text(
                    data.discussions != null
                        ? (data.discussions).toString() + ' discussions'
                        : '0 discussions',
                    style: GoogleFonts.lato(
                      color: AppColors.greys60,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    data.posts != null
                        ? (data.posts).toString() + ' posts'
                        : '0 posts',
                    style: GoogleFonts.lato(
                      color: AppColors.greys60,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
