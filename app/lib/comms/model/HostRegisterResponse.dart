class HostRegisterResponse {
  final int id;
  const HostRegisterResponse({
    required this.id,
  });

  factory HostRegisterResponse.fromJson(Map<String, dynamic> json) {
    return HostRegisterResponse(
      id: json['id'],
    );
  }
}