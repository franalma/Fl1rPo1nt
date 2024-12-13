import 'package:app/model/SocialNetwork.dart';
import 'package:app/ui/utils/Log.dart';

class ContactInfo {
  String userId = "";
  String? name;
  String? phone;

  List<SocialNetwork>? networks;

  ContactInfo(this.userId, this.name, this.phone, this.networks);
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
        return ContactInfo(json["user_id"], json["contact_info"]["name"],
          json["contact_info"]["phone"], networks);
      }

      
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }

    return ContactInfo.empty();
  }
}
