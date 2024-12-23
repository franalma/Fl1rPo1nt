import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/qr/HostAllQrResponse.dart';
import 'package:app/ui/utils/Log.dart';

class HostAllQrRequest extends BaseRequest {
  Future<List<HostAllQrResponse>> run(String userId) async {
    Log.d("Starts HostAllQrResponse.run");
    try {
      HostActionsItem option = HostApiActions.getUserQrByUserId;
      Uri url = Uri.parse(option.build());
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
