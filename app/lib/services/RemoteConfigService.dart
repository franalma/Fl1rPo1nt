import 'package:app/ui/utils/Log.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static late FirebaseRemoteConfig remoteConfig;
  static void init() {
    remoteConfig = FirebaseRemoteConfig.instance;
  }

  static Future<void> fetchFromHost() async {
    try {
      await remoteConfig.fetchAndActivate();
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  static String getApiKey() {
    String key = remoteConfig.getString("api_key");
    Log.d("ApiKey: $key");
    return key;
  }
}
