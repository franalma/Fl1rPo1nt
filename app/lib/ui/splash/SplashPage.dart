import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/login/LoginPage.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<SplashPage> {
  @override
  void initState() {
    _performActionWithDelay();
    super.initState();
  }
  Future<void> _performActionWithDelay() async {
  
    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    NavigatorApp.pushAndRemoveUntil(context, LoginPage2());
  }

  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: 300,
            height: 300,
            child: Image.asset(
              "assets/img/splash_icon.png",
              fit: BoxFit.fill,
            )));
  }
}
