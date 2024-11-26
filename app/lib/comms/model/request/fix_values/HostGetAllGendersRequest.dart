import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetAllGenderResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetAllGendersRequest extends BaseRequest{
  

  Future<HostGetAllGenderResponse> run() async {
    try {
      Log.d("Start HostGetAllGendersRequest");
      HostActions option = HostActions.GET_ALL_GENDERS;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {"action":option.action};
      String jsonBody = json.encode(mapBody);      
      var response = await http.post(url, headers: buildHeader(), body: jsonBody);      
      if (response.statusCode == 200) {
        List<dynamic> value = jsonDecode(response.body)["genders"];
        return HostGetAllGenderResponse.fromJson(value);   
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetAllGenderResponse.empty();
  }

}