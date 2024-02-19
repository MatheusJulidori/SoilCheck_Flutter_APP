import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<http.Response> login(String username, String password) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final data = {
      'username': username,
      'password': password,
    };
    final jsonData = jsonEncode(data);
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: jsonData,
    );

    return res;
  }
}