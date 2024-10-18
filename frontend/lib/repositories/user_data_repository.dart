import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDataRepository {
  String userEmail = '';
//Get User Data
  Future<void> getUserEmail(String sessionId) async {
    final response = await http.get(
      Uri.parse('http://54.224.123.215:8080/api/user/userinfo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': sessionId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userEmail = data['email'];
    } else {
      final data = jsonDecode(response.body);

      String errorMessage = data['error'] ?? 'An unknown error occurred';

      throw errorMessage;
    }
  }
}
