import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/ui/utils/Log.dart';

class HostPutPointByUserIdResponse extends BaseCustomResponse {
  SmartPoint? point; 

  HostPutPointByUserIdResponse(this.point, super.hostErrorCode);
  HostPutPointByUserIdResponse.empty() : super(null);

  factory HostPutPointByUserIdResponse.fromJson(Map<String, dynamic> map) {
    Log.d("Starts HostPutPointByUserIdResponse.fromJson");
    try {
      HostErrorCode errorCode = HostErrorCode.fromJson(map);
      var point = SmartPoint.fromJson(map["point"]);
      return HostPutPointByUserIdResponse(point, errorCode);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostPutPointByUserIdResponse.empty();
  }
}
