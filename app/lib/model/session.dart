import 'package:app/comms/socket_subscription/SocketSubscriptionController.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:flutter/widgets.dart';

class Session {
  static late User user;
  static Location? location;
  static SocketSubscriptionController? socketSubscription;
  static Flirt? currentFlirt;
  static dynamic profileImage;
  static bool flirtAlreadyLoaded = false;
  

  static Future<void> loadProfileImage() async {
    Log.d("Starts loadProfileImage");
    profileImage = const NetworkImage(
        'https://images.ctfassets.net/denf86kkcx7r/4IPlg4Qazd4sFRuCUHIJ1T/f6c71da7eec727babcd554d843a528b8/gatocomuneuropeo-97?fm=webp&w=913');
  }

 
}
