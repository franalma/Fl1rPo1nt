import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/model/Hobby.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateHobbiesRequest extends BaseRequest {
  Future<bool> run(String userId, List<Hobby> hobbies) async {
    try {
      Log.d("Start HostUpdateHobbiesRequest");
      HostActionsItem option = HostApiActions.updateUserHobbiesByUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": userId,
          "hobbies": hobbies.map((e) => e.toMap()).toList()
        }
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }
}
