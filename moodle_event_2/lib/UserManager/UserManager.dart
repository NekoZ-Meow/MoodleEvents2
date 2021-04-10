import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

final String userFileName = "user"; // ファイル名
final String fileVersion = "0"; //ファイルバージョン

///
/// ユーザデータを管理するクラス
///
class UserManager {
  String userId = ""; //ユーザID
  String password = ""; //パスワード
  String authKey = ""; //二段階認証秘密鍵
  String seesKey = ""; //セッションキー
  bool isLogin = false; //ログイン済みか

  UserManager() {
    this._readUserFile();
  }

  ///
  /// Userファイルからデータを読み取る
  ///
  Future<void> _readUserFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = directory.path + "/" + userFileName;
    File aFile = File(filePath);
    if (!await aFile.exists()) {
      await this._createUserFile(aFile);
      return;
    }

    Map<String, dynamic> jsonString = jsonDecode(await aFile.readAsString());
    String version = jsonString["version"];
    if (version != fileVersion) {
      _createUserFile(aFile);
      return;
    }

    this.userId = jsonString["userId"];
    this.password = jsonString["password"];
    this.authKey = jsonString["authKey"];
  }

  ///
  /// Userファイルを新規作成する
  ///
  Future<void> _createUserFile(File aFile) async {
    await aFile.create();
    print("File Created:" + aFile.path);
    await aFile.writeAsString(jsonEncode({
      "version": fileVersion,
      "userId": this.userId,
      "password": this.password,
      "authKey": this.authKey
    }));
  }
}
