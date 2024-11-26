import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetAllSexRelationshipResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetAllSexRelationshipRequest extends BaseRequest {
  Future<HostGetAllSexRelationshipResponse> run() async {
    try {
      Log.d("Start HostGetAllSexRelationshipRequest");
      HostActions option =
          HostActions.GET_ALL_SEXUAL_ORIENTATIONS_RELATIONSHIPS;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {"action": option.action};

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        return HostGetAllSexRelationshipResponse.fromJson(value);
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetAllSexRelationshipResponse.empty();
  }
}
