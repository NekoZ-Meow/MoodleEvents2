import 'package:flutter/material.dart';
import 'package:moodle_event_2/ui/login_page/login_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPageViewModel with ChangeNotifier {
  LoginState _state = LoginState.undefined;
  WebViewController? _controller;

  WebViewController? get controller => this._controller;

  /// コンストラクタ
  LoginPageViewModel();

  /// セッションキー(sess)を取得する
  Future<String> getSessionKey() async {
    String sessionKey = "";
    if (this.controller != null && this._state == LoginState.finish) {
      sessionKey = await this._controller!.runJavascriptReturningResult(
          '(function (){return YUI.config["global"]["M"]["cfg"]["sesskey"];})()');
    }

    return sessionKey.replaceAll("\"", "");
  }

  void setWebViewController(WebViewController controller) {
    this._controller = controller;

    return;
  }
}
