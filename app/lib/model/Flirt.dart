class Flirt {
  String id = "";
  int createdAt = 0;

  Flirt(this.id, this.createdAt);
  Flirt.empty();

  factory Flirt.fromHost(Map<String, dynamic> map) {    
    return Flirt(map["flirt_id"], map["created_at"]);
  }
}
