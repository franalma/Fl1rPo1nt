class HostGetUserPublicProfileRespone {
  String id = "";

  HostGetUserPublicProfileRespone(this.id);
  HostGetUserPublicProfileRespone.empty();
  

  factory HostGetUserPublicProfileRespone.fromJson(Map<String, dynamic> json) {
    return HostGetUserPublicProfileRespone(json['id']);
  }
}
