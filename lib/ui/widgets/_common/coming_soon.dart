import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import './../../../constants/index.dart';

class ComingSoon extends StatelessWidget {
  final bool isBottomBarItem;
  final bool removeGoToWebButton;
  ComingSoon({this.isBottomBarItem = false, this.removeGoToWebButton = false});

  Future<void> _launchURL(url) async {
    try {
      if (await launchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw '$url: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: removeGoToWebButton ? 150 : 72),
                  child: SvgPicture.asset(
                    'assets/img/coming-soon-new.svg',
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'COMING',
                  style: GoogleFonts.lato(
                    color: AppColors.primaryThree,
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
              ),
              Text(
                'SOON',
                style: GoogleFonts.lato(
                  color: AppColors.primaryThree,
                  fontWeight: FontWeight.w500,
                  fontSize: 36,
                ),
              ),
              !removeGoToWebButton
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'This feature is available in \n the web portal as of now',
                            style: GoogleFonts.lato(
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 1.5,
                              letterSpacing: 0.25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: SizedBox(
                            height: 48,
                            width: 272,
                            child: TextButton(
                              onPressed: () {
                                _launchURL(AppUrl.webAppUrl);
                              },
                              style: TextButton.styleFrom(
                                // primary: Colors.white,
                                backgroundColor: AppColors.scaffoldBackground,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                        color: AppColors.primaryThree)),
                                // onSurface: Colors.grey,
                              ),
                              // padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
                              // minWidth: 175,
                              child: Text(
                                'GO TO WEB PORTAL',
                                style: GoogleFonts.lato(
                                    color: AppColors.primaryThree,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                    height: 1.5),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(),
              !isBottomBarItem
                  ? Padding(
                      padding:
                          EdgeInsets.only(top: removeGoToWebButton ? 32 : 16),
                      child: SizedBox(
                        height: 48,
                        width: 272,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryThree,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // onSurface: Colors.grey,
                          ),
                          // color: AppColors.customBlue,
                          // padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
                          // minWidth: 175,
                          child: Text(
                            'GO BACK',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                height: 1.5),
                          ),
                        ),
                      ),
                    )
                  : Center(),
            ],
          ),
        ),
        // Positioned(
        //     // draw a red marble
        //     // top: -1,
        //     // right: -1,
        //     child: Center(
        //         child: Container(
        //             margin: const EdgeInsets.only(top: 200),
        //             child: Column(
        //               children: [
        //                 Text(
        //                   'COMING',
        //                   style: GoogleFonts.lato(
        //                     color: AppColors.primaryThree,
        //                     fontWeight: FontWeight.w500,
        //                     fontSize: 26,
        //                   ),
        //                 ),
        //                 Text(
        //                   'SOON',
        //                   style: GoogleFonts.lato(
        //                     color: AppColors.primaryThree,
        //                     fontWeight: FontWeight.w500,
        //                     fontSize: 36,
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 20, bottom: 30),
        //                   child: Text(
        //                     'This feature is available in \nthe web portal as of now',
        //                     style: GoogleFonts.lato(
        //                         color: AppColors.greys87,
        //                         fontWeight: FontWeight.w500,
        //                         fontSize: 16,
        //                         height: 1.5),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 20),
        //                   child: TextButton(
        //                     onPressed: () {
        //                       _launchURL(AppUrl.webAppUrl);
        //                     },
        //                     style: TextButton.styleFrom(
        //                       // primary: Colors.white,
        //                       backgroundColor: AppColors.customBlue,
        //                       shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(4),
        //                           side: BorderSide(color: AppColors.grey16)),
        //                       // onSurface: Colors.grey,
        //                     ),
        //                     // padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
        //                     // minWidth: 175,
        //                     child: Text(
        //                       'Go to web portal',
        //                       style: GoogleFonts.lato(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.w700,
        //                         fontSize: 14,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 20),
        //                   child: TextButton(
        //                     onPressed: () {
        //                       Navigator.of(context).pop();
        //                     },
        //                     style: TextButton.styleFrom(
        //                       // primary: Colors.white,

        //                       shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(4),
        //                           side: BorderSide(
        //                               color: AppColors.primaryThree)),
        //                       // onSurface: Colors.grey,
        //                     ),
        //                     // color: AppColors.customBlue,
        //                     // padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
        //                     // minWidth: 175,
        //                     child: Text(
        //                       'Go back',
        //                       style: GoogleFonts.lato(
        //                         color: AppColors.primaryThree,
        //                         fontWeight: FontWeight.w700,
        //                         fontSize: 14,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ))))
      ],
    );
  }
}
