import 'package:flutter/material.dart';

class NavigatorApp {
  BuildContext context;
  static NavigatorState? navigator = null;

  NavigatorApp(this.context) {
    navigator = Navigator.of(context);
  }

  static void push(Widget widget, BuildContext context) {
    navigator!.push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static void pop(BuildContext context) {
    navigator!.pop(context);
  }
}