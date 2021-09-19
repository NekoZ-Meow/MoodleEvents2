///
/// 一つのイベントを管理するクラス
///

class Event implements Comparable<Event> {
  static final CATEGORY_USER = "user";
  static final CATEGORY_COURSE = "course";

  int _eventId; //イベントID
  int _eventInstance; //インスタンスID
  String _categoryName; //カテゴリ名
  String _courseName; //コース名
  String _title; //タイトル
  String _description; //詳細
  DateTime _startTime; //開始時間 テストなどの開始時間が存在する際に使用
  DateTime _endTime; //終了時間
  bool isSubmit = true; //提出済みか

  ///
  /// コンストラクタ
  ///
  Event(int eventId, int eventInstance, String title, String description,
      String categoryName, String courseName, DateTime endTime,
      {DateTime startTime, this.isSubmit = true}) {
    this._eventId = eventId;
    this._eventInstance = eventInstance;
    this._title = title;
    this._description = description;
    this._categoryName = categoryName;
    this._courseName = courseName;
    this.setTime(endTime, start: startTime);
  }

  int get eventId => this._eventId;
  int get eventInstance => this._eventInstance;
  String get title => this._title;
  String get description => this._description;
  String get categoryName => this._categoryName;
  String get courseName => this._courseName;
  DateTime get endTime => this._endTime;
  DateTime get startTime => this._startTime;

  ///
  /// この課題がすでに始まっているか
  ///
  bool isAlreadyStarted() {
    if (this.startTime != null) {
      if (this.startTime.compareTo(DateTime.now()) >= 0) {
        return false;
      }
    }
    return true;
  }

  ///
  /// この課題がすでに終了しているか
  ///
  bool isAlreadyEnded() {
    if (this.endTime.compareTo(DateTime.now()) < 0) {
      return true;
    }
    return false;
  }

  ///
  /// この課題の代表となる時間を返す
  ///
  DateTime getRepresentativeTime() {
    if (this.isAlreadyStarted()) return this.endTime;
    return this.startTime;
  }

  ///
  /// イベントの時間を再設定する
  ///
  void setTime(DateTime end, {DateTime start}) {
    if (start != null && end.compareTo(start) < 0) {
      throw Exception("開始時間が終了時間よりも後に設定されました。");
    }
    this._endTime = end;
    this._startTime = start;
    return;
  }

  @override
  bool operator ==(Object other) {
    return (other is Event) && (this._eventId == other.eventId);
  }

  @override
  int get hashCode => this.eventId.hashCode;

  @override
  String toString() {
    return this.title;
  }

  @override
  int compareTo(Event other) {
    return this
        .getRepresentativeTime()
        .compareTo(other.getRepresentativeTime());
  }
}
