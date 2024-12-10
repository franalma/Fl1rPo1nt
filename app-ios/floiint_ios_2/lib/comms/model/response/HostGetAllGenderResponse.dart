import 'package:app/model/Gender.dart';

class HostGetAllGenderResponse {
  List<Gender>? genders;

  HostGetAllGenderResponse(this.genders);
  HostGetAllGenderResponse.empty();

  factory HostGetAllGenderResponse.fromJson(List<dynamic> json) {
    List<Gender> list = json.map((e) {
      return Gender.fromJson(e);
    }).toList();

    return HostGetAllGenderResponse(list);
  }
}
