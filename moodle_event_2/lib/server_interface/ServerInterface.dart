import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:moodle_event_2/Constants/Constants.dart';
import 'package:moodle_event_2/Utility/DebugUtility.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

final String baseUrl = "https://cclms.kyoto-su.ac.jp/lib/ajax/service.php";

String getCookies(List<Cookie> cookies) {
  return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
}

///
/// moodleにajax通信を行う
///
Future<String> _request(String method, Map args, String sessKey) async {
  WebviewCookieManager cookieManager = WebviewCookieManager();
  String cookie =
      getCookies(await cookieManager.getCookies(Constants.MOODLE_URL));

  //String url = baseUrl + "?sesskey=" + sessKey + "&info=" + method;
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
    throw Exception("Request Failed");
  }

  return resp.body;
}

///
/// カレンダーイベントを取得する
/// 日付は年と月のみ採用
///
Future<List<String>> getCalendarEvents(
    DateTime start, DateTime end, String sessKey) async {
  String method = "core_calendar_get_calendar_monthly_view";
  List<Future<String>> futureList = [];
  int diffMonth = (end.year - start.year) * 12 + end.month - start.month;
  if (diffMonth <= 0) return [];
  int nowMonth = start.month;
  int nowYear = start.year;
  for (int count = 0; count < diffMonth; count += 1) {
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
  List<String> result = await Future.wait(futureList);
  return result;
}
