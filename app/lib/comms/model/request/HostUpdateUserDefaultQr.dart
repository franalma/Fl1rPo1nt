import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateUserDefaultQr extends BaseRequest {
  Future<bool> run(String userId, String qrId) async {
    try {
      Log.d("Start HostUpdateUserDefaultQr");
      HostActions option = HostActions.UPDATE_USER_DEFAULT_QR_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId, "qr_id": qrId}
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
