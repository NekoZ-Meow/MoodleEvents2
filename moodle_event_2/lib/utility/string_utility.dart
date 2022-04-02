///
/// 文字列に関するユーティリティ
///

/// カタカナをひらがなに変換する
String kanaToHira(String str) {
  Pattern aPattern = RegExp("[ァ-ヴ]");

  return str.replaceAllMapped(aPattern, (Match m) {
    String? group = m.group(0);
    if (group != null) {
      return String.fromCharCode(group.codeUnitAt(0) - 0x60);
    }
    return "";
  });
}
