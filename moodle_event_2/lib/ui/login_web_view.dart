import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/Constants/Constants.dart';
import "package:moodle_event_2/Utility/DebugUtility.dart";
import 'package:webview_flutter/webview_flutter.dart';

enum _PageState {
  Undefined,
  Redirect,
  FirstLogin,
  SecondLogin,
  Finish,
}

class LoginWebView extends StatelessWidget {
  WebViewController _webViewController;
  _PageState _pageState = _PageState.Undefined;
  bool _isUrlLoading = false;
  bool _popWhenAuthorized = false;
  BuildContext _context;

  ///
  /// コンストラクタ
  ///
  LoginWebView({Key key, bool popWhenAuthorized = false, BuildContext context})
      : super(key: key) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    this._popWhenAuthorized = popWhenAuthorized;
    this._context = context;
  }

  ///
  /// 認証済みか
  ///
  Future<bool> isAuthorized() async {
    await this._loadUrl(Constants.MOODLE_AUTH_URL);
    await Future.doWhile(() => (this._pageState == _PageState.Redirect));

    if (this._pageState == _PageState.Finish)
      return true;
    else
      return false;
  }

  ///
  /// セッションキー(sess)を取得する
  ///
  Future<String> getSessionKey() async {
    String sess = "";
    if (this._pageState == _PageState.Finish) {
      sess = await this._webViewController.evaluateJavascript(
          '(function (){return YUI.config["global"]["M"]["cfg"]["sesskey"];})()');
    }

    return sess.replaceAll("\"", "");
  }

  ///
  /// URLをロードする
  ///
  Future<void> _loadUrl(String url) async {
    this._pageState = _PageState.Undefined;
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
  Future<void> _urlMatching(String url) async {
    if (Constants.GAKUNIN_REG_EXP.hasMatch(url)) {
      debugLog("login page");
      if (await this._isFirstLoginPage()) {
        this._pageState = _PageState.FirstLogin;
      } else {
        this._pageState = _PageState.SecondLogin;
      }
    } else if (Constants.MOODLE_REG_EXP.hasMatch(url)) {
      debugLog("load fin");
      this._pageState = _PageState.Finish;
      if (this._popWhenAuthorized) {
        Navigator.of(this._context).pop();
      }
    } else if (new RegExp(Constants.MOODLE_AUTH_URL).hasMatch(url)) {
      this._pageState = _PageState.Redirect;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Container(
        child: WebView(
          initialUrl: Constants.MOODLE_AUTH_URL,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (url) async {
            this._isUrlLoading = false;
            debugLog(url);
            await this._urlMatching(url);
          },
          onWebViewCreated: (WebViewController controller) {
            this._webViewController = controller;
          },
        ),
      ),
    );
  }
}
