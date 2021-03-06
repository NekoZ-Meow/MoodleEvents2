import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodle_event_2/ui/root_widget.dart';

import 'constants/color_constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = new MyHttpOverrides();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
            headline2: GoogleFonts.openSans(
                color: ColorConstants.TEXT_MAIN,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            headline3: GoogleFonts.openSans(
                color: ColorConstants.TEXT_MAIN,
                fontSize: 19,
                fontWeight: FontWeight.w500),
            subtitle2: TextStyle(color: ColorConstants.TEXT_SUB, fontSize: 12)),
      ),
      home: RootWidget(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
