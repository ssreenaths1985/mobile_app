import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';

class EmptyState extends StatelessWidget {
  final bool isDiscuss;
  final bool isNetwork;
  final String messageHeading ;
  final String message;

  
  EmptyState(Map<String, Object> map,
      {this.isDiscuss = false, this.isNetwork = false, this.messageHeading = '', this.message = ''});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Container(
              child: Center(
                child: isDiscuss == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: SvgPicture.asset(
                          'assets/img/discussions.svg',
                          alignment: Alignment.center,
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 160),
                        child: SvgPicture.asset(
                          'assets/img/connections.svg',
                          alignment: Alignment.center,
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                messageHeading,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.5,
                  letterSpacing: 0.25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                message,
                style: GoogleFonts.lato(
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.5,
                  letterSpacing: 0.25,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
