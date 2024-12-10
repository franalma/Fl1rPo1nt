import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/comms/model/response/smart_points/HostUpdatePointResponse.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostPutPointByUserIdRequest extends BaseRequest {
  // Future<HostPutPointByUserIdResponse> run(
  //     String userId, String qrId) async {
  //   try {
  //     Log.d("Start HostPutPointByUserIdRequest");

  //     HostActionsItem option = HostApiActions.putSmartPointByUserIdQrId;
  //     Uri url = Uri.parse(option.build());

  //     Map<String, dynamic> mapBody = {
  //       "action": option.action,
  //       "input": {"user_id: $userId, qr_id:$qrId"}
  //     };

  //     String jsonBody = json.encode(mapBody);
  //     var response =
  //         await http.post(url, headers: buildHeader(), body: jsonBody);

  //     if (response.statusCode == 200) {
  //       return HostPutPointByUserIdResponse.fromJson(
  //           jsonDecode(response.body));
  //     }
  //   } catch (error) {
  //     Log.d(error.toString());
  //   }
  //   return HostPutPointByUserIdResponse.empty();
  // }
}
