import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetChatroomMessagesResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetChatroomMessagesRequest extends BaseRequest {
  Future<HostGetChatroomMessagesResponse> run(String matchId) async {
    try {
      Log.d("Start HostGetChatroomMessagesRequest");
      HostActions option = HostActions.GET_CHATROOM_MESSAGES_BY_MATCH_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"match_id": matchId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostGetChatroomMessagesResponse.fromJson(
            jsonDecode(response.body)["messages"]);
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetChatroomMessagesResponse.empty();
  }
}
