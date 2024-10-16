import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  //Instance
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // Store Token
  Future<void> storeSessionToken(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      print("Error storing session token: $e");
    }
  }
}
