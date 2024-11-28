import 'package:app/ui/utils/Log.dart';

class FileData {
  String? id;
  int createdAat = -1;
  String? file;
  String? url;

  FileData(this.id, this.createdAat, this.file, this.url);
  FileData.empty();

  factory FileData.fromHost(Map<String, dynamic> map) {
    try {
      
      return FileData(
          map["file_id"], map["created_at"], map["file"], map["url"]);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return FileData.empty();
  }
}
