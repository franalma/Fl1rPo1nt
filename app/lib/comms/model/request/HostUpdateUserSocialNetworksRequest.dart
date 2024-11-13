import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostUpdateUserSocialNetworksResponse.dart';
import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateUserSocialNetworksRequest extends BaseRequest {
  Future<List<HostUpdateUserSocialNetworksResponse>> run(
      String userId, List<SocialNetwork> networks) async {
    try {
      Log.d("Start HostUpdateUserSocialNetworksResponse");
      HostActions option = HostActions.UPDATE_USER_NETWORK_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "values": {"networks": networks}
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);
      var value = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<dynamic> value = jsonDecode(response.body)["networks"];
        return value
            .map((item) => HostUpdateUserSocialNetworksResponse.fromJson(item))
            .toList();
            
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return [];
  }
}
