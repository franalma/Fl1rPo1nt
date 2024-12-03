import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';


class HostLoginResponse extends BaseCustomResponse {
  User? user;
  HostLoginResponse(this.user, super.hostErrorCode);

  HostLoginResponse.empty(super.hostErrorCode);

  factory HostLoginResponse.fromJson(
      Map<String, dynamic> json, HostErrorCode hostErrorCode) {
    try {
      Log.d("Starts HostLoginResponse.fromJson");
      User user = User.fromHost(json);

      return HostLoginResponse(user, hostErrorCode);
    } catch (error, stackTrace) {
      Log.d("$stackTrace error $error");
    }
    return HostLoginResponse.empty(hostErrorCode);
  }
}
