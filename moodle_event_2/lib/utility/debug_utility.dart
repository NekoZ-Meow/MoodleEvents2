import 'package:flutter/cupertino.dart';
import 'package:stack_trace/stack_trace.dart' show Trace;

///
/// デバッグ文にスタックとレースの内容を追加
///
void debugLog(message) {
  const level = 1;
  final frames = Trace.current(level).frames;
  final frame = frames.isEmpty ? null : frames.first;
  debugPrint("$frame: $message");

  return;
}
