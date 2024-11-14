class Flirt {
  String id = "";
  int createdAt = 0;

  Flirt(this.id, this.createdAt);
  Flirt.empty();

  factory Flirt.fromHost() {
    return Flirt.empty();
  }
}
