
import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostPutFlirtByUserIdResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostRegisterRequest extends BaseRequest{
  

  Future<HostPutFlirtByUserIdResponse> run(
      String name,
      String surname,
      String phone,
      String email,
      String pass,
      String country,
      String city) async {
    try {
      Log.d("Start doRegister");
      HostActions option = HostActions.PUT_USER_FLIRT_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          
        }
      };

    
      String jsonBody = json.encode(mapBody);      
      var response = await http.post(url, headers: buildHeader(), body: jsonBody);
      var value = jsonDecode(response.body);
      Log.d (value);
      // if (response.statusCode == 200) {
      //   return HostPutFlirtByUserIdResponse.fromJson(jsonDecode(response.body));
      // }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostPutFlirtByUserIdResponse.empty();
  }

}