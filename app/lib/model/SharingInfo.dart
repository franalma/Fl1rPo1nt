import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';

class SharingInfo {
  String? name;
  String? phone;
  List<SocialNetwork>? networks;

  SharingInfo(this.name, this.phone, this.networks);
  SharingInfo.empty();

  factory SharingInfo.fromJson(Map<String, dynamic> json) {
    Log.d("Starts SharingInfo.fromJson");
    try {      
      List<dynamic> mapNetworks = json["networks"];

      var networks = mapNetworks.map((e) {
        return SocialNetwork.load(e);
      }).toList();

      return SharingInfo(json["name"], json["phone"], networks);
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }

    return SharingInfo.empty();
  }
}
