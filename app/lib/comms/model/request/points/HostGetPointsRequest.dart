import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/smart_points/HostGetAllPointsByUserIdResponse.dart';
import 'package:app/comms/model/response/smart_points/HostGetPointByPointIdResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetPointsRequest extends BaseRequest {
  Future<HostGetAllPointsByUserIdResponse> runByUserID(String userId) async {
    try {
      Log.d("Start HostGetPointsRequest");

      HostActionsItem option = HostApiActions.getAllSmartPointsByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

     return HostGetAllPointsByUserIdResponse.fromJson(
            jsonDecode(response.body));

    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetAllPointsByUserIdResponse.empty();
  }

  Future<HostGetPointByPointIdResponse> runByPointId(String pointId) async {
    try {
      Log.d("Start HostGetPointsRequest");

      HostActionsItem option = HostApiActions.getSmartPointByPointId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"point_id": pointId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

     return HostGetPointByPointIdResponse.fromJson(
            jsonDecode(response.body));
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetPointByPointIdResponse.empty();
  }
}
