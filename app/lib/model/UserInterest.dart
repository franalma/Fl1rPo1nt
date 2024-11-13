import 'package:app/ui/utils/Log.dart';

class RelationShip {
  int id = 0;
  String value = "";

  RelationShip(this.id, this.value);
  RelationShip.empty();

  factory RelationShip.load(Map<String, dynamic> values) {
    try {
      return RelationShip(values["id"], values["name"]);
    } catch (error) {
      Log.d(error.toString());
    }
    return RelationShip.empty();
  }
}

class SexAlternative {
  int id = 0;
  String name = "";

  SexAlternative(this.id, this.name);
  SexAlternative.empty();

  factory SexAlternative.load(Map<String, dynamic> values) {
    try {
      return SexAlternative(values["id"], values["name"]);
    } catch (error) {
      Log.d(error.toString());
    }
    return SexAlternative.empty();
  }
}

