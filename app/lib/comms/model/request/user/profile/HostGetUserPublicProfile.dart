import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetUserPublicProfileResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetUserPublicProfile extends BaseRequest {
  Future<HostGetUserPublicProfileResponse> run(String userId) async {
    try {
      Log.d("Start HostGetUserPublicProfile");
      HostActions option = HostActions.GET_USER_PUBLIC_PROFILE_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetUserPublicProfileResponse.fromJson(
            jsonDecode(response.body));
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetUserPublicProfileResponse.empty();
  }
}
