import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants/index.dart';
import './respositories/index.dart';
import './ui/widgets/index.dart';
import './localization/index.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  static const route = AppUrl.loginPage;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool emailHasFocus = false;
  bool passwordHasFocus = false;
  String errMsg;
  final _storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Widget _banner() {
  //   return Stack(
  //     children: [
  //       SizedBox(
  //         width: double.infinity,
  //         child: SvgPicture.asset(
  //           'assets/img/Login_background.svg',
  //           fit: BoxFit.cover,
  //           height: (!passwordHasFocus && !emailHasFocus) ? 235 : 75,
  //           // alignment: Alignment.topLeft,
  //         ),
  //       ),
  //       Center(
  //         child: Container(
  //           margin: EdgeInsets.only(top: 35.0),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             shape: BoxShape.circle,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: AppColors.grey08,
  //                 blurRadius: 3,
  //                 spreadRadius: 0,
  //                 offset: Offset(
  //                   3,
  //                   3,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           child: CircleAvatar(
  //             radius: 40.0,
  //             backgroundColor: Colors.white,
  //             child: Center(
  //               child: Image.asset(
  //                 'assets/img/igot_icon.png',
  //                 width: 50.0,
  //                 height: 50.0,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       (!passwordHasFocus && !emailHasFocus)
  //           ? Padding(
  //               padding: EdgeInsets.only(top: 10.0),
  //               child: Container(
  //                 margin: EdgeInsets.only(top: 110.0),
  //                 child: Center(
  //                   child: Text(
  //                     EnglishLang.karmayogiBharat,
  //                     style: GoogleFonts.montserrat(
  //                         color: AppColors.greys87,
  //                         fontSize: 24.0,
  //                         fontWeight: FontWeight.w700),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           : Center(),
  //       (!passwordHasFocus && !emailHasFocus)
  //           ? Padding(
  //               padding: EdgeInsets.only(top: 10.0),
  //               child: Container(
  //                 margin: EdgeInsets.only(top: 155.0),
  //                 child: Center(
  //                   child: SizedBox(
  //                     width: MediaQuery.of(context).size.width - 20,
  //                     height: 50.0,
  //                     child: Text(
  //                       EnglishLang.loginSubTitle,
  //                       textAlign: TextAlign.center,
  //                       style: GoogleFonts.lato(
  //                           color: AppColors.greys87,
  //                           fontSize: 16.0,
  //                           fontWeight: FontWeight.w400),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           : Center(),
  //     ],
  //   );
  // }

  Widget _emailField() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EnglishLang.email,
              style: GoogleFonts.lato(
                color: AppColors.greys87,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              height: 50.0,
              child: Focus(
                child: TextFormField(
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocus,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _emailFocus, _passwordFocus);
                  },
                  controller: _emailController,
                  style: GoogleFonts.lato(fontSize: 14.0),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    border: OutlineInputBorder(),
                    hintText: EnglishLang.email,
                    hintStyle: GoogleFonts.lato(
                        color: AppColors.grey40,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.primaryThree, width: 1.0),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    setState(() {
                      emailHasFocus = true;
                    });
                  } else {
                    emailHasFocus = false;
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EnglishLang.password,
              style: GoogleFonts.lato(
                color: AppColors.greys87,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              height: 50.0,
              child: Focus(
                child: TextFormField(
                  style: GoogleFonts.lato(fontSize: 14.0),
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    hintText: EnglishLang.password,
                    hintStyle: GoogleFonts.lato(
                        color: AppColors.grey40,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.primaryThree, width: 1.0),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    setState(() {
                      passwordHasFocus = true;
                    });
                  } else {
                    setState(() {
                      passwordHasFocus = false;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
      child: Container(
        // padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () => _login(),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.primaryThree),
          ),
          // padding: EdgeInsets.all(15.0),
          child: Text(
            'Sign in',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final authDetails =
          await Provider.of<LoginRespository>(context, listen: false)
              .loadData(email, password);

      if (authDetails.accessToken != null &&
          email.isNotEmpty &&
          password.isNotEmpty) {
        // print(authDetails.accessToken);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CustomTabs(
              customIndex: 0,
              token: authDetails.accessToken,
            ),
          ),
        );
      } else {
        errMsg =
            Provider.of<LoginRespository>(context, listen: false).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errMsg),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        // print(errMsg);
      }
    } catch (err) {
      return err;
    }
  }

  // Widget _version() {
  //   return Center(
  //     child: Container(
  //       margin: EdgeInsets.only(top: 18.0),
  //       child: Text(
  //         'Release ' + APP_VERSION,
  //         style: GoogleFonts.lato(
  //           color: AppColors.primaryThree,
  //           fontSize: 12.0,
  //           fontWeight: FontWeight.w700,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _forgotPassword() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Text(
          EnglishLang.forgotPassword,
          style: GoogleFonts.lato(
              color: AppColors.primaryThree,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              height: 1.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomSheet: Container(
        height: 344,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0)),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey08,
                blurRadius: 9,
                spreadRadius: 0,
                offset: Offset(
                  0,
                  -2,
                ),
              ),
            ]),
        child: Column(
          children: [
            _emailField(),
            _passwordField(),
            _loginBtn(),
            _forgotPassword()
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          SvgPicture.asset(
            'assets/img/Login_background.svg',
            alignment: Alignment.center,
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: (!passwordHasFocus && !emailHasFocus)
                      ? EdgeInsets.only(top: 128.0)
                      : EdgeInsets.only(top: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey08,
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(
                          3,
                          3,
                        ),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Image.asset(
                        'assets/img/igot_icon.png',
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                  ),
                ),
                (!passwordHasFocus && !emailHasFocus)
                    ? Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Container(
                          child: Center(
                            child: Text(
                              EnglishLang.karmayogiBharat,
                              style: GoogleFonts.montserrat(
                                  color: AppColors.greys87,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      )
                    : Center(),
                (!passwordHasFocus && !emailHasFocus)
                    ? Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 20,
                              height: 50.0,
                              child: Text(
                                EnglishLang.loginSubTitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.25,
                                    height: 1.5),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
