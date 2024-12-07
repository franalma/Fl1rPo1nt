import 'dart:convert';

import 'package:app/ui/utils/Log.dart';

class RelationShip {
  int id = 0;
  String value = "";
  String color = "";

  RelationShip(this.id, this.value, this.color);
  RelationShip.empty();

  factory RelationShip.load(Map<String, dynamic> values) {
    try {
      Log.d("Starts RelationShip.load: ${jsonEncode(values)}");
      var color = values.containsKey("color") ? values["color"] : "";
      return RelationShip(values["id"], values["name"], color);
    } catch (error) {
      Log.d(error.toString());
    }
    return RelationShip.empty();
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": value, "color": color};
  }
}

class SexAlternative {
  int id = 0;
  String name = "";
  String color = "";

  SexAlternative(this.id, this.name, this.color);
  SexAlternative.empty();
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "color": color};
  }

  factory SexAlternative.load(Map<String, dynamic> values) {
    try {
      Log.d("Starts SexAlternative.load: ${jsonEncode(values)}");
      var color = values.containsKey("color") ? values["color"] : "";
      return SexAlternative(values["id"], values["name"], color);
    } catch (error) {
      Log.d(error.toString());
    }
    return SexAlternative.empty();
  }
}
