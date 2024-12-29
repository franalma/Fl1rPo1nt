import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/flirt/HostPutFlirtByUserIdResponse.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/location.dart';
import 'package:http/http.dart' as http;

class HostPutFlirtByUserIdRequest extends BaseRequest {
  Future<HostPutFlirtByUserIdResponse> run(User user, Location location) async {
    try {
      Log.d("Start HostPutFlirtByUserIdRequest");

      HostActionsItem option = HostApiActions.putUserFlirtByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": user.userId,
          "name": user.name, 
          "user_interests": {
            "relationship": user.relationShip,
            "sex_alternative": user.sexAlternatives,
            "gender_interest": user.genderInterest
          },
          "location": {"latitude": location.lat, "longitude": location.lon},
          "gender": user.gender,
          "age": user.age
        }
      };

      String jsonBody = json.encode(mapBody);
      print(jsonBody);
      print ( buildHeader());
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);
      var value = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return HostPutFlirtByUserIdResponse.fromJson(value["response"]);
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostPutFlirtByUserIdResponse.empty();
  }
}
