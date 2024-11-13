class SocialNetwork {
  String networkId = "";
  String name = "";
  String value = "";

  SocialNetwork(this.networkId, this.name, this.value);

  factory SocialNetwork.load(Map<String, dynamic> map) {
    return SocialNetwork(map["network_id"], map["name"], map["value"]);
  }
}
