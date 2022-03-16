import 'dart:convert';
import 'dart:io';

import 'package:moodle_event_2/model/user/user.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

///
/// ユーザ情報の保存、読み込みを行う
///
class UserModel {
  static const String userFileName = "user";

  ///
  /// user情報を保存する
  ///
  static Future<void> saveUser(User user) async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File userFile = File(path.join(rootSavePath, UserModel.userFileName));
    String userJson = json.encode(user.toJson());

    await userFile.writeAsString(userJson);
  }

  ///
  /// user情報を読み込む
  /// ファイルが存在しない場合はnull
  ///
  static Future<User?> loadUser() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File userFile = File(path.join(rootSavePath, UserModel.userFileName));

    if (await userFile.exists()) {
      return User.fromJson(json.decode(await userFile.readAsString()));
    } else {
      return null;
    }
  }
}
