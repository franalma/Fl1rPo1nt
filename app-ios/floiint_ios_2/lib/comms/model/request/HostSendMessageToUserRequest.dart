import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostSendMessageToUserRequest extends BaseRequest {
  Future<bool> run(String matchId, String senderId, String receiverId,
      String message) async {
    try {
      Log.d("Start HostSendMessageToUserRequest");
      HostActionsItem option = HostChatActions.putMessageToUserWithUserId;
      Uri url = Uri.parse(option.build());
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "match_id": matchId,
          "sender_id": senderId,
          "receiver_id": receiverId,
          "message": message
        }
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