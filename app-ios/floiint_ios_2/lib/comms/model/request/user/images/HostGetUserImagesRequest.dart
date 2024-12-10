import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetUserImagesResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetUserImagesRequest extends BaseRequest {
  Future<HostGetUserImagesResponse> run(String userId) async {
    try {
      Log.d("Start HostGetUserImagesRequest");

      HostActionsItem option = HostMultActions.getProtectedImagesUrlsByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetUserImagesResponse.fromJson(
            jsonDecode(response.body)["files"]);
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetUserImagesResponse.empty();
  }
}
