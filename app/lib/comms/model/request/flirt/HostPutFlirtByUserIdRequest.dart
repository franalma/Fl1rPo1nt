
import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/flirt/HostPutFlirtByUserIdResponse.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:http/http.dart' as http;

class HostPutFlirtByUserIdRequest extends BaseRequest{
  

  Future<HostPutFlirtByUserIdResponse> run(
      User user, Location location) async {
    try {
      Log.d("Start HostPutFlirtByUserIdRequest");
      HostActions option = HostActions.PUT_USER_FLIRT_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
           "user_id":user.userId, 
           "relationship_id":user.relationShip.id, 
           "relationship_name":user.relationShip.value, 
           "orientation_id":user.sexAlternatives.id, 
           "orientation_name":user.sexAlternatives.name, 
           "location":{
            "latitude":location.lat,
            "longitude":location.lon
           }
        }
      };

    
      String jsonBody = json.encode(mapBody);      
      var response = await http.post(url, headers: buildHeader(), body: jsonBody);
      var value = jsonDecode(response.body);          
      if (response.statusCode == 200) {
        return  HostPutFlirtByUserIdResponse.fromJson(value["response"]);        
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostPutFlirtByUserIdResponse.empty();
  }

}