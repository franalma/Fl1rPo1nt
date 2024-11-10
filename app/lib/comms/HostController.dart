import 'dart:convert';

import 'package:app/comms/model/HostLoginResponse.dart';
import 'package:app/comms/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'model/HostRegisterResponse.dart';

const String _DEV_HOST = "http://192.168.2.206:3000";
const String _DEV_BASE_API_URL = "$_DEV_HOST/api";
const String _DEV_BASE_AUTH_URL = "$_DEV_HOST/auth";
const String SERVER_API = _DEV_BASE_API_URL;
const String SERVER_AUTH = _DEV_BASE_AUTH_URL;

const jsonHeaders = {
  'Content-Type': 'application/json', // Define el tipo de contenido como JSON
};

enum HostActions {
  LOGIN("DO_LOGIN", SERVER_AUTH),
  REGISTER("REGISTER", SERVER_AUTH);

  final String action;
  final String url;

  const HostActions(this.action, this.url);
}

class HostController {
  Future<HostLoginResponse> doLogin(String user, String pass) async {
    print("Start doLogin");
    try {
      HostActions option = HostActions.LOGIN;
      Uri url = Uri.parse(option.url);
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {"email": user, "password": pass}
      };

      String jsonBody = json.encode(mapBody);
      var response = await http.post(url, headers: jsonHeaders, body: jsonBody);
      

      if (response.statusCode == 200) {       
        var value = jsonDecode(response.body)["response"];       
        return HostLoginResponse.fromJson(value);
      }
    } catch (error, stackTrace) {
      print(stackTrace);
    }
    return HostLoginResponse.empty();
  }

  Future<HostRegisterResponse> doRegister(String user, String pass) async {
    HostActions option = HostActions.REGISTER;
    Uri url = Uri.parse(option.url);

    var response = await http.get(url);
    if (response.statusCode == 200) {
      return HostRegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      return HostRegisterResponse(id: 111);
      //throw Error();
    }
  }

  void printResponse(Response response) {
    print(response.statusCode);
    print(response.body);
  }
}
