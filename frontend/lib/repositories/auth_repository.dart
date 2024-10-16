import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_doctor/services/secure_storage.dart';

class AuthRepository {
  //Manual SignUp
  Future<void> manualSignUp(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/auth/manualsignup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //Get Session Token
      String sessionToken = data['token'];

      await SecureStorage().storeSessionToken('token', sessionToken);
      print('Token: $sessionToken');
    } else {
      print('Failed to SighUp: ${response.body}');
      final data = jsonDecode(response.body);

      String errorMessage = data['error'] ?? 'An unknown error occurred';

      throw errorMessage;
    }
  }
}
