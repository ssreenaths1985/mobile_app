import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class ErrorPage extends StatelessWidget {
  final isVegaError;
  ErrorPage({this.isVegaError = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: !isVegaError ? 160 : 16),
                  child: SvgPicture.asset(
                    'assets/img/Unexpected_error.svg',
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'OOPS!',
                style: GoogleFonts.montserrat(
                    color: AppColors.primaryThree,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    height: 1.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                !isVegaError
                    ? "Something is not right!"
                    : "There’s a connection error right now",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 0.12,
                    height: 1.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'We are sorry for the inconvenience \n    Please come back after a while.',
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.5,
                  letterSpacing: 0.25,
                ),
              ),
            ),
            !isVegaError
                ? Padding(
                    padding: const EdgeInsets.only(top: 24),
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
      ],
    );
  }
}
