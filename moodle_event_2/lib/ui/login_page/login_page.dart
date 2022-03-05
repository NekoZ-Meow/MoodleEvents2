import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/string_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: StringConstants.MOODLE_AUTH_URL,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) async {
          this._isUrlLoading = false;
          debugLog(url);
          await this._urlMatching(url, context);
        },
        onWebViewCreated: (WebViewController controller) {
          this._webViewController = controller;
        },
      ),
    );
  }
}
