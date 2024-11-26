import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetAllSocialNetworksResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetAllSocialNetworksRequest extends BaseRequest{
  

  Future<List<HostGetAllSocialNetworksResponse>> run() async {
    try {
      Log.d("Start HostGetAllSocialNetworksRequest");
      HostActions option = HostActions.GET_ALL_SOCIAL_NETWORKS;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {"action":option.action};
      String jsonBody = json.encode(mapBody);      
      var response = await http.post(url, headers: buildHeader(), body: jsonBody);      
      if (response.statusCode == 200) {
        List<dynamic> value = jsonDecode(response.body)["networks"];
        return value
            .map((item) => HostGetAllSocialNetworksResponse.fromJson(item))
            .toList();        
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return [];
  }

}