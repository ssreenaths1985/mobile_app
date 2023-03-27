import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/env/env.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text('Terms of Service',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.25,
            )),
      ),
      body: WebView(
        initialUrl: Env.termsOfServiceUrl,
      ),
    );
  }
}
