import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soilcheck/models/user.dart';

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

  Future<http.Response> getUserBySelfId() async {
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

  Future<http.Response> getUserNameById(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/user/$id'),
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

  Future<http.Response> updateUserAdminStatus(String id, bool status) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.put(
      Uri.parse('$baseUrl/user/$id'),
      headers: headers,
      body: jsonEncode(<String, bool>{
        'isAdmin': status,
      }),
    );

    return res;
  }

  Future<http.Response> updateUserActiveStatus(String id, bool status) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.put(
      Uri.parse('$baseUrl/user/$id'),
      headers: headers,
      body: jsonEncode(<String, bool>{
        'isActive': status,
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

  Future<http.Response> createUser(User user) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> userMap = user.toJson();

    final res = await http.post(
      Uri.parse('$baseUrl/user/'),
      headers: headers,
      body: jsonEncode(userMap),
    );

    return res;
  }
}
