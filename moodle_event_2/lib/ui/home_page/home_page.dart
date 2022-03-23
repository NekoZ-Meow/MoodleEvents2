import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/margin_constants.dart';
import 'package:moodle_event_2/ui/event_list/event_list.dart';
import 'package:moodle_event_2/ui/event_list/event_list_viewmodel.dart';
import 'package:moodle_event_2/ui/home_page/home_page_viewmodel.dart';
import 'package:provider/provider.dart';

/// アプリ起動時の一番最初のページ
/// イベントがリスト形式で表示される
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("課題一覧"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MarginConstants.baseMargin),
        child: FutureBuilder(
          future: context.read<HomePageViewModel>().loadDependencies(),
          builder: (context, snapShot) {
            return ChangeNotifierProxyProvider<HomePageViewModel,
                EventListViewModel>(
              create: (context) => EventListViewModel(),
              update: (context, homePageViewModel, eventListViewModel) {
                eventListViewModel?.updateListEvents(homePageViewModel.events);
                return eventListViewModel!;
              },
              child: const EventList(),
            );
          },
        ),
      ),
    );
  }
}
