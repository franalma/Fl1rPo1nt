class FileData {
  String? id;
  int createdAat = -1;
  String? file; 

  FileData(this.id, this.createdAat, this.file);

  factory FileData.fromHost(Map<String, dynamic> map) {
    return FileData(map["file_id"], map["created_at"], map["file"]);
  }
}
