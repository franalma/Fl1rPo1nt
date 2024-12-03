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
      HostActionsItem option = HostApiActions.getAllSocialNetworks;
      Uri url = Uri.parse(option.build());

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