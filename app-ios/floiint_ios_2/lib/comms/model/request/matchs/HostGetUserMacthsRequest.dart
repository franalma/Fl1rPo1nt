import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/comms/model/response/HostGetMatchsResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetUserMacthsRequest extends BaseRequest {
  Future<HostGetMatchsResponse> run(String userId) async {
    try {
      Log.d("Start HostGetUserMacthsRequest");

      HostActionsItem option = HostApiActions.getAllUserMatchsByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetMatchsResponse.fromJson(
            jsonDecode(response.body)["matchs"]);
      }
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }
    return HostGetMatchsResponse.empty();
  }
}
