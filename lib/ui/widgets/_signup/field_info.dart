import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/ui/widgets/_signup/contact_us.dart';

class FieldInfo extends StatelessWidget {
  const FieldInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        // insetPadding: EdgeInsets.symmetric(horizontal: 0),
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0.25,
                      height: 1.5),
                  text:
                      'If you do not find your department or organization in the list here, please ',
                ),
                TextSpan(
                  style: GoogleFonts.lato(
                      color: AppColors.primaryThree,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.25,
                      height: 1.5),
                  text: 'contact us',
                  recognizer: TapGestureRecognizer()
                    ..onTap = (() => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactUs()),
                        )),
                ),
                TextSpan(
                  style: GoogleFonts.lato(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0.25,
                      height: 1.5),
                  text: ' to get it added.',
                ),
              ],
            ),
          ),
        ));
  }
}
