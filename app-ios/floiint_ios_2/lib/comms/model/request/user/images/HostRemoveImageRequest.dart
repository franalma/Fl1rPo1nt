import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostRemoveImageRequest extends BaseRequest {
  Future<bool> run(String userId, String fileId) async {
    try {
      Log.d("Start HostRemoveImageRequest");

      HostActionsItem option = HostMultActions.removeUserImagesByUuserIdImageId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId, "file_id": fileId}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      Log.d("delete picture response: ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return false;
  }
}
