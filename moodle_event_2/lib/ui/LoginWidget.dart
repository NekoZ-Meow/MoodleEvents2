import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/UserManager/UserManager.dart';
import 'package:moodle_event_2/auth/AuthUtility.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  WebViewController _webViewController;
  int _loginCount = 0;
  UserManager user = UserManager();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  ///
  /// 1段階目の認証ページか
  ///
  Future<bool> _isFirstLoginPage() async {
    return await this
            ._webViewController
            .evaluateJavascript("document.getElementById('username')") ==
        "null";
  }

  ///
  /// 1段階目の認証処理
  ///
  Future<void> _firstLogin() async {
    String id = this.user.userId;
    String pass = this.user.password;
    await Future.wait(<Future>[
      this._webViewController.evaluateJavascript(
          "document.getElementById('username').value='$id'"),
      this._webViewController.evaluateJavascript(
          "document.getElementById('password').value='$pass'")
    ]);
    this._webViewController.evaluateJavascript(
        "document.getElementsByClassName('form-element form-button')[0].click()");
  }

  ///
  /// 二段階目の認証処理
  ///
  Future<void> _secondLogin() async {
    String auth = getAuthPass(this.user.authKey);
    await this
        ._webViewController
        .evaluateJavascript("document.getElementById('token').value='$auth'");
    this._webViewController.evaluateJavascript(
        "document.getElementsByClassName('form-element form-button')[0].click()");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: "https://cclms.kyoto-su.ac.jp/auth/shibboleth/index.php",
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (url) async {
            this._loginCount += 1;
            if (this._loginCount > 10) {
              return;
            }
            print(url);
            if (new RegExp(
                    r"https://gakunin.kyoto-su.ac.jp/idp/profile/SAML2/Redirect/SSO\?execution=e[0-9]+s[0-9]+.?")
                .hasMatch(url)) {
              if (await this._isFirstLoginPage()) {
                await _secondLogin();
              } else {
                await this._firstLogin();
              }
            }
          },
          onWebViewCreated: (WebViewController controller) {
            this._webViewController = controller;
          },
        ));
  }
}
