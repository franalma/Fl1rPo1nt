import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateUserInterestRequest extends BaseRequest {
  Future<bool> run(String userId, RelationShip relationship,
      SexAlternative sexAlternative, Gender gender) async {
    try {
      Log.d("Start HostUpdateUserInterestRequest");

      HostActionsItem option = HostApiActions.updateUserInterestsByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": userId,
          "values": {
            "user_interests": {
              "relationship": {
                "id": relationship.id,
                "name": relationship.value,
                "color": relationship.color
              },
              "sex_alternative": {
                "id": sexAlternative.id,
                "name": sexAlternative.name,
                "color": sexAlternative.color
              },
              "gender_preference": {
                "id": gender.id,
                "name": gender.name,
                "color": gender.color
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
