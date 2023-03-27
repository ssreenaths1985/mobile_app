import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/landing_page.dart';
// import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'dart:developer' as developer;

class UpdatePassword extends StatefulWidget {
  final String initialUrl;

  const UpdatePassword({Key key, this.initialUrl}) : super(key: key);
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
    // _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Flutter WebView example'),
      //   // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      // ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            SafeArea(
              child: WebView(
                debuggingEnabled: true,
                initialUrl: widget.initialUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  // print("WebView is loading (progress : $progress%)");
                },
                navigationDelegate: (NavigationRequest request) async {
                  // print('Request URL: ' + request.url.toString());
                  if ((request.url
                      .contains(ApiUrl.baseUrl + ApiUrl.loginShortUrl))) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LandingPage(
                          isFromUpdateScreen: true,
                        ),
                      ),
                    );
                  }
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  // print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  // print('Page finished loading: $url');
                  // if (mounted)
                  //   setState(() {
                  //     _isLoading = false;
                  //   });
                },
                // gestureNavigationEnabled: true,
              ),
            ),
            // _isLoading ? Center(child: PageLoader()) : Center()
          ],
        );
      }),
      floatingActionButton: Center(),
    );
  }
}
