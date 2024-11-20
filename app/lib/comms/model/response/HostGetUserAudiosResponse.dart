import 'package:app/model/FileData.dart';

class HostGetUserAudiosResponse {
  List<FileData>? fileList;

  HostGetUserAudiosResponse(this.fileList);
  HostGetUserAudiosResponse.empty();

  factory HostGetUserAudiosResponse.fromJson(List<dynamic> values) {
    var list = values.map((e) => FileData.fromHost(e)).toList();
    return HostGetUserAudiosResponse(list);
  }
}
