import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/model/Session.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BaseRequest {
  Map<String, String> buildHeader() {
    var result = Map<String, String>.from(jsonHeaders);
    result["Authorization"] = "Token ${Session.user.token}";
    result["x-api-key"] = APIKEY;
    return result;
  }

  String getToken() {
    return "Token ${Session.user.token}";
  }

  Future<Response> send(Map<String, dynamic> map, Uri url) async {
    String jsonBody = json.encode(map);
    var response = await http.post(url, headers: buildHeader(), body: jsonBody);
    Log.d("response: ${response.statusCode}");
    return response;
  }
}
