import 'package:flutter/material.dart';

///
/// エラー時に表示するダイアログ
///
class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog(this.message, {Key? key}) : super(key: key);

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(context: context, builder: (_) => ErrorDialog(message));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.warning_amber_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Text("エラー"),
        ],
      ),
      content: Text(this.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "OK",
          ),
        ),
      ],
    );
  }
}
