import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:moodle_event_2/Utility/debug_utility.dart";
import 'package:moodle_event_2/constants/string_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _PageState {
  Undefined,
  Redirect,
  FirstLogin,
  SecondLogin,
  Finish,
}

class LoginWebView extends StatelessWidget {
  WebViewController? _webViewController;
  _PageState _pageState = _PageState.Undefined;
  bool _isUrlLoading = false;
  bool _popWhenAuthorized = false;

  ///
  /// コンストラクタ
  ///
  LoginWebView({Key? key, bool popWhenAuthorized = false}) : super(key: key) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    this._popWhenAuthorized = popWhenAuthorized;
  }

  ///
  /// 認証済みか
  ///
  Future<bool> isAuthorized() async {
    await this._loadUrl(StringConstants.MOODLE_AUTH_URL);
    await Future.doWhile(() => (this._pageState == _PageState.Redirect));

    if (this._pageState == _PageState.Finish) {
      return true;
    }
    return false;
  }

  ///
  /// セッションキー(sess)を取得する
  ///
  Future<String> getSessionKey() async {
    String sess = "";
    if (this._webViewController != null &&
        this._pageState == _PageState.Finish) {
      sess = await this._webViewController!.evaluateJavascript(
          '(function (){return YUI.config["global"]["M"]["cfg"]["sesskey"];})()');
    }

    return sess.replaceAll("\"", "");
  }

  ///
  /// URLをロードする
  ///
  Future<void> _loadUrl(String url) async {
    if (this._webViewController == null) {
      return;
    }
    this._pageState = _PageState.Undefined;
    this._isUrlLoading = true;
    await this._webViewController!.loadUrl(url);
    await Future.doWhile(() async {
      await new Future.delayed(Duration(milliseconds: 100));
      return this._isUrlLoading;
    });
  }

  ///
  /// 1段階目の認証ページか
  ///
  Future<bool> _isFirstLoginPage() async {
    if (this._webViewController == null) {
      return false;
    }
    return await this
            ._webViewController!
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
        this._pageState = _PageState.FirstLogin;
      } else {
        this._pageState = _PageState.SecondLogin;
      }
    } else if (StringConstants.MOODLE_REG_EXP.hasMatch(url)) {
      debugLog("load fin");
      this._pageState = _PageState.Finish;
      if (this._popWhenAuthorized) {
        Navigator.of(context).pop(await this.getSessionKey());
      }
    } else if (RegExp(StringConstants.MOODLE_AUTH_URL).hasMatch(url)) {
      this._pageState = _PageState.Redirect;
    }
  }

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
