import 'dart:convert';
import 'dart:io';

import 'package:moodle_event_2/model/options/sort_option.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// リスト表示のオプションを管理するクラス
/// シングルトンであり、唯一のインスタンスを返す
class OptionsModel {
  static const String optionsFileName = "options"; // ファイル名
  static const String fileVersion = "0"; //ファイルバージョン
  static OptionsModel? _singletonInstance; // シングルトンであるOptionsModelのインスタンス

  String filterTitle = "";
  Set<String> filterCourses = {};
  DateTime? filterDateTime;
  bool showAlreadyEnded = false;

  SortOption sortOption = SortOption.deadLineAsc;

  factory OptionsModel() {
    OptionsModel._singletonInstance ??= OptionsModel._();
    return OptionsModel._singletonInstance!;
  }

  OptionsModel._();

  ///
  /// options情報をセーブする
  ///
  Future<void> saveOptions() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File optionsFile =
        File(path.join(rootSavePath, OptionsModel.optionsFileName));
    String optionsJson = json.encode(this.toJson());
    await optionsFile.writeAsString(optionsJson);

    return;
  }

  ///
  /// options情報を読み込む
  ///
  Future<void> loadOptions() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File optionsFile =
        File(path.join(rootSavePath, OptionsModel.optionsFileName));

    if (await optionsFile.exists()) {
      Map<String, dynamic> jsonMap =
          json.decode(await optionsFile.readAsString());
      if (jsonMap["version"] != fileVersion) {
        debugLog("file version dose not same.");
        return;
      }
      this.filterTitle = jsonMap["title"];
      List<dynamic> coursesRaw = jsonMap["courses"];
      this.filterCourses =
          coursesRaw.map((course) => course.toString()).toSet();
      this.sortOption = SortOptionExtension.fromString(jsonMap["sort"]);
      this.showAlreadyEnded = jsonMap["showEnded"];
      if (jsonMap.containsKey("time")) {
        this.filterDateTime =
            DateTime.fromMillisecondsSinceEpoch(jsonMap["time"]);
      }
    }
    return;
  }

  ///
  /// このクラスをJsonに変換する
  ///
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      "version": fileVersion,
      "title": this.filterTitle,
      "courses": this.filterCourses.toList(),
      "sort": this.sortOption.name,
      "showEnded": this.showAlreadyEnded,
    };
    if (this.filterDateTime != null) {
      jsonMap["time"] = this.filterDateTime!.millisecondsSinceEpoch;
    }

    return jsonMap;
  }
}
