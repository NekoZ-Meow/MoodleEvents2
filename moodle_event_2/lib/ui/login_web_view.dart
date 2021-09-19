import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:moodle_event_2/Utility/debug_utility.dart";
import 'package:moodle_event_2/constants/string_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum PageState {
  Undefined,
  Redirect,
  FirstLogin,
  SecondLogin,
  Finish,
}

class LoginWebView extends StatelessWidget {
  WebViewController _webViewController;
  PageState _pageState = PageState.Undefined;
  bool _isUrlLoading = false;
  bool _popWhenAuthorized = false;

  PageState get pageState => this._pageState;

  ///
  /// コンストラクタ
  ///
  LoginWebView({Key key, bool popWhenAuthorized = false}) : super(key: key) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    this._popWhenAuthorized = popWhenAuthorized;
  }

  ///
  /// 認証済みか
  ///
  Future<bool> isAuthorized() async {
    await this._loadUrl(StringConstants.MOODLE_AUTH_URL);
    await Future.doWhile(() => (this._pageState == PageState.Redirect));

    if (this._pageState == PageState.Finish)
      return true;
    else
      return false;
  }

  ///
  /// セッションキー(sess)を取得する
  ///
  Future<String> getSessionKey() async {
    String sess = "";
    if (this._pageState == PageState.Finish) {
      sess = await this._webViewController.evaluateJavascript(
          '(function (){return YUI.config["global"]["M"]["cfg"]["sesskey"];})()');
    }

    return sess.replaceAll("\"", "");
  }

  ///
  /// URLをロードする
  ///
  Future<void> _loadUrl(String url) async {
    this._pageState = PageState.Undefined;
    this._isUrlLoading = true;
    await this._webViewController.loadUrl(url);
    await Future.doWhile(() async {
      await new Future.delayed(new Duration(milliseconds: 100));
      return this._isUrlLoading;
    });
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
  /// URLごとの処理
  ///
  Future<void> _urlMatching(String url, BuildContext context) async {
    if (StringConstants.GAKUNIN_REG_EXP.hasMatch(url)) {
      debugLog("login page");
      if (await this._isFirstLoginPage()) {
        this._pageState = PageState.FirstLogin;
      } else {
        this._pageState = PageState.SecondLogin;
      }
    } else if (StringConstants.MOODLE_REG_EXP.hasMatch(url)) {
      debugLog("load fin");
      this._pageState = PageState.Finish;
      if (this._popWhenAuthorized) {
        Navigator.of(context).pop(await this.getSessionKey());
      }
    } else if (new RegExp(StringConstants.MOODLE_AUTH_URL).hasMatch(url)) {
      this._pageState = PageState.Redirect;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Container(
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
      ),
    );
  }
}
