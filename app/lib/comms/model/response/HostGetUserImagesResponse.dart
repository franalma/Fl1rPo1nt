import 'package:app/model/FileData.dart';

class HostGetUserImagesResponse {
  List<FileData>? fileList;

  HostGetUserImagesResponse(this.fileList);
  HostGetUserImagesResponse.empty();

  factory HostGetUserImagesResponse.fromJson(List<dynamic> values) {
    var list = values.map((e) => FileData.fromHost(e)).toList();
    return HostGetUserImagesResponse(list);
  }
}
