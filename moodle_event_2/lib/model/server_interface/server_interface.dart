import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:moodle_event_2/Utility/debug_utility.dart';
import 'package:moodle_event_2/constants/string_constants.dart';
import 'package:moodle_event_2/event/json_to_event.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

const String baseUrl = "https://cclms.kyoto-su.ac.jp/lib/ajax/service.php";

String _getCookies(List<Cookie> cookies) {
  return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
}

///
/// moodleにajax通信を行う
///
Future<String> _request(String method, Map args, String sessKey) async {
  WebviewCookieManager cookieManager = WebviewCookieManager();
  String cookie =
      _getCookies(await cookieManager.getCookies(StringConstants.MOODLE_URL));

  String url = "${baseUrl}?sesskey=${sessKey}&info=${method}";

  Map<String, String> headers = {
    'content-type': 'application/json',
    HttpHeaders.cookieHeader: cookie,
  };
  String body = json.encode([
    {
      "index": 0,
      "methodname": method,
      "args": args,
    }
  ]);

  // print(cookie);
  // print(url);
  // print(body);

  http.Response resp =
      await http.post(Uri.parse(url), headers: headers, body: body);

  if (resp.statusCode >= 300) {
    debugLog("response code: " + resp.statusCode.toString());
    throw const SocketException("Request Failed");
  }

  return resp.body;
}

///
/// カレンダーイベントを取得する
/// 日付は年と月のみ採用
///
Future<Map<int, Event>> _getCalendarEventsMap(
    DateTime start, DateTime end, String sessKey) async {
  DateTime debugStart = DateTime.now();
  String method = "core_calendar_get_calendar_monthly_view";
  List<Future<String>> futureList = [];
  int diffMonth = (end.year - start.year) * 12 + end.month - start.month;
  if (diffMonth <= 0) return Map<int, Event>();
  int nowMonth = start.month;
  int nowYear = start.year;
  for (int count = 0; count <= diffMonth; count += 1) {
    Map args = {
      "year": nowYear,
      "month": nowMonth,
      "courseid": 1,
      "categoryid": 0
    };
    if (nowMonth == 12) {
      nowMonth = 1;
      nowYear += 1;
    } else {
      nowMonth += 1;
    }
    futureList.add(_request(method, args, sessKey));
  }
  List<String> results = await Future.wait(futureList);
  List<dynamic> jsonEvents =
      results.map((jsonString) => json.decode(jsonString)).toList();
  debugLog("${DateTime.now().difference(debugStart).inMilliseconds}ms");

  return calenderJsonToEventsMap(jsonEvents);
}

///
/// アクションイベントを取得する
/// 日付は年と月のみ採用
///
Future<List<int>> _getActionEventIds(String sessKey) async {
  String method = "core_calendar_get_action_events_by_timesort";
  List<int> results = [];
  int eventID = 0;
  while (true) {
    Map args = {
      "limitnum": 50,
      "timesortfrom": -1,
      "limittononsuspendedevents": false,
      "aftereventid": eventID,
    };
    List<dynamic> result = json.decode(await _request(method, args, sessKey));
    List<dynamic> events = result[0]["data"]["events"];
    if (events.isEmpty) break;
    results.addAll(events.map((event) => event["instance"] as int));
    eventID = result[0]["data"]["lastid"];
  }
  return results;
}

///
/// MoodleからEventのリストを取得する
///
Future<List<Event>> getEvents(
    DateTime start, DateTime end, String sessKey) async {
  List<int> actionEventIds = [];
  Map<int, Event> calendarEventsMap = {};
  await Future.wait([
    _getActionEventIds(sessKey).then((value) => actionEventIds = value),
    _getCalendarEventsMap(start, end, sessKey)
        .then((value) => calendarEventsMap = value),
  ]);
  actionEventIds.forEach((id) {
    if (calendarEventsMap.containsKey(id)) {
      calendarEventsMap[id]!.isSubmit = false;
    }
  });

  return calendarEventsMap.values.toList();
}

///
/// セッションキーが有効か確かめる
///
Future<bool> isSessKeyValid(String sessKey) async {
  String method = "core_session_time_remaining";
  Map args = {};
  List<dynamic> result = json.decode(await _request(method, args, sessKey));
  return !(result[0]["error"] as bool);
}
