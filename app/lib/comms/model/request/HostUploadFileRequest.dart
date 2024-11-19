import 'dart:convert';

import 'package:app/comms/model/HostContants.dart';
import 'package:app/comms/model/request/BaseRequest.dart';

import 'package:app/ui/utils/Log.dart';
import 'package:http/http.dart' as http;

class HostUploadFileRequest extends BaseRequest {
  Future<bool> run(String userId, String path) async {
    try {
      Log.d("Start HostUploadFileRequest");
      HostActions option = HostActions.UPLOAD_FILE_BY_USER_ID;
      Uri url = Uri.parse(option.url);

      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('image', path),
      );
      request.headers["Authorization"] = getToken();
      request.fields["user_id"] = userId; 
      
      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      Log.d(error.toString());
    }
    return false;
  }
}
