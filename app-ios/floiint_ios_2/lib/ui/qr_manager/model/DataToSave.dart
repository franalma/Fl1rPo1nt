import 'package:app/model/SocialNetwork.dart';

class DataToSave {
  String userName;
  String userPhone;
  bool pictures;
  bool audios;
  List<SocialNetwork> networks;

  DataToSave(
      this.userName, this.userPhone, this.networks, this.pictures, this.audios);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> values = {};

    if (userName.isNotEmpty) {
      values["name"] = userName;
    }
    if (userName.isNotEmpty) {
      values["phone"] = userPhone;
    }

    values["audios"] = audios;
    values["pictures"] = pictures;

    List<dynamic> networksToSend = [];

    networks.map((e) => networksToSend.add(e.toHost())).toList();
    values["networks"] = networksToSend;

    return values;
  }

  factory DataToSave.fromJson(Map<String, dynamic> json) {
    List<dynamic> net = json["networks"];
    var list = net.map((e) {
      return SocialNetwork.load(e);
    }).toList();
    String name = json.containsKey("name") ? json["name"] : "";
    String phone = json.containsKey("phone") ? json["phone"] : "";
    bool audios = json["audios"];
    bool pictures = json["pictures"];
    return DataToSave(name, phone, list, pictures, audios);
  }
}
