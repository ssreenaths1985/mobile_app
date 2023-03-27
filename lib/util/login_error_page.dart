import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/oAuth2_login.dart';
import 'package:karmayogi_mobile/signup.dart';
import 'package:karmayogi_mobile/ui/widgets/_signup/contact_us.dart';

import '../constants/_constants/color_constants.dart';

class LoginErrorPage extends StatelessWidget {
  final String errorText;
  final isHtmlErrorPage;
  const LoginErrorPage({Key key, this.errorText, this.isHtmlErrorPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Image.asset('assets/img/igot_icon.png'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: !isHtmlErrorPage
                              ? Text(
                                  errorText != null
                                      ? errorText
                                      : EnglishLang.somethingWrong,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.negativeLight,
                                  ))
                              : HtmlWidget(
                                  errorText,
                                  textStyle:
                                      TextStyle(color: AppColors.negativeLight),
                                ),
                        ),
                        TextButton(
                            onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ContactUs(),
                                  ),
                                ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                EnglishLang.contactUs,
                                style: TextStyle(
                                    color: AppColors.primaryThree,
                                    fontSize: 16),
                              ),
                            )),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         primary: AppColors.primaryThree,
                    //         minimumSize: const Size.fromHeight(40), // NEW
                    //       ),
                    //       onPressed: () {
                    //         Navigator.of(context).pushReplacement(
                    //           MaterialPageRoute(
                    //             builder: (context) => OAuth2Login(),
                    //           ),
                    //         );
                    //       },
                    //       child: Text(
                    //         'Click here to login',
                    //         style: TextStyle(
                    //             fontSize: 16, fontWeight: FontWeight.w700),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 4,
                    //     ),
                    //     TextButton(
                    //       style: ElevatedButton.styleFrom(
                    //         primary: Colors.white,
                    //         minimumSize: const Size.fromHeight(40), // NEW
                    //       ),
                    //       onPressed: () {
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (context) => SignUpPage()));
                    //       },
                    //       child: Text(
                    //         'Sign Up',
                    //         style: TextStyle(
                    //             fontSize: 14,
                    //             color: AppColors.primaryThree,
                    //             fontWeight: FontWeight.w700),
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 135,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryThree,
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OAuth2Login(),
                      ),
                    );
                  },
                  child: Text(
                    EnglishLang.clickHereToLogin,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    EnglishLang.signUp,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryThree,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
