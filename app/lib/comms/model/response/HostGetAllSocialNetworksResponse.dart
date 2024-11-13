class HostGetAllSocialNetworksResponse {
  int socialNetWorkId = 0; 
  String name = "";
  
  

  HostGetAllSocialNetworksResponse(this.socialNetWorkId, this.name);
  HostGetAllSocialNetworksResponse.empty();

  factory HostGetAllSocialNetworksResponse.fromJson(Map<String, dynamic> json) {
    return HostGetAllSocialNetworksResponse(json["social_network_id"], json["name"]);         
  }
}
