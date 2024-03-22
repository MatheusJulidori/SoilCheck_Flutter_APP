import 'package:flutter/material.dart';
import 'package:soilcheck/models/user.dart';
import 'package:soilcheck/services/user_services.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  final apiService = UserService();

  Future<User> getUserBySelfId() async {
    final response = await apiService.getUserBySelfId();

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

  Future<List<User>> getAllUsers() async {
    final response = await apiService.getAllUsers();
    List<User> users = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var user in data) {
        users.add(User.fromJson(user));
      }
      notifyListeners();
      return users;
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

  Future<bool> updateUserAdminStatus(String id, bool currentStatus) async {
    final newStatus = !currentStatus;
    final response = await apiService.updateUserAdminStatus(id, newStatus);
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

  Future<bool> updateUserActiveStatus(String id, bool currentStatus) async {
    final newStatus = !currentStatus;
    final response = await apiService.updateUserActiveStatus(id, newStatus);

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
    final response = await apiService.updatePassword(newPW, oldPW);

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

  Future<User> createUser(User user) async {
    final response = await apiService.createUser(user);

    if (response.statusCode == 201) {
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

  Future<String> getUserNameById(String id) async {
    final response = await apiService.getUserNameById(id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final name = data['name'];
      return name;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }
}
