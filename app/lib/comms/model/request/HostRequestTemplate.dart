import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/comms/model/response/HostResponseTemplate.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostRequestTemplate extends BaseRequest {
  Future<HostResponseTemplate> run(String name) async {
    try {
      Log.d("Start doRegister");
     
      HostActionsItem option = HostApiActions.putUserFlirtByUserId;
      Uri url = Uri.parse(option.build());


      Map<String, dynamic> mapBody = {"action": option.action, "input": {}};

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        return HostResponseTemplate.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return HostResponseTemplate.empty();
  }
}
