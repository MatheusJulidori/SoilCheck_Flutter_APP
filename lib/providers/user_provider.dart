import 'package:flutter/material.dart';
import 'package:soilcheck/models/user.dart';
import 'package:soilcheck/services/user_services.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  final apiService = UserService();

  Future<User> getUserById() async {
    final response = await apiService.getUserById();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = User.fromJson(data);
      notifyListeners();
      return user;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<int> countChecks() async {
    final response = await apiService.countUserChecks();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final count = data;
      return count;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<bool> updateUserName(String name) async {
    final response = await apiService.updateUserName(name);

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

    Future<bool> updatePassword(String newPW, String oldPW) async {
    final response = await apiService.updatePassword(newPW,oldPW);

    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }
}
