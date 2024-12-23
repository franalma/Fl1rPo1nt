import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';

class ContactInfo {
  String userId = "";
  String? name;
  String? phone;
  bool? allwoAccessToAudios; 
  bool? allwoAccessToPictures; 

  List<SocialNetwork>? networks;

  ContactInfo(this.userId, this.name, this.phone, this.networks, this.allwoAccessToAudios, this.allwoAccessToPictures);
  ContactInfo.empty();

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    Log.d("Starts ContactInfo.fromJson");
    try {
      List<SocialNetwork> networks =[];
      if (json["contact_info"] != null) {
        List<dynamic> mapNetworks = json["contact_info"]["networks"];
        var networks = mapNetworks.map((e) {
          return SocialNetwork.load(e);
        }).toList();
        bool audios = json["contact_info"]["audios"];
        bool pictures = json["contact_info"]["pictures"];
        return ContactInfo(json["user_id"], json["contact_info"]["name"],
          json["contact_info"]["phone"], networks, audios, pictures);
      }

      
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }

    return ContactInfo.empty();
  }
}
