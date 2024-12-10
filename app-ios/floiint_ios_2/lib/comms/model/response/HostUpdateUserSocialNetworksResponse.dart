
class HostUpdateUserSocialNetworksResponse {
String networkId = ""; 
  String name = "";
  String value = "";
  
  

  HostUpdateUserSocialNetworksResponse(this.networkId, this.name, this.value);
  HostUpdateUserSocialNetworksResponse.empty();

  factory HostUpdateUserSocialNetworksResponse.fromJson(Map<String, dynamic> json) {
    return HostUpdateUserSocialNetworksResponse(json["network_id"], json["name"], json["value"]);         
  }
}
