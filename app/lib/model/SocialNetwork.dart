import 'package:app/ui/utils/Log.dart';

class SocialNetwork {
  String networkId = "";
  String name = "";
  String value = "";

  SocialNetwork(this.networkId, this.name, this.value);

  factory SocialNetwork.load(Map<String, dynamic> map) {
    Log.d("Starts SocialNetwork.load $map");
    return SocialNetwork(map["network_id"], map["name"], map["value"]);
  }

  Map<String, dynamic> toHost() {
    return {"network_id": networkId, "name": name, "value": value};
  }

  void print() {
    Log.d("id: ${networkId} name: ${name} value: ${value}");
  }
}
