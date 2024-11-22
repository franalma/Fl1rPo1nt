import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> saveSecureData(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureData(String key) async {
    return await secureStorage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await secureStorage.delete(key: key);
  }

}
