import 'package:flutter/material.dart';
import 'package:moodle_event_2/event/event.dart';
import 'package:moodle_event_2/ui/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

enum SelectValue {
  openUrl,
}

class PopupMenuWidget extends StatelessWidget {
  final Event event;

  const PopupMenuWidget(this.event, {Key? key}) : super(key: key);

  ///
  /// 選択された時の処理
  ///
  void _onSelected(BuildContext context, SelectValue selected) async {
    switch (selected) {
      case SelectValue.openUrl:
        try {
          await launch(this.event.url);
        } catch (exception) {
          ErrorDialog.showErrorDialog(context, "URLを開けませんでした");
        }
        break;
      default:
        ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SelectValue>(
        icon: const Icon(Icons.menu),
        onSelected: (SelectValue selected) {
          this._onSelected(context, selected);
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<SelectValue>>[
            const PopupMenuItem(
              value: SelectValue.openUrl,
              child: Text("イベントのURLを開く"),
            )
          ];
        });
  }
}
