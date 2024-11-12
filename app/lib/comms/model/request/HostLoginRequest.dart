import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/response/HostLoginResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostLoginRequest{
  

    Future<HostLoginResponse> run(String user, String pass) async {
    Log.d("Start doLogin: $user:$pass");
    try {
      HostActions option = HostActions.LOGIN;
      Uri url = Uri.parse(option.url);
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"email": user, "password": pass}
      };

      String jsonBody = json.encode(mapBody); 
      Log.d(jsonBody);  
      var response = await http.post(url, headers: jsonHeaders, body: jsonBody);
      
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body)["response"];
        return HostLoginResponse.fromJson(value);
      }
    } catch (error, stackTrace) {
      Log.d(stackTrace.toString());
    }
    return HostLoginResponse.empty();
  }
}