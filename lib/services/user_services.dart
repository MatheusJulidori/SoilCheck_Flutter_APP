import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<http.Response> getAllUsers() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/user/'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> getUserById() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    String? userId = prefs.getString('userId');
    if (userId == null) {
      throw Exception('User ID not saved on login');
    }

    final res = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> countUserChecks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    String? userId = prefs.getString('userId');
    if (userId == null) {
      throw Exception('User ID not saved on login');
    }

    final res = await http.post(
      Uri.parse('$baseUrl/checklist/count_checks/$userId'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> updateUserName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    String? userId = prefs.getString('userId');
    if (userId == null) {
      throw Exception('User ID not saved on login');
    }

    final res = await http.put(
      Uri.parse('$baseUrl/user/$userId'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    return res;
  }

  Future<http.Response> updatePassword(String newPW, String oldPW) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    String? userId = prefs.getString('userId');
    if (userId == null) {
      throw Exception('User ID not saved on login');
    }

    final res = await http.put(
      Uri.parse('$baseUrl/user/changePassword/$userId'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'newPassword': newPW,
        'oldPassword': oldPW,
      }),
    );

    return res;
  }
}
