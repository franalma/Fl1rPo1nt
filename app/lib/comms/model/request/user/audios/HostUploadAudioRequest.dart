import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUploadAudioRequest extends BaseRequest {
  Future<String> run(String userId, String path) async {
    try {
      Log.d("Start HostUploadAudioRequest: ");
      HostActions option = HostActions.UPLOAD_AUDIO_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('audio', path),
      );
      request.headers["Authorization"] = getToken();
      request.fields["user_id"] = userId;

      final response = await request.send();

      if (response.statusCode == 200) {
        var json = jsonDecode(await response.stream.bytesToString());
        return json["file_id"];
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return "";
  }
}
