import 'package:app/comms/socket_subscription/SocketSubscriptionController.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/location.dart';

class Session {
  static late User user;
  static Location? location;
  static SocketSubscriptionController? socketSubscription;
  static Flirt? currentFlirt;
}
