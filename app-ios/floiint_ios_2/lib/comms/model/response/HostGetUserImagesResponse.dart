import 'package:app/model/FileData.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetUserImagesResponse {
  List<FileData>? fileData;

  HostGetUserImagesResponse(this.fileData);
  HostGetUserImagesResponse.empty();

  factory HostGetUserImagesResponse.fromJson(List<dynamic> data) {
    Log.d("Starts HostGetUserImagesResponse.fromJson");
    try {
      var list = data.map((e) {
        return FileData.fromHost(e);
      }).toList();
      return HostGetUserImagesResponse(list);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return HostGetUserImagesResponse.empty();
  }
}
