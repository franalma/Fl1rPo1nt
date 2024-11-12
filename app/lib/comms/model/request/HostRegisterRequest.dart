import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/response/HostRegisterResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostRegisterRequest{
  

  Future<HostRegisterResponse> run(
      String name,
      String surname,
      String phone,
      String email,
      String pass,
      String country,
      String city) async {
    try {
      Log.d("Start doRegister");
      HostActions option = HostActions.REGISTER;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "name": name,
          "password": pass,
          "phone": phone,
          "email": email,
          "pass": pass,
          "country": country,
          "city": city
        }
      };

    
      String jsonBody = json.encode(mapBody);      
      var response = await http.post(url, headers: jsonHeaders, body: jsonBody);
      var value = jsonDecode(response.body);
      Log.d (value);
      if (response.statusCode == 200) {
        return HostRegisterResponse.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostRegisterResponse.empty();
  }

}