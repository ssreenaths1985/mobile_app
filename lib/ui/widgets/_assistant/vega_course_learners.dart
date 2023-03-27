import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../../respositories/_respositories/network_respository.dart';
import '../../../util/faderoute.dart';
import '../../pages/_pages/network/network_profile.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';

class VegaCourseLearners extends StatelessWidget {
  final learner;

  VegaCourseLearners({this.learner});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        FadeRoute(
          page: ChangeNotifierProvider<NetworkRespository>(
            create: (context) => NetworkRespository(),
            child: NetworkProfile(learner['user_id']),
          ),
        ),
      ),
      child: Container(
        color: Colors.white,
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
                      child: Center(
                        child: Text(
                            Helper.getInitialsNew(
                                (learner['first_name'] != null &&
                                        learner['last_name'] != null &&
                                        learner['first_name'] != '' &&
                                        learner['last_name'] != '')
                                    ? learner['first_name'].trim() +
                                        ' ' +
                                        learner['last_name'].trim()
                                    : learner['first_name'].trim()),
                            style: GoogleFonts.lato(color: Colors.white)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (learner['first_name'] != null &&
                                    learner['first_name'] != null)
                                ? learner['first_name'] +
                                    ' ' +
                                    learner['last_name']
                                : learner['first_name'],
                            style: GoogleFonts.lato(
                                color: AppColors.greys87,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700),
                          ),
                          learner['designation'] != null &&
                                  learner['designation'] != ''
                              ? Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    // designation != null ? designation : '',
                                    learner['designation'],
                                    style: GoogleFonts.lato(
                                        color: AppColors.greys60,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : Center()
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
