import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/_constants/color_constants.dart';
import 'package:karmayogi_mobile/util/helper.dart';

class BrowseByMDOItem extends StatelessWidget {
  const BrowseByMDOItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => null,
        // Navigator.push(
        //       context,
        //       FadeRoute(
        //         page: ChangeNotifierProvider<NetworkRespository>(
        //           create: (context) => NetworkRespository(),
        //           child: NetworkProfile(widget.suggestion.id),
        //         ),
        //       ),
        //     ),
        child: Container(
          margin: EdgeInsets.only(left: 10, bottom: 8),
          // width: 180.0,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey08,
                blurRadius: 6.0,
                spreadRadius: 0,
                offset: Offset(
                  3,
                  3,
                ),
              ),
            ],
            border: Border.all(color: AppColors.grey08),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 48,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    color: AppColors.peach,
                  ),
                  Positioned(
                    left: 68,
                    top: 32,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: AppColors.positiveLight,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(4.0)),
                      ),
                      child: Center(
                        child: Text(
                          Helper.getInitials('Ministry of Commerce'
                              // 'Career'.trim() + ' ' + 'Text'.trim()
                              ),
                          style: GoogleFonts.lato(
                              color: AppColors.avatarText,
                              fontSize: 14.0,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
                          child: Center(
                            child: Text(
                              'Ministry of Commerce',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          // constraints: BoxConstraints(minHeight: 25),
                          child: Text(
                            'New Delhi',
                            style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
