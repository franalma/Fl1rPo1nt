import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/subscriptions/HostGetAllSubscritionsResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostGetAllSubscriptionRequest extends BaseRequest {
  Future<HostGetAllSubscritionsResponse> run() async {
    try {
      Log.d("Start HostGetAllSubscriptionRequest");
     
      HostActionsItem option = HostApiActions.getAllSubscriptionTypes;
      Uri url = Uri.parse(option.build());
      Map<String, dynamic> mapBody = {"action": option.action};

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

       return HostGetAllSubscritionsResponse.fromJson(jsonDecode(response.body));
    } catch (error) {
      Log.d(error.toString());
    }
    return HostGetAllSubscritionsResponse.empty();
  }
}
