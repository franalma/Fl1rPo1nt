import 'dart:convert';
import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/flirt/HostGetUserFlirtsResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetUserFlirtsRequest extends BaseRequest {
  Future<HostGetUserFlirtsResponse> run(String userId, int status) async {
    try {
      Log.d("Start HostGetUserFlirtsRequest run");
      HostActions option = HostActions.GET_USER_FLIRTS;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "filters": {"user_id": userId, "status": status}
        }
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetUserFlirtsResponse.fromJson(
            jsonDecode(response.body)["flirts"]);
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetUserFlirtsResponse.empty();
  }

  Future<HostGetUserFlirtsResponse> all(String userId) async {
    try {
      Log.d("Start HostGetUserFlirtsRequest all");
      HostActions option = HostActions.GET_USER_FLIRTS;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "filters": {"user_id": userId}
        }
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetUserFlirtsResponse.fromJson(
            jsonDecode(response.body)["flirts"]);
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetUserFlirtsResponse.empty();
  }
}
