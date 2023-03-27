import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'package:karmayogi_mobile/constants/_constants/storage_constants.dart';
import 'package:karmayogi_mobile/constants/index.dart';
import 'package:karmayogi_mobile/localization/index.dart';
import 'package:karmayogi_mobile/respositories/_respositories/login_respository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:karmayogi_mobile/signup.dart';
import 'package:karmayogi_mobile/ui/widgets/custom_tabs.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'dart:developer' as developer;

import 'models/_models/login_model.dart';
import 'ui/widgets/_common/page_loader.dart';

class OAuth2Login extends StatefulWidget {
  @override
  _OAuth2LoginState createState() => _OAuth2LoginState();
}

class _OAuth2LoginState extends State<OAuth2Login> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final _storage = FlutterSecureStorage();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
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
                initialUrl: ApiUrl.baseUrl + ApiUrl.loginUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  // print("WebView is loading (progress : $progress%)");
                },
                navigationDelegate: (NavigationRequest request) async {
                  // print('Request URL: ' + request.url.toString());
                  if (request.url.startsWith(ApiUrl.loginRedirectUrl)) {
                    Uri url = Uri.parse(request.url);
                    String code = url.queryParameters[Storage.code];
                    _storage.write(key: Storage.code, value: code);
                    // Getting AUthentication & Refresh Tokens
                    Login _loginDetails = await Provider.of<LoginRespository>(
                            context,
                            listen: false)
                        .fetchOAuthTokens(code);
                    if (_loginDetails.accessToken != null) {
                      return Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CustomTabs(
                            customIndex: 0,
                            token: _loginDetails.accessToken,
                          ),
                        ),
                      );
                    }
                    return NavigationDecision.prevent;
                  }
                  if (request.url.startsWith(ApiUrl.parichayLoginRedirectUrl)) {
                    Uri url = Uri.parse(request.url);
                    String code = url.queryParameters[Storage.code];
                    _storage.write(key: Storage.parichayCode, value: code);
                    // developer.log('Code: ' + code.toString());
                    if (code != null) {
                      if (code.runtimeType != String) {
                        Helper.showErrorScreen(
                            context, EnglishLang.codeParamsInvalid);
                      }
                      await Provider.of<LoginRespository>(context,
                              listen: false)
                          .fetchParichayToken(code, context);
                    } else {
                      Helper.showErrorScreen(
                          context, EnglishLang.codeParamsMissing);
                    }
                  }
                  if (request.url.startsWith(ApiUrl.parichayAuthLoginUrl)) {
                    Uri url = Uri.parse(request.url);
                    String redirectUrl =
                        url.queryParameters[Storage.redirectUrl];
                    _storage.write(
                        key: Storage.redirectUrl, value: redirectUrl);
                    // developer.log('redirect url: ' + redirectUrl.toString());
                  }
                  // else if (request.url.startsWith(ApiUrl.loginWebUrl)) {
                  //   return Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(
                  //       builder: (context) => OAuth2Login(),
                  //     ),
                  //   );
                  // }
                  else if (request.url == ApiUrl.signUpWebUrl) {
                    return Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  }
                  // if (request.url == 'https://igot-dev.in/public/home') {
                  //   print('On home page');
                  // }
                  // print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  // print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  // print('Page finished loading: $url');
                  if (mounted)
                    setState(() {
                      _isLoading = false;
                    });
                },
                // gestureNavigationEnabled: true,
              ),
            ),
            _isLoading ? Center(child: PageLoader()) : Center()
          ],
        );
      }),
      floatingActionButton: Center(),
    );
  }
}
