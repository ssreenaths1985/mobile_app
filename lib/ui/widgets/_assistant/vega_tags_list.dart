import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../ui/pages/index.dart';
import './../../../constants/index.dart';
import './../../../util/faderoute.dart';
// import './../../../localization/index.dart';

class VegaTagsList extends StatelessWidget {
  final data;

  VegaTagsList(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          // Heading
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              // Tags list
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        for (int i = 0; i < data.length; i++)
                          InkWell(
                              onTap: () {
                                // this.parentAction(data[i].tagValue);
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                      page: FilteredDiscussionsPage(
                                    isCategory: false,
                                    id: data[i]['score'],
                                    title: data[i]['value'],
                                    backToTitle: "Back to vega",
                                  )),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 10.0,
                                  right: 15.0,
                                ),
                                padding: EdgeInsets.fromLTRB(20, 5, 15, 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.grey08),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(05),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(05)),
                                ),
                                child: Wrap(
                                  children: [
                                    Text(
                                      data[i]['value'],
                                      style: GoogleFonts.lato(
                                        color: AppColors.greys87,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 2, 4, 2),
                                        // decoration: BoxDecoration(
                                        //   color: AppColors.grey08,
                                        //   border:
                                        //       Border.all(color: AppColors.grey08),
                                        //   borderRadius: BorderRadius.circular(4),
                                        // ),
                                        child: Text(
                                          data[i]['score'].toString(),
                                          style: GoogleFonts.lato(
                                            color: AppColors.primaryThree,
                                            // wordSpacing: 1.0,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ))
                                  ],
                                ),
                              ))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
