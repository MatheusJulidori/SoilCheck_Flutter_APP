import 'package:flutter/material.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/services/checklist_services.dart';
import 'dart:convert';

class ChecklistProvider extends ChangeNotifier {
  final apiService = ChecklistService();

  Future<Checklist> getChecklistById(String id) async {
    final response = await apiService.getChecklistById(id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final checklist = Checklist.fromJson(data);
      notifyListeners();
      return checklist;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Checklist>> getAllChecklists() async {
    final response = await apiService.getAllChecklists();
    List<Checklist> checklists = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var checklist in data) {
        checklists.add(Checklist.fromJson(checklist));
      }
      notifyListeners();
      return checklists;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Checklist> updateChecklist(Checklist checklist, String id) async {
    final response = await apiService.updateChecklist(checklist, id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final checklist = Checklist.fromJson(data);
      notifyListeners();
      return checklist;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Checklist> createChecklist(Checklist checklist) async {
    final response = await apiService.createChecklist(checklist);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final checklist = Checklist.fromJson(data);
      notifyListeners();
      return checklist;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<void> deleteChecklist(String id) async {
    final response = await apiService.deleteChecklist(id);

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }
}
