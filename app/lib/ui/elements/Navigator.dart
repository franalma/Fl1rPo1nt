import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';

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
