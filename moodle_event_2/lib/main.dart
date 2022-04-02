import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodle_event_2/model/event/test_event_list_model.dart';
import 'package:moodle_event_2/ui/home_page/home_page.dart';
import 'package:moodle_event_2/ui/home_page/home_page_viewmodel.dart';
import 'package:provider/provider.dart';

import 'constants/color_constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomePageViewModel(TestEventListModel()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
              headline2: GoogleFonts.openSans(
                  color: ColorConstants.textMain,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              headline3: GoogleFonts.openSans(
                  color: ColorConstants.textMain,
                  fontSize: 19,
                  fontWeight: FontWeight.w500),
              subtitle2:
              const TextStyle(color: ColorConstants.textSub, fontSize: 12)),
        ),
        home: const HomePage(),
      ),
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
