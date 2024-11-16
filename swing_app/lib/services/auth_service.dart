import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://192.168.1.4:3000"; // Your backend URL

  // Register User
  Future<Map<String, dynamic>> register(
      String name, String swingId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'name': name,
        'swingId': swingId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success
    } else {
      return {'error': response.body}; // Error message
    }
  }

  // Login User
  Future<Map<String, dynamic>> login(String swingId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'swingId': swingId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Success
    } else {
      return {'error': response.body}; // Error message
    }
  }
}
