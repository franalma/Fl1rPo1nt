import 'package:app/ui/utils/Log.dart';

class SocialNetwork {
  String networkId = "";
  String name = "";
  String value = "";

  SocialNetwork(this.networkId, this.name, this.value);
  SocialNetwork.empty();

  factory SocialNetwork.load(Map<String, dynamic> map) {
    Log.d("Starts SocialNetwork.load $map");
    if (map.isNotEmpty) {
      return SocialNetwork(map["network_id"], map["name"], map["value"]);
    }
    return SocialNetwork.empty();
  }

  Map<String, dynamic> toHost() {
    return {"network_id": networkId, "name": name, "value": value};
  }

  void print() {
    Log.d("id: ${networkId} name: ${name} value: ${value}");
  }
}
