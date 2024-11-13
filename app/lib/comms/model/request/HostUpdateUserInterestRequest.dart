import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateUserInterestRequest extends BaseRequest {
  Future<bool> run(String userId, RelationShip relationship,
      SexAlternative sexAlternative) async {
    try {
      Log.d("Start HostUpdateUserInterestRequest");
      HostActions option = HostActions.UPDATE_USER_INTERESTS_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": userId,
          "values": {
            "user_interests": {
              "relationship": {
                "id": relationship.id,
                "name": relationship.value
              },
              "sex_alternative": {
                "id": sexAlternative.id,
                "name": sexAlternative.name
              }
            }
          }
        }
      };

      String jsonBody = json.encode(mapBody);
      Log.d("-->payload: $jsonBody");
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return false;
  }
}
