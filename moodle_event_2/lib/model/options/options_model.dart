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
  Set<String> filterCategories = {};
  Set<String> filterCourses = {};
  SortOption sortOption = SortOption.deadLineAsc;

  factory OptionsModel() {
    OptionsModel._singletonInstance ??= OptionsModel._();
    return OptionsModel._singletonInstance!;
  }

  OptionsModel._() {
    this.loadOptions();
  }

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
      this.filterCategories = jsonMap["categories"].toSet();
      this.filterCourses = jsonMap["courses"].toSet();
      this.sortOption = SortOptionExtension.fromString(jsonMap["sort"]);
    }
    return;
  }

  ///
  /// このクラスをJsonに変換する
  ///
  Map<String, dynamic> toJson() => {
        "version": fileVersion,
        "title": this.filterTitle,
        "categories": this.filterCategories,
        "courses": this.filterCourses,
        "sort": this.sortOption.name
      };
}
