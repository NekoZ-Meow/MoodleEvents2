import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

final String baseUrl = "https://cclms.kyoto-su.ac.jp/lib/ajax/service.php";

String getCookies(List<Cookie> cookies) {
  return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
}

Future<String> _request(String method, Map args, String sessKey) async {
  String url = baseUrl + "?sesskey=" + sessKey + "&info=" + method;
  final cookieManager = WebviewCookieManager();
  final cookies =
      await cookieManager.getCookies("https://cclms.kyoto-su.ac.jp/");
  //final cookies2 = await cookieManager.getCookies("https://www.kyoto-su.ac.jp/");
  String cookie = getCookies(cookies);
  //String cookie2 = getCookies(cookies2);
  //cookie += "; " + cookie2;
  print(cookie);
  print(url);
  Map<String, String> headers = {
    'content-type': 'application/json',
    HttpHeaders.cookieHeader: cookie
  };
  String body = json.encode([
    {"index": 0, "methodname": method, "args": args}
  ]);
  print(body);
  http.Response resp =
      await http.post(Uri.parse(url), headers: headers, body: body);
  if (resp.statusCode >= 300) {
    print("response code: " + resp.statusCode.toString());
    return "";
  }
  return resp.body;
}

Future<void> getCalendarEvents(
    DateTime start, DateTime end, String sessKey) async {
  String method = "core_calendar_get_calendar_monthly_view";
  List<Future<String>> futureList = [];
  int diffMonth = (end.year - start.year) * 12 + end.month - start.month;
  if (diffMonth <= 0) return "";
  int nowMonth = start.month;
  int nowYear = start.year;
  for (int month = 0; month < 1; month++) {
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
  print(result);
}
