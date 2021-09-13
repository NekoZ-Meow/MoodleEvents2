import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/UserManager/UserManager.dart';
import 'package:moodle_event_2/ui/login_web_view.dart';

import 'RootWidget.dart';

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  int _loginCount = 0;
  UserManager user = UserManager();
  LoginWebView _loginWebView = new LoginWebView();

  @override
  void initState() {
    super.initState();
  }

  ///
  /// ログインを待つ
  /// 成功した場合true それ以外false
  ///
  Future<bool> waitLogin() async {
    if (await this._loginWebView.isAuthorized()) {
      return true;
    } else {
      await Navigator.of(this.context).push(
        MaterialPageRoute(
          builder: (context) {
            return LoginWebView(
              popWhenAuthorized: true,
              context: context,
            );
          },
        ),
      );
      if (await this._loginWebView.isAuthorized()) {
        return true;
      }
    }

    return false;
  }

  ///
  /// セッションキー(sess)を取得する
  ///
  Future<String> getSessionKey() async {
    return await this._loginWebView.getSessionKey();
  }

  // ///
  // /// 1段階目の認証処理
  // ///
  // Future<void> _firstLogin() async {
  //   String id = this.user.userId;
  //   String pass = this.user.password;
  //
  //   print(this.user.userId);
  //   await Future.wait(<Future>[
  //     this._webViewController.evaluateJavascript(
  //         "document.getElementById('username').value='$id'"),
  //     this._webViewController.evaluateJavascript(
  //         "document.getElementById('password').value='$pass'")
  //   ]);
  //   this._webViewController.evaluateJavascript(
  //       "document.getElementsByClassName('form-element form-button')[0].click()");
  // }
  //
  // ///
  // /// 二段階目の認証処理
  // ///
  // Future<void> _secondLogin() async {
  //   String auth = getAuthPass(this.user.authKey);
  //   await this
  //       ._webViewController
  //       .evaluateJavascript("document.getElementById('token').value='$auth'");
  //   this._webViewController.evaluateJavascript(
  //       "document.getElementsByClassName('form-element form-button')[0].click()");
  // }
  //

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: true,
          child: this._loginWebView,
        ),
        RootWidget(this, this.user),
      ],
    );
  }
}
