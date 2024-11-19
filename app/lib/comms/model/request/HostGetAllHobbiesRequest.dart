import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/model/Hobby.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetAllHobbiesRequest extends BaseRequest {
  Future<List<Hobby>> run() async {
    try {
      Log.d("Start HostGetAllHobbiesRequest");
      HostActions option = HostActions.GET_ALL_HOBBIES;
      Uri url = Uri.parse(option.url);

      Map<String, dynamic> mapBody = {"action": option.action};

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      if (response.statusCode == 200) {
        List<Hobby> values = [];

        List<dynamic> hobbies = jsonDecode(response.body)["values"];
        values = hobbies.map((e) => Hobby.fromHost(e)).toList();

        return values;
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return [];
  }
}
