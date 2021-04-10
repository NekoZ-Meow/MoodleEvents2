///
/// 一つのイベントを管理するクラス
///

class Event {
  int _eventId;
  String _categoryName;
  String _courseName;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  bool isSubmit = true;

  Event(int eventId, this.title, this.description, String categoryName,
      String courseName, this.endTime,
      {this.startTime, this.isSubmit}) {
    this._eventId = eventId;
    this._categoryName = categoryName;
    this._courseName = courseName;
    if (this.endTime == null) this.endTime = DateTime.now();
  }

  int get eventId => this._eventId;
  String get categoryName => this._categoryName;
  String get courseName => this._courseName;

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
  /// この課題の代表となる時間を返す
  ///
  DateTime getRepresentativeTime() {
    if (this.isAlreadyStarted()) return this.endTime;
    return this.startTime;
  }

  @override
  bool operator ==(Object other) {
    return (other is Event) && (this._eventId == other.eventId);
  }

  @override
  int get hashCode => this.eventId;

  @override
  String toString() {
    return this.title;
  }
}
