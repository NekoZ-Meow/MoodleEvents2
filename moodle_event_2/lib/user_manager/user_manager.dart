import 'package:moodle_event_2/utility/debug_utility.dart';

///
/// ユーザデータを管理するクラス
///
class UserManager {
  static const String userFileName = "user"; // ファイル名
  static const String fileVersion = "0"; //ファイルバージョン

  String userId = ""; //ユーザID
  String password = ""; //パスワード
  String authKey = ""; //二段階認証秘密鍵
  String sessKey = ""; //セッションキー

  UserManager() {
    //this.readUserFile();
  }

  ///
  /// jsonからこのクラスに変換する
  ///
  UserManager.fromJson(Map<String, dynamic> json) {
    if (json["version"] != fileVersion) {
      debugLog("file version dose not same.");
      return;
    }
    this.userId = json["userId"];
    this.password = json["password"];
    this.authKey = json["authKey"];
    this.sessKey = json["sessKey"];
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
