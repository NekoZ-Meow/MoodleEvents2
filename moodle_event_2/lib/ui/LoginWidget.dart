import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/UserManager/UserManager.dart';
import 'package:moodle_event_2/auth/AuthUtility.dart';
import 'package:moodle_event_2/ui/RootWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  WebViewController _webViewController;
  int _loginCount = 0;
  UserManager user = UserManager();
  bool _isUrlLoading = false;
  bool _isProcess = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<bool> _login() async {
    this._isProcess = true;
    this._isError = false;
    //await this._loadUrl("https://www.kyoto-su.ac.jp");
    await this
        ._webViewController
        .loadUrl("https://cclms.kyoto-su.ac.jp/auth/shibboleth/");
    int _webViewErrorCount = 0;
    await Future.doWhile(() async {
      _webViewErrorCount += 1;
      await new Future.delayed(new Duration(milliseconds: 500));
      if (_webViewErrorCount == 50) {
        this._isError = true;
        return false;
      }
      return _isProcess;
    });
    if (this._isError) {
      print("login error");
      return false;
    }
    print("login success");
    return true;
  }

  ///
  /// 1段階目の認証ページか
  ///
  Future<bool> _isFirstLoginPage() async {
    return await this
            ._webViewController
            .evaluateJavascript("document.getElementById('username')") !=
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

  Future<String> getSessionKey() async {
    String sess = "";
    if (await this._login()) {
      sess = await this._webViewController.evaluateJavascript(
          '(function (){return YUI.config["global"]["M"]["cfg"]["sesskey"];})()');
    }
    print(sess.replaceAll("\"", ""));
    return sess.replaceAll("\"", "");
  }

  Future<void> _loadUrl(String url) async {
    this._isUrlLoading = true;
    await this._webViewController.loadUrl(url);
    await Future.doWhile(() async {
      await new Future.delayed(new Duration(milliseconds: 100));
      return this._isUrlLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Visibility(
          visible: true,
          // maintainSize: true,
          // maintainState: true,
          child: WebView(
            initialUrl: "https://www.google.com/?hl=ja",
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) async {
              this._isUrlLoading = false;
              this._loginCount += 1;
              if (this._loginCount > 10) {
                this._isError = true;
                this._isProcess = false;
                return;
              }
              print(url);
              if (new RegExp(
                      r"https://gakunin.kyoto-su.ac.jp/idp/profile/SAML2/Redirect/SSO\?execution=e[0-9]+s[0-9]+.?")
                  .hasMatch(url)) {
                if (await this._isFirstLoginPage()) {
                  await this._firstLogin();
                } else {
                  await this._secondLogin();
                }
              } else if (new RegExp(r"https://cclms.kyoto-su.ac.jp/?")
                  .hasMatch(url)) {
                print("load fin");
                this._isProcess = false;
              }
            },
            onWebViewCreated: (WebViewController controller) {
              this._webViewController = controller;
            },
          )),
      RootWidget(this, this.user),
    ]);
  }
}
