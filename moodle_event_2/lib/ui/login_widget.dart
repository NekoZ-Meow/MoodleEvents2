import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/model/model.dart';
import 'package:moodle_event_2/model/server_interface/server_interface.dart';
import 'package:moodle_event_2/ui/login_web_view.dart';
import 'package:moodle_event_2/user_manager/user_manager.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:provider/provider.dart';

import 'root_widget.dart';

///
/// 認証自動化する際に使用する予定
///

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  int _loginCount = 0;
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
    UserManager user = Provider.of<Model>(context).user;
    try {
      if (await isSessKeyValid(user.sessKey)) {
        return true;
      } else {
        await Navigator.of(this.context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginWebView(
                popWhenAuthorized: true,
              );
            },
          ),
        );
        if (await this._loginWebView.isAuthorized()) {
          return true;
        }
      }
    } catch (exception) {
      debugLog(exception.toString());
    }

    return false;
  }

  ///
  /// セッションキー(sess)を取得する
  ///
  Future<String?> getSessionKey() async {
    if (await this.waitLogin()) {
      return await this._loginWebView.getSessionKey();
    }
    return null;
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
        RootWidget(),
      ],
    );
  }
}
