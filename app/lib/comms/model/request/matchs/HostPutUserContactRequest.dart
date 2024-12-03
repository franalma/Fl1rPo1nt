import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:http/http.dart' as http;

class HostPutUserContactRequest extends BaseRequest {
  Future<bool> run(String userId, String userQrId, String contactId,
      String contactQrId, String userFlirtId, Location location) async {
    try {
      Log.d("Start HostPutUserContactRequest");

      HostActionsItem option =
          HostApiActions.putUserContactByUserIDContactIdQrId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": userId,
          "user_qr_id": userQrId,
          "contact_id": contactId,
          "contact_qr_id": contactQrId,
          "flirt_id": userFlirtId,
          "location": {"latitude": location.lat, "longitude": location.lon}
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
