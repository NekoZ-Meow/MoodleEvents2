import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/margin_constants.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/server_interface/server_interface.dart';
import 'package:moodle_event_2/ui/event_card/event_card.dart';
import 'package:moodle_event_2/ui/event_card/event_card_viewmodel.dart';
import 'package:moodle_event_2/ui/home_page/home_page_viewmodel.dart';
import 'package:moodle_event_2/ui/login_page/login_page.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:provider/provider.dart';

/// アプリ起動時の一番最初のページ
/// イベントがリスト形式で表示される
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  /// リストがリフレッシュされた時
  Future<void> onRefresh(BuildContext context) async {
    try {
      // 直前にログインし、セッションキーが有効である
      if (await isSessKeyValid(
          context.read<HomePageViewModel>().user.sessKey)) {
        await context.read<HomePageViewModel>().updateEventsFromMoodle();
        return;
      }

      String sessionKey = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      context.read<HomePageViewModel>().updateSessionKey(sessionKey);
      if (await isSessKeyValid(
          context.read<HomePageViewModel>().user.sessKey)) {
        await context.read<HomePageViewModel>().updateEventsFromMoodle();
      }
    } catch (exception) {
      debugLog(exception);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final List<Event> events = context.watch<HomePageViewModel>().events;
    final List<ChangeNotifierProvider> eventCards = events
        .map((event) => ChangeNotifierProvider(
            create: (context) => EventCardViewModel(event),
            child: const EventCard()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Moodle Events"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MarginConstants.baseMargin),
        child: RefreshIndicator(
          onRefresh: () => this.onRefresh(context),
          child: ListView(
            key: const PageStorageKey(0),
            children: eventCards,
          ),
        ),
      ),
    );
  }
}
