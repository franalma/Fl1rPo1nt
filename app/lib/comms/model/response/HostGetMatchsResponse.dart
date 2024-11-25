import 'package:app/model/UserMatch.dart';
import 'package:app/ui/utils/Log.dart';

class HostGetMatchsResponse {
  List<UserMatch>? matchs;

  HostGetMatchsResponse(this.matchs);
  HostGetMatchsResponse.empty();

  factory HostGetMatchsResponse.fromJson(List<dynamic> values) {
    try {
      Log.d("Starts  HostGetMatchsResponse.fromJson $values");
      var matchs = values.map((e) {
        return UserMatch.fromJson(e);
      }).toList();
      return HostGetMatchsResponse(matchs);
    } catch (error, stackTrace) {
      Log.d("${error.toString()}  ${stackTrace.toString()}");
    }
    return HostGetMatchsResponse.empty();
  }
}
