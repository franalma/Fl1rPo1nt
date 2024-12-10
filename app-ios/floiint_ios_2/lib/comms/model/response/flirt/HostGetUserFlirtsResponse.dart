import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetUserFlirtsResponse extends BaseCustomResponse {
  List<Flirt>? flirts;

  HostGetUserFlirtsResponse(this.flirts, super.hostErrorCode);
  HostGetUserFlirtsResponse.empty() : super(null);

  factory HostGetUserFlirtsResponse.fromJson(Map<String, dynamic> map) {
    try {
      HostErrorCode errorCode = HostErrorCode.fromJson(map);

      List<Flirt> values = (map["flirts"] as List).map<Flirt>((item) {
        return Flirt.fromHost(item);
      }).toList();
      return HostGetUserFlirtsResponse(values, errorCode);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetUserFlirtsResponse.empty();
  }
}
