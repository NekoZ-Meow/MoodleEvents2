import 'package:flutter/material.dart';
import 'package:moodle_event_2/model/model.dart';

class ViewState<T extends StatefulWidget> extends State<T> {
  Model model;

  ///
  /// モデルをセットする
  ///
  void setModel(Model model) {
    this.model = model;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
