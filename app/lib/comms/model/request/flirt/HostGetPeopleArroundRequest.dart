import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetPeopleArroundResponse.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetPeopleArroundRequest extends BaseRequest {
  Future<List<HostGetPeopleArroundResponse>> run(
      double latitude, double longitude, int radio) async {
    Log.d("Starts HostGetPeopleArroundRequest.run");
    try {
      HostActionsItem option = HostApiActions.getUserByDistanceFromPoint;
      Uri url = Uri.parse(option.build());
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"longitude": longitude, "latitude": latitude, "radio": radio}
      };

      var response = await send(mapBody, url);
      if (response.statusCode == 200) {
        List<dynamic> value = jsonDecode(response.body)["flirts"];
        Log.d(value.toString());
        return value
            .map((qrInfo) => HostGetPeopleArroundResponse.fromJson(qrInfo))
            .toList();
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return [];
  }
}
