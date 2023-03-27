import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'localization/_langs/english_lang.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/img/Login_background.svg',
          // alignment: Alignment.center,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Center(
          child: Container(
              child: SvgPicture.asset(
            'assets/img/KarmayogiBharat_Logo.svg',
            // width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.45,
            fit: BoxFit.fitHeight,
          )),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          alignment: Alignment.bottomCenter,
          child: Text(
            EnglishLang.publicCopyRightText,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
