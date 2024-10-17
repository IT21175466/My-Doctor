import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_doctor/services/secure_storage.dart';

class AuthRepository {
  bool isValiedSession = false;
  Future<void> validateSession(String token) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/session/validate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      isValiedSession = true;
    } else if (response.statusCode == 401) {
      isValiedSession = false;
    } else {
      final data = jsonDecode(response.body);

      String errorMessage = data['error'] ?? 'An unknown error occurred';

      throw errorMessage;
    }
  }

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

      //Get sessionID
      String sessionID = data['token'];

      await SecureStorage().storeSessionToken('token', sessionID);
      print('Token: $sessionID');
    } else {
      final data = jsonDecode(response.body);

      String errorMessage = data['error'] ?? 'An unknown error occurred';

      throw errorMessage;
    }
  }

  //Manual Login
  Future<void> manualLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/auth/manuallogin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //Get sessionID
      String sessionID = data['token'];

      await SecureStorage().storeSessionToken('token', sessionID);
      print('Token: $sessionID');
    } else if (response.statusCode == 401) {
      final data = jsonDecode(response.body);

      String errorMessage = data['message'] ?? 'An unknown error occurred';

      throw errorMessage;
    } else {
      print('Failed to login: ${response.body}');
      final data = jsonDecode(response.body);

      String errorMessage = data['error'] ?? 'An unknown error occurred';

      throw errorMessage;
    }
  }
}
