import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateFlirtLocationByFlirtIdRequest extends BaseRequest {
  Future<bool> run(Flirt flirt) async {
    try {
      Log.d("Start HostUpdateFlirtLocationByFlirtIdRequest");
      HostActionsItem option = HostApiActions.updateUserFlirtByUserIdFlirtId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "flirt_id": flirt.id,
          "values": {
            "location": {
              "latitude": flirt.location!.lat,
              "longitude": flirt.location!.lon
            }
          }
        }
      };

      String jsonBody = json.encode(mapBody);
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
