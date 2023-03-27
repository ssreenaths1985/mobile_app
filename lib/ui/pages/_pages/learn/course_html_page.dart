import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';

class HtmlPage extends StatelessWidget {
  final String url;
  HtmlPage(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.clear, color: AppColors.greys60),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SCROM Player',
          style: GoogleFonts.montserrat(
            color: AppColors.greys87,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        // centerTitle: true,
      ),
      body: Center(
        child: HtmlWidget(
          '''<iframe src="https://test-player-001.herokuapp.com/" width="300" title="Iframe Example"></iframe>''',
          webView: true,
        ),
      ),
    );
  }
}
