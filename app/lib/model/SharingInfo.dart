import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';

class SharingInfo {
  String? name;
  String? phone;
  List<SocialNetwork>? networks;
  bool? allwoAccessToAudios;
  bool? allwoAccessToPictures;

  SharingInfo(this.name, this.phone, this.networks, this.allwoAccessToAudios, this.allwoAccessToPictures);
  SharingInfo.empty();

  factory SharingInfo.fromJson(Map<String, dynamic> json) {
    Log.d("Starts SharingInfo.fromJson");
    try {
      List<dynamic> mapNetworks = json["networks"];

      var networks = mapNetworks.map((e) {
        return SocialNetwork.load(e);
      }).toList();

      bool audios = json["audios"] == true;
      bool pictures = json["pictures"] == true;
      return SharingInfo(json["name"], json["phone"], networks, audios, pictures);
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }

    return SharingInfo.empty();
  }
}
