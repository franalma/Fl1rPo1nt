import 'package:app/ui/utils/location.dart';

class Flirt {
  String id = "";
  int createdAt = 0;
  int status = -1;
  Location? location;

  Flirt(this.id, this.createdAt, this.status, this.location);
  Flirt.empty();

  factory Flirt.fromHost(Map<String, dynamic> map) {
    var location =
        Location(map["location"]["latitude"], map["location"]["longitude"]);
    return Flirt(map["flirt_id"], map["created_at"], map["status"], location);
  }
}
