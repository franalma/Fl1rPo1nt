
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

   static Future<dynamic> pushAndWait(Widget widget, BuildContext context) async{
    var result = await navigator!.push(
      MaterialPageRoute(builder: (context) => widget),
    );
    return result; 
  }

  static void pushWithCallback(
      Widget widget, BuildContext context, Function callback) {
    navigator!
        .push(
      MaterialPageRoute(builder: (context) => widget),
    )
        .then((_) {
      callback();
    });
  }

  static void pop(BuildContext context) {
    navigator!.pop(context);
  }
  static void popUntil(BuildContext context) {
     Navigator.popUntil(context, (route) => route.isFirst);
  }

  static void popWith(BuildContext context, dynamic values){
     Navigator.pop(context, values);
  }

  static pushAndRemoveUntil(BuildContext context, dynamic screen){
     Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => screen),
              (Route<dynamic> route) => false,
            );
  }
}
