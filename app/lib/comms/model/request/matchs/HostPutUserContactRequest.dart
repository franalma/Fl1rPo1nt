import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:http/http.dart' as http;

enum ContactUser {
  qr(0),
  point(1),
  map(2);

  final int value;
  const ContactUser(this.value);
}

class HostPutUserContactRequest extends BaseRequest {
  Future<HostErrorCode> run(
      String userId,
      String userQrId,
      String contactId,
      String contactSourceId,
      String userFlirtId,
      Location location,
      ContactUser source) async {
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
          "flirt_id": userFlirtId,
          "location": {"latitude": location.lat, "longitude": location.lon},
          "source": source.value
        }
      };

      if (source == ContactUser.point) {
        mapBody["input"]["point_id"] = contactSourceId;
      } else if (source == ContactUser.qr) {
        mapBody["input"]["contact_qr_id"] = contactSourceId;
      } else if (source == ContactUser.map) {
        mapBody["input"]["contact_qr_id"] = contactSourceId;
      }

      String jsonBody = json.encode(mapBody);
      Log.d("HostPutUserContactRequest::Sending $jsonBody");
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      return HostErrorCode.fromJson(jsonDecode(response.body));
    } catch (error) {
      Log.d(error.toString());
    }
    return HostErrorCode.undefined();
  }
}
