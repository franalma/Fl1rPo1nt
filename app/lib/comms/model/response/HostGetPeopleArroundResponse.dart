import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/NearByFlirt.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetPeopleArroundResponse {
  HostErrorCode? errorCode;
  List<NearByFlirt>? flirts;

  HostGetPeopleArroundResponse(this.errorCode, this.flirts);
  HostGetPeopleArroundResponse.empty();

  factory HostGetPeopleArroundResponse.fromJson(Map<String, dynamic> json) {
    try {
      var errorCode = HostErrorCode.fromJson(json);
      var values =
          (json["flirts"] as List).map((e) => NearByFlirt.fromJson(e)).toList();
      return HostGetPeopleArroundResponse(errorCode, values);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetPeopleArroundResponse.empty();
  }
}
