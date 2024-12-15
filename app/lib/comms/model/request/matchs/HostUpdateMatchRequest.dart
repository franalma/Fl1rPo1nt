import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

enum ContactUser {
  qr(0),
  point(1),
  map(2);

  final int value;
  const ContactUser(this.value);
}

class HostUpdateMatchRequest extends BaseRequest {
  Future<HostErrorCode> updateAudioAccess(
      String matchId,
      String userId,
      bool audioAccess) async {
    try {
      Log.d("Start HostUpdateMatchRequest::updateAudioAccess");

      HostActionsItem option =
          HostApiActions.updateMatchAudioAccessByMatchIdUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "match_id":matchId,
          "user_id": userId,
          "audio_access": audioAccess,
        }
      };
      String jsonBody = json.encode(mapBody);      
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      return HostErrorCode.fromJson(jsonDecode(response.body));
    } catch (error) {
      Log.d(error.toString());
    }
    return HostErrorCode.undefined();
  }

  Future<HostErrorCode> updatePictureAccess(
      String matchId,
      String userId,
      bool pictureAcccess) async {
    try {
      Log.d("Start HostUpdateMatchRequest::updatePictureAccess");

      HostActionsItem option =
          HostApiActions.updateMatchPicturesAccessByMatchIdUserId;
      Uri url = Uri.parse(option.build());

      Map<String, dynamic> mapBody = {
        "action": option.action,
        "input": {
          "match_id":matchId,
          "user_id": userId,
          "picture_access": pictureAcccess,
        }
      };
      String jsonBody = json.encode(mapBody);      
      var response =
          await http.post(url, headers: buildHeader(), body: jsonBody);

      return HostErrorCode.fromJson(jsonDecode(response.body));
    } catch (error) {
      Log.d(error.toString());
    }
    return HostErrorCode.undefined();
  }
  










}
