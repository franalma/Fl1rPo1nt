import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/response/auth/HostRegisterResponse.dart';
import 'package:app/model/HostErrorCode.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostRegisterRequest {
  Future<HostRegisterResponse> run(
      String name, String phone, String email, String pass, int bornDate) async {
    var hostErrorCode = HostErrorCode.undefined();
    try {
      Log.d("Start doRegisterV2");

      HostActionsItem option = HostAuthActions.register;
      Uri url = Uri.parse(option.build());
      print(url);
      Map<String, dynamic> mapBody = {
        "input": {
          "name": name,
          "password": pass,
          "phone": phone,
          "email": email,
          "zip_code":0, 
          "born_date": bornDate
          // "country": country,
          // "city": city
        }
      };

      String jsonBody = json.encode(mapBody);      
      var response = await http.post(url, headers: jsonHeaders, body: jsonBody);      
      var value = jsonDecode(response.body);
      hostErrorCode = HostErrorCode.fromJson(value);

      if (response.statusCode == 200) {
        HostRegisterResponse hostRegisterResponse =
            HostRegisterResponse.fromJson(jsonDecode(response.body), hostErrorCode);        
        return hostRegisterResponse;
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostRegisterResponse.empty(hostErrorCode);
  }
}
