import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:karmayogi_mobile/models/index.dart';
import 'package:karmayogi_mobile/ui/pages/index.dart';
import 'package:karmayogi_mobile/util/faderoute.dart';
import './../../../constants/index.dart';

class ProviderCard extends StatelessWidget {
  final dynamic providerCardModel;
  // final CourseTopics courseTopics;
  // final String name;
  // final int count;
  // final Color cardColor;
  // final double paddingLeft;
  final bool isCollection;

  ProviderCard({this.providerCardModel, this.isCollection = false
      //   this.name = '',
      // this.count = 0,
      // this.cardColor,
      // this.courseTopics,
      // this.paddingLeft = 16.0
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(
                page: CoursesByProvider(
              providerCardModel.name,
              isCollection: isCollection,
              collectionId: isCollection ? providerCardModel.id : '',
            )),
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, bottom: 16),
          child: Container(
            height: 150,
            width: (MediaQuery.of(context).size.width) / 2 - 25,
            // width: 172,s
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(const Radius.circular(8.0)),
              border: Border.all(color: AppColors.grey16),
              color: Colors.white,
            ),
            child: Stack(children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/img/provider_card.svg',
                  alignment: Alignment.center,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          providerCardModel.name != null
                              ? providerCardModel.name
                              : '',
                          maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 16, top: 8),
                    //   child: Text(
                    //     '${courseTopics.noOfHoursConsumed} hours in last week',
                    //     style: GoogleFonts.lato(
                    //         color: AppColors.greys60,
                    //         fontSize: 12.0,
                    //         fontWeight: FontWeight.w400),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
