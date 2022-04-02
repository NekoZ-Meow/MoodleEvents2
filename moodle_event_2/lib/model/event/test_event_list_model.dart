import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/event/i_event_list_model.dart';

class TestEventListModel implements IEventListModel {
  final List<Event> _events = [];

  @override
  List<Event> get events => this._events;

  /// [events]Json形式でファイルに出力する
  @override
  Future<void> saveEventList() async {
    return;
  }

  /// eventを読み込み、リスト形式で返す
  @override
  Future<void> loadEventList() async {
    List<String> eventTitles = [
      "めちゃくちゃにタイトル長いめんどうで難しく誰も取りたがらないクソみたいな授業の課題",
      "画像処理",
      "コンピュータネットワーク01",
      "1145141919810",
      "The theory of universe",
      "うええええええええい",
      "アルゴリズムとデータ構造 プログラミング課題1",
      "長期課題",
    ];

    List<String> courseNames = [
      "めちゃくちゃにタイトル長いめんどうで難しく誰も取りたがらないクソみたいな授業",
      "画像処理",
      "コンピュータネットワーク",
      "野獣先輩",
      "Introduction to Astrophysics",
      "ほぉぉぉぉぉぉぉぉぉぉぉぉぉぉ",
      "アルゴリズムとデータ構造",
      "プログラミング言語"
    ];

    this._events.clear();
    DateTime now = DateTime.now();
    for (int i = 0; i < 8; i++) {
      this._events.add(Event(i, i, eventTitles[i], "これはテストです", "コースイベント",
          courseNames[i], "https://google.com", now.add(Duration(days: i)),
          isSubmit: i % 2 == 0));
    }
    return;
  }

  /// イベントを更新する
  @override
  void updateEvents(List<Event> events) {
    this._events.clear();
    this._events.addAll(events);
  }
}
