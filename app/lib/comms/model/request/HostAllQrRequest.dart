import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostAllQrResponse.dart';
import 'package:app/ui/utils/Log.dart';

class HostAllQrRequest extends BaseRequest {
  Future<List<HostAllQrResponse>> run(String userId) async {
    Log.d("Starts HostAllQrResponse.run");
    try {
      HostActions option = HostActions.GET_USER_QR_BY_USER_ID;
      Uri url = Uri.parse(option.url);
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"user_id": userId}
      };

      var response = await send(mapBody, url);
      if (response.statusCode == 200) {
        List<dynamic> value = jsonDecode(response.body)["items"];
        Log.d(value.toString());
        return value
            .map((qrInfo) => HostAllQrResponse.fromJson(qrInfo))
            .toList();
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return [];
  }
}
