import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/HostGetPeopleArroundResponse.dart';
import 'package:app/model/Gender.dart';
import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetPeopleArroundRequest extends BaseRequest {
  Future<HostGetPeopleArroundResponse> run(
      String flirtId,
      String userId,
      SexAlternative sexAlternative,
      RelationShip relationShip,
      Gender genderInterest,
      double latitude,
      double longitude,
      double radio,
      bool enableFilters) async {
    Log.d("Starts HostGetPeopleArroundRequest.run");
    try {
      HostActionsItem option =
          HostApiActions.getActiveFlirtsFromPointAndTendency;
      Uri url = Uri.parse(option.build());
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "flirt_id":flirtId,
          "user_id":userId,
          "longitude": longitude,
          "latitude": latitude,
          "sex_alternative": sexAlternative.toJson(),
          "relationship": relationShip.toJson(),
          "gender_interest": genderInterest.toJson(),
          "radio": radio,
          "filters_enabled": enableFilters
        }
      };

      var response = await send(mapBody, url);
      
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        Log.d(value.toString());
        return HostGetPeopleArroundResponse.fromJson(value); 
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetPeopleArroundResponse.empty();
  }
}
