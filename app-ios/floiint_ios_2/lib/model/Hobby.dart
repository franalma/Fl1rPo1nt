class Hobby {
  late int id;
  late String name;

  Hobby(this.id, this.name);
  Hobby.empty();

  factory Hobby.fromHost(Map<String, dynamic> json) {
    return Hobby(json["id"], json["name"]);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }
}
