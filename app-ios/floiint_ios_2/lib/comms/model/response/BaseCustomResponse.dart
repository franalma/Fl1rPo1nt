import 'package:app/model/HostErrorCode.dart';


class BaseCustomResponse {
  HostErrorCode? hostErrorCode;

  BaseCustomResponse(this.hostErrorCode);
  factory BaseCustomResponse.fromJson(Map<String, dynamic> json) {
    return BaseCustomResponse(HostErrorCode.fromJson(json));
  }
}
