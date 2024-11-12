class HostGetPeopleArroundResponse {
  int userId = -1;
  double latitude = -1;
  double longitude = -1;

  HostGetPeopleArroundResponse(this.userId, this.latitude, this.longitude);
  HostGetPeopleArroundResponse.empty();

  factory HostGetPeopleArroundResponse.fromJson(Map<String, dynamic> json) {
    return HostGetPeopleArroundResponse(
        json["user_id"], json["location"][0], json["location"][1]);
  }
}
