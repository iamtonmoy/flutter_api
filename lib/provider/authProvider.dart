import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  static const baseUrl = 'https://rgsapi.daybud.com/v1/universities/';

  Future<void> login(String email, String password, String universityUuid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$universityUuid/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userName': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        handleLoginSuccess(data);
      } else {
        handleLoginError(response.statusCode, response.body);
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  void handleLoginSuccess(Map<String, dynamic> data) {
    notifyListeners();
  }

  void handleLoginError(int statusCode, String responseBody) {
    print('Login failed with status code $statusCode: $responseBody');
  }
}
