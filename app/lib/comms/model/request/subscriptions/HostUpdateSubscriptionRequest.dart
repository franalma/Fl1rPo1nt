import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUpdateSubscriptionRequest extends BaseRequest {
  Future<bool> run(String userId, int validUntil, String type,
      String transactionDate) async {
    try {
      Log.d("Start HostUpdateSubscriptionRequest");

      HostActionsItem option = HostApiActions.updateSubscription;
      Uri url = Uri.parse(option.build());
      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "user_id": userId,
          "subscription": {
            "valid_until": validUntil,
            "type": type,
            "transaction_date": transactionDate
          }
        }
      };

      String jsonBody = json.encode(mapBody);
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);
      var map = jsonDecode(response.body);
      if (map["status"] == 200) {
        return true;
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return false;
  }
}
