import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/smart_points/HostPutPointByUserIdResponse.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostPutPointByUserIdRequest extends BaseRequest {
  Future<HostPutPointByUserIdResponse> run(String userId, String userName,
      String phone, List<SocialNetwork> networks) async {
    try {
      Log.d("Start HostPutPointByUserIdRequest");

      HostActionsItem option = HostApiActions.putSmartPointByUserIdQrId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": userId,
          "name": userName,
          "phone": phone,
          "networks": networks.map((e) => e.toHost()).toList()
        }
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostPutPointByUserIdResponse.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostPutPointByUserIdResponse.empty();
  }
}
