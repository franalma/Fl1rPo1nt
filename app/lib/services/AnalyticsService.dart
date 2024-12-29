import 'package:app/ui/utils/Log.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService{
static late  FirebaseAnalytics analytics;
  static void init(){
    Log.d("Starts init");
    analytics = FirebaseAnalytics.instance;    
  }

  static Future<void> logCustomEvent() async {
    Log.d("Starts logCustomEvent");
    await analytics.logEvent(
      name: 'custom_event',
      parameters: {'param1': 'value1', 'param2': 'value2'},
    );
  }
}