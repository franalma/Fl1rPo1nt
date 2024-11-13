import 'package:app/model/UserInterest.dart';

class HostGetAllSexRelationshipResponse {
  late List<SexAlternative> sexAlternatives;
  late List<RelationShip> relationships;

  HostGetAllSexRelationshipResponse(this.sexAlternatives, this.relationships);
  HostGetAllSexRelationshipResponse.empty();

  factory HostGetAllSexRelationshipResponse.fromJson(
      Map<String, dynamic> json) {
    List<dynamic> sexOrientations = json["sex_orientation"];
    List<dynamic> relationShips = json["type_relationships"];

    var sexAlternatives =
        sexOrientations.map((item) => SexAlternative.load(item)).toList();
    var relationship =
        relationShips.map((item) => RelationShip.load(item)).toList();

    return HostGetAllSexRelationshipResponse(sexAlternatives, relationship);
  }
}
