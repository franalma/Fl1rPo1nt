class HostResponseTemplate {
  String id = "";

  HostResponseTemplate(this.id);
  HostResponseTemplate.empty();
  

  factory HostResponseTemplate.fromJson(Map<String, dynamic> json) {
    return HostResponseTemplate(json['id']);
  }
}
