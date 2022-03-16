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
    // HomePageViewModel viewModel = Provider.of<HomePageViewModel>(context);
    // debugLog(viewModel);
    try {
      if (await isSessKeyValid(
          context.read<HomePageViewModel>().user.sessKey)) {
        await context.watch<HomePageViewModel>().updateEventsFromMoodle();
      } else {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: Provider.of<HomePageViewModel>(context, listen: false),
            child: LoginPage(),
          ),
        ));

        if (await isSessKeyValid(
            context.read<HomePageViewModel>().user.sessKey)) {
          await context.watch<HomePageViewModel>().updateEventsFromMoodle();
        }
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

    return ChangeNotifierProvider.value(
      value: context.read<HomePageViewModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Moodle Events"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(MarginConstants.BASE_MARGIN),
          child: ChangeNotifierProvider.value(
            value: context.read<HomePageViewModel>(),
            child: RefreshIndicator(
              onRefresh: () => this.onRefresh(context),
              child: ListView(
                key: const PageStorageKey(0),
                children: eventCards,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
