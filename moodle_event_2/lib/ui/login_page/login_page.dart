import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/string_constants.dart';
import 'package:moodle_event_2/ui/home_page/home_page_viewmodel.dart';
import 'package:moodle_event_2/ui/login_page/login_state.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatelessWidget {
  LoginState _state = LoginState.undefined;
  WebViewController? _webViewController;

  LoginPage({Key? key}) : super(key: key) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  /// セッションキー(sess)を取得する
  Future<String> getSessionKey() async {
    String sessionKey = "";
    if (this._webViewController != null && this._state == LoginState.finish) {
      sessionKey = await this._webViewController!.runJavascriptReturningResult(
          '(function (){return YUI.config["global"]["M"]["cfg"]["sesskey"];})()');
    }

    return sessionKey.replaceAll("\"", "");
  }

  ///
  /// 1段階目の認証ページか
  ///
  Future<bool> _isFirstLoginPage() async {
    if (this._webViewController == null) {
      return false;
    }
    return await this._webViewController!.runJavascriptReturningResult(
            "document.getElementById('username')") !=
        "null";
  }

  ///
  /// URLごとの処理
  ///
  Future<void> _urlMatching(String url, BuildContext context) async {
    if (StringConstants.GAKUNIN_REG_EXP.hasMatch(url)) {
      if (await this._isFirstLoginPage()) {
        debugLog("first page");
        this._state = LoginState.firstLogin;
      } else {
        debugLog("second page");
        this._state = LoginState.secondLogin;
      }
    } else if (StringConstants.MOODLE_REG_EXP.hasMatch(url)) {
      debugLog("load fin");
      this._state = LoginState.finish;
      String sessionKey = await this.getSessionKey();
      await context.read<HomePageViewModel>().updateSessionKey(sessionKey);
      Navigator.of(context).pop();
    } else if (RegExp(StringConstants.MOODLE_AUTH_URL).hasMatch(url)) {
      this._state = LoginState.redirect;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: StringConstants.MOODLE_AUTH_URL,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) async {
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
