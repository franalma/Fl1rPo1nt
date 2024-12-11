import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/SmartPoint.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetAllPointsByUserIdResponse extends BaseCustomResponse {
  List<SmartPoint>? points;

  HostGetAllPointsByUserIdResponse(this.points, super.hostErrorCode);
  HostGetAllPointsByUserIdResponse.empty() : super(null);

  factory HostGetAllPointsByUserIdResponse.fromJson(Map<String, dynamic> map) {
    Log.d("Starts HostGetAllPointsByUserIdResponse.fromJson");
    try {
      HostErrorCode errorCode = HostErrorCode.fromJson(map);
      var values = map["points"] as List;

      List<SmartPoint> points = values.map((e) {
        return SmartPoint.fromJson(e);
      }).toList();
      return HostGetAllPointsByUserIdResponse(points, errorCode);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetAllPointsByUserIdResponse.empty();
  }
}
