import 'dart:convert';

import 'package:app/comms/model/response/BaseCustomResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/ui/utils/Log.dart';

class HostRegisterResponse extends BaseCustomResponse {
  String id = "";

  HostRegisterResponse(this.id) : super(null);
  HostRegisterResponse.empty(super.hostErrorCode);

  factory HostRegisterResponse.fromJson(
      Map<String, dynamic> json, HostErrorCode hostErrorCode) {
    try {
      Log.d(jsonEncode(json));
      return HostRegisterResponse(json['id']);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    
    return HostRegisterResponse.empty(hostErrorCode);
  }
}
