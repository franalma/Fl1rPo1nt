import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetUserImagesResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetUserImgeUrlByIdRequest extends BaseRequest {
  Future<HostGetUserImagesResponse> run(List<dynamic> values) async {
    try {
      Log.d("Start HostGetUserImgeUrlByIdRequest");
      HostActions option = HostActions.GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"values": values}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetUserImagesResponse.fromJson(jsonDecode(response.body)["files"]);
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetUserImagesResponse.empty();
  }
}
