import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateUserImageProfileRequest extends BaseRequest {
  Future<bool> run(String userId, String fileId) async {
    try {
      Log.d("Start HostUpdateUserNameRequest");
      HostActionsItem option = HostApiActions.updateUserImageProfileByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId, "image_id": fileId}
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