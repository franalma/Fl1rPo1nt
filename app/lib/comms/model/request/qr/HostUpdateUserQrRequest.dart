import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostUpdateUserQrResponse.dart';
import 'package:app/model/QrValue.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateUserQrRequest extends BaseRequest {
  Future<List<HostUpdateUserQrResponse>> run(
      String userId, List<QrValue> qrList) async {
    try {
      Log.d("Start HostUpdateUserQrRequest");

      HostActionsItem option = HostApiActions.updateUserQrsByUserId;
      Uri url = Uri.parse(option.build());
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": userId,
          "qr_values": qrList.map((e) => e.toHost()).toList()
        }
      };

      String jsonBody = json.encode(mapBody);
      Log.d("-->payload: $jsonBody");
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        List<dynamic> qrValues = value["qr_values"];
        List<HostUpdateUserQrResponse> result =
            qrValues.map((e) => HostUpdateUserQrResponse.fromJson(e)).toList();
        return result;
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return [];
  }
}
