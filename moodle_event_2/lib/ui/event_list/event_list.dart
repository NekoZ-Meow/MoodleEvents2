import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/model/server_interface/server_interface.dart';
import 'package:moodle_event_2/ui/dialog/error_dialog.dart';
import 'package:moodle_event_2/ui/event_card/event_card.dart';
import 'package:moodle_event_2/ui/event_list/event_list_viewmodel.dart';
import 'package:moodle_event_2/ui/home_page/home_page_viewmodel.dart';
import 'package:moodle_event_2/ui/login_page/login_page.dart';
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
    } on SocketException catch (exception) {
      ErrorDialog.showErrorDialog(context, "正しく通信できませんでした");
    } catch (exception) {
      ErrorDialog.showErrorDialog(context, "ログインに失敗しました");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await this.onRefresh(context);
        Fluttertoast.showToast(
            msg: "更新しました", backgroundColor: ColorConstants.textEnded);
      },
      child: FutureBuilder(
        future: context.read<EventListViewModel>().loadDependencies(),
        builder: (context, snapShot) {
          return Consumer<EventListViewModel>(builder: (context, viewModel, _) {
            List<EventCard> eventCards =
                viewModel.listEvents.map((event) => EventCard(event)).toList();
            return Stack(
              alignment: Alignment.center,
              children: [
                ListView(
                  key: const PageStorageKey(0),
                  children: eventCards,
                ),
                (viewModel.listEvents.isEmpty)
                    ? Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text("イベントが存在しません",
                                style:
                                    TextStyle(color: ColorConstants.textEnded)),
                            Text("下方向にスワイプして更新してください",
                                style:
                                    TextStyle(color: ColorConstants.textEnded)),
                          ],
                        ),
                      )
                    : Container(),
              ],
            );
          });
        },
      ),
    );
  }
}
