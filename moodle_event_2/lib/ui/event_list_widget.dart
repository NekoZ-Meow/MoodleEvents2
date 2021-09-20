import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moodle_event_2/event/event.dart';
import 'package:moodle_event_2/model/model.dart';
import 'package:moodle_event_2/server_interface/server_interface.dart';
import 'package:moodle_event_2/ui/event_card.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';

import 'error_dialog.dart';
import 'login_web_view.dart';

///
/// イベントをリスト表示する
///
class EventListWidget extends StatefulWidget {
  final Model model;
  const EventListWidget(this.model, {Key key}) : super(key: key);

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  ///
  /// リストがリフレッシュされた時の処理
  /// イベントリストを更新する
  ///
  Future<void> onRefresh() async {
    String sessKey = widget.model.user.sessKey;
    try {
      if (!await isSessKeyValid(sessKey)) {
        sessKey = await Navigator.of(this.context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginWebView(
                popWhenAuthorized: true,
              );
            },
          ),
        );
      }
      if (await isSessKeyValid(sessKey)) {
        widget.model.user.sessKey = sessKey;
        List<Event> events = await getEvents(
            DateTime(2021, 1), DateTime(2021, 12), widget.model.user.sessKey);
        if (this.mounted) {
          this.setState(() {
            widget.model.updateEventList(events);
          });
          await widget.model.save();
        }
      } else {
        throw Exception("sessKey is invalid");
      }
    } on SocketException catch (exception) {
      debugLog(exception.toString());
      ErrorDialog.showErrorDialog(context, "正しく通信できませんでした");
    } catch (exception) {
      debugLog(exception.toString());
      ErrorDialog.showErrorDialog(context, "正しくログインできませんでした");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems =
        widget.model.events.map((event) => new EventCard(event)).toList();
    return RefreshIndicator(
      onRefresh: this.onRefresh,
      child: ListView(
        key: PageStorageKey(0),
        children: listItems,
      ),
    );
  }
}
