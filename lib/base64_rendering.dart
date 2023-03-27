import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:karmayogi_mobile/constants/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Base64Rendering extends StatefulWidget {
  final certificate;

  Base64Rendering(this.certificate);
  @override
  _Base64RenderingState createState() => _Base64RenderingState();
}

class _Base64RenderingState extends State<Base64Rendering> {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text('Back'),
          backgroundColor: Colors.white),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.download_sharp),
      //   onPressed: () async {
      //     print('Clicked');
      //     _controller.evaluateJavascript(
      //         "document.getElementById('btn-download').style.display='none'");
      //   },
      // ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText =
        await rootBundle.loadString('assets/html/base64-image.html');
    fileText = fileText.replaceFirst(":base64Data", widget.certificate);
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
