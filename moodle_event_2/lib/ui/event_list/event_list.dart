import 'package:flutter/material.dart';
import 'package:moodle_event_2/model/server_interface/server_interface.dart';
import 'package:moodle_event_2/ui/event_card.dart';
import 'package:moodle_event_2/ui/event_list/event_list_viewmodel.dart';
import 'package:moodle_event_2/ui/home_page/home_page_viewmodel.dart';
import 'package:moodle_event_2/ui/login_page/login_page.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:provider/provider.dart';

class EventList extends StatelessWidget {
  const EventList({Key? key}) : super(key: key);

  /// リストがリフレッシュされた時
  Future<void> onRefresh(BuildContext context) async {
    try {
      // 直前にログインし、セッションキーが有効である
      if (await isSessKeyValid(
          context.read<HomePageViewModel>().user.sessKey)) {
        await context.read<HomePageViewModel>().updateEventsFromMoodle();
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
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
    return RefreshIndicator(
      onRefresh: () => this.onRefresh(context),
      child: FutureBuilder(
        future: context.read<EventListViewModel>().loadDependencies(),
        builder: (context, snapShot) {
          return Consumer<EventListViewModel>(builder: (context, viewModel, _) {
            List<EventCard> eventCards =
                viewModel.listEvents.map((event) => EventCard(event)).toList();
            return ListView(
              key: const PageStorageKey(0),
              children: [],
            );
          });
        },
      ),
    );
  }
}
