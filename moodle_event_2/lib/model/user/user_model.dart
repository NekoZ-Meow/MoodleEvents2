import 'dart:convert';
import 'dart:io';

import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

///
/// ユーザデータを管理するクラス
/// シングルトンであり、唯一のインスタンスを返す
///
class UserModel {
  static const String userFileName = "user"; // ファイル名
  static const String fileVersion = "0"; //ファイルバージョン
  static UserModel? _singletonInstance; // シングルトンであるUserのインスタンス

  String userId = ""; //ユーザID
  String password = ""; //パスワード
  String authKey = ""; //二段階認証秘密鍵
  String sessKey = ""; //セッションキー

  factory UserModel() {
    UserModel._singletonInstance ??= UserModel._();
    return UserModel._singletonInstance!;
  }

  /// プライベートコンストラクタ
  UserModel._();

  ///
  /// user情報を保存する
  ///
  Future<void> saveUser() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File userFile = File(path.join(rootSavePath, UserModel.userFileName));
    String userJson = json.encode(this.toJson());
    await userFile.writeAsString(userJson);

    return;
  }

  ///
  /// user情報を読み込む
  /// ファイルが存在しない場合はnull
  ///
  Future<void> loadUser() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File userFile = File(path.join(rootSavePath, UserModel.userFileName));

    if (await userFile.exists()) {
      Map<String, dynamic> jsonMap = json.decode(await userFile.readAsString());
      if (jsonMap["version"] != fileVersion) {
        debugLog("file version dose not same.");
        return;
      }
      this.userId = jsonMap["userId"];
      this.password = jsonMap["password"];
      this.authKey = jsonMap["authKey"];
      this.sessKey = jsonMap["sessKey"];
    }
    return;
  }

  ///
  /// このクラスをJsonに変換する
  ///
  Map<String, dynamic> toJson() => {
        "version": fileVersion,
        "userId": this.userId,
        "password": this.password,
        "authKey": this.authKey,
        "sessKey": this.sessKey,
      };
}
