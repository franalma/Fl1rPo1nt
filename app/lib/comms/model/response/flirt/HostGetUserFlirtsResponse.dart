import 'package:app/model/Flirt.dart';

class HostGetUserFlirtsResponse {
  List<Flirt>?flirts; 

  HostGetUserFlirtsResponse(this.flirts);
  HostGetUserFlirtsResponse.empty();
  

  factory HostGetUserFlirtsResponse.fromJson(List<dynamic> json) {
    List<Flirt> values  = json.map<Flirt>((item){
        return Flirt.fromHost(item);
    }).toList();
    return HostGetUserFlirtsResponse(values);
  }
}
