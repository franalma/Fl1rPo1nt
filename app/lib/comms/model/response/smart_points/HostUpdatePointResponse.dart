import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/ui/utils/Log.dart';

class HostUpdatePointResponse extends BaseCustomResponse {
  SmartPoint? point; 

  HostUpdatePointResponse(this.point, super.hostErrorCode);
  HostUpdatePointResponse.empty() : super(null);

  factory HostUpdatePointResponse.fromJson(Map<String, dynamic> map) {
    Log.d("Starts HostPutPointByUserIdResponse.fromJson");
    try {
      HostErrorCode errorCode = HostErrorCode.fromJson(map);
      var point = SmartPoint.fromJson(map);
      return HostUpdatePointResponse(point, errorCode);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostUpdatePointResponse.empty();
  }
}
