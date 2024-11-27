import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostClearChatByUserId extends BaseRequest {
  Future<bool> run(
      String matchId, String userId) async {
    try {
      Log.d("Start HostClearChatByUserId");
      HostActions option = HostActions.DELETE_CHATROOM_FROM_MATCH_ID_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"match_id": matchId, "user_id": userId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return true; 
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return false; 
  }
}
