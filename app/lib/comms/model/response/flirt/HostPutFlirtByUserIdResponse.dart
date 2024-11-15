import 'package:app/model/Flirt.dart';

class HostPutFlirtByUserIdResponse {
  Flirt? flirt;

  HostPutFlirtByUserIdResponse(this.flirt);
  HostPutFlirtByUserIdResponse.empty();

  factory HostPutFlirtByUserIdResponse.fromJson(Map<String, dynamic> map) {
    return HostPutFlirtByUserIdResponse(Flirt.fromHost(map));
  }
}
