import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/ui/utils/Log.dart';

class HostUpdatePointsResponse extends BaseCustomResponse {
  List<SmartPoint>? points; 

  HostUpdatePointsResponse(this.points, super.hostErrorCode);
  HostUpdatePointsResponse.empty() : super(null);

  factory HostUpdatePointsResponse.fromJson(Map<String, dynamic> map) {
    Log.d("Starts HostUpdatePointsResponse.fromJson");
    try {
      HostErrorCode errorCode = HostErrorCode.fromJson(map);
      var values = (map["values"] as List).map((e) => SmartPoint.fromJson(e)).toList();      
      return HostUpdatePointsResponse(values, errorCode);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostUpdatePointsResponse.empty();
  }
}
