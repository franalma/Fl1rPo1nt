import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetPointByPointIdResponse extends BaseCustomResponse {
  SmartPoint? point;

  HostGetPointByPointIdResponse(this.point, super.hostErrorCode);
  HostGetPointByPointIdResponse.empty() : super(null);

  factory HostGetPointByPointIdResponse.fromJson(Map<String, dynamic> map) {
    Log.d("Starts HostGetPointByPointIdResponse.fromJson");
    try {
      HostErrorCode errorCode = HostErrorCode.fromJson(map);  
      SmartPoint point = SmartPoint.fromJson(map);      
      return HostGetPointByPointIdResponse(point, errorCode);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetPointByPointIdResponse.empty();
  }
}
