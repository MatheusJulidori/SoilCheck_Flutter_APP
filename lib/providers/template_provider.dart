import 'package:flutter/material.dart';
import 'package:soilcheck/models/template.dart';
import 'package:soilcheck/services/template_services.dart';
import 'dart:convert';

class TemplateProvider extends ChangeNotifier {
  final apiService = TemplateService();

  Future<Template> getTemplateById(String id) async {
    final response = await apiService.getTemplateById(id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final template = Template.fromJson(data);
      notifyListeners();
      return template;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Template>> getAllTemplates() async {
    final response = await apiService.getAllTemplates();
    List<Template> templates = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var template in data) {
        templates.add(Template.fromJson(template));
      }
      notifyListeners();
      return templates;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Template> updateTemplate(Template template, String id) async {
    final response = await apiService.updateTemplate(template, id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final template = Template.fromJson(data);
      notifyListeners();
      return template;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Template> createTemplate(Template template) async {
    final response = await apiService.createTemplate(template);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final template = Template.fromJson(data);
      notifyListeners();
      return template;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<void> deleteTemplate(String id) async {
    final response = await apiService.deleteTemplate(id);

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
