import 'package:flutter/material.dart';


class LocalNavigator {
  final BuildContext context;

  LocalNavigator(this.context);

  void push(StatefulWidget nextFragment) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextFragment),
    );
  }
}
