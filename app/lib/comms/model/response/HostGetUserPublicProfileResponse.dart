import 'dart:convert';

import 'package:app/model/UserPublicProfile.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetUserPublicProfileResponse {
  UserPublicProfile? profile;

  HostGetUserPublicProfileResponse(this.profile);
  HostGetUserPublicProfileResponse.empty();

  factory HostGetUserPublicProfileResponse.fromJson(Map<String, dynamic> json) {
    Log.d("HostGetUserPublicProfileResponse.fromJson ${jsonEncode(json)}");
    var userProfile = UserPublicProfile.fromJson(json);
    return HostGetUserPublicProfileResponse(userProfile);
  }
}
