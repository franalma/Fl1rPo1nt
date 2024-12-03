import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/response/auth/HostLoginResponse.dart';
import 'package:app/model/HostErrorCode.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostLoginRequest {
  Future<HostLoginResponse> run(String user, String pass) async {
    Log.d("Start doLogin: $user:$pass");
    var hostErrorCode = HostErrorCode.undefined(); 
    try {
      HostActionsItem option = HostAuthActions.login;
      Uri url = Uri.parse(option.build());
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"email": user, "password": pass}
      };

      String jsonBody = json.encode(mapBody);
      Log.d(jsonBody);
      var response = await http.post(url, headers: jsonHeaders, body: jsonBody);

      if (response.statusCode == 200) {        
        var value = jsonDecode(response.body);
        hostErrorCode = HostErrorCode.fromJson(value);
      
        HostLoginResponse hostLoginResponse =
            HostLoginResponse.fromJson(value["response"], hostErrorCode);
        
        return hostLoginResponse;
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    
    return HostLoginResponse.empty(hostErrorCode);
  }
}
