import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/smart_points/HostGetAllPointsByUserIdResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetPointsByUserIdRequest extends BaseRequest {
  Future<HostGetAllPointsByUserIdResponse> run(String userId) async {
    try {
      Log.d("Start HostGetPointsByUserIdRequest");

      HostActionsItem option = HostApiActions.getAllSmartPointsByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id: $userId"}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetAllPointsByUserIdResponse.fromJson(
            jsonDecode(response.body));
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetAllPointsByUserIdResponse.empty();
  }
}
