import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/smart_points/HostUpdatePointResponse.dart';
import 'package:app/comms/model/response/smart_points/HostUpdatePointsResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdatePointRequest extends BaseRequest {
  Future<HostUpdatePointsResponse> runByUserId(
      String userId, int status) async {
    try {
      Log.d("Start HostUpdatePointsResponse.runByUserId");

      HostActionsItem option = HostApiActions.updateSmartPointStatusByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId, "status": status}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostUpdatePointsResponse.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostUpdatePointsResponse.empty();
  }

  Future<HostUpdatePointResponse> runByPointId(
      String pointId, int status) async {
        late var response; 
    try {
      Log.d("Start HostPutPointByUserIdRequest");

      HostActionsItem option = HostApiActions.updateSmartPointStatusByPointId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"point_id": pointId, "status": status}
      };

      String jsonBody = json.encode(mapBody);
      response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

     return HostUpdatePointResponse.fromJson(jsonDecode(response.body));
    } catch (error) {
      Log.d(error.toString());
    }
   
    return HostUpdatePointResponse.empty();
  }
}
