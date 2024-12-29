import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrahsalitycsService {
  static void init() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  }

  static void test(){
    FirebaseCrashlytics.instance.crash();
  }
}

