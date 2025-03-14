import 'package:flutter/material.dart';
import 'package:soilcheck/services/auth_services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService apiService = AuthService();
  String? _token;
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  String _userId = '';

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  bool get isAdmin => _isAdmin;
  String get userId => _userId;

  Future<String> login(String username, String password) async {
    username = username.trim();
    username = username.toLowerCase();
    final response = await apiService.login(username, password);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token'];
      if (_token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);
        _isAdmin = decodedToken['isAdmin'];
        _userId = decodedToken['_id'];
      }
      _isLoggedIn = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
      prefs.setString('userId', _userId);
      notifyListeners();
      return "ok";
    } else {
      final status = response.statusCode;
      final message = json.decode(response.body);
      final message2 = message['message'];
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message2';
      debugPrint(error);
      return message2;
    }
  }
}
