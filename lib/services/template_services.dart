import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soilcheck/models/template.dart';

class TemplateService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<http.Response> getAllTemplates() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/template'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> getTemplateById(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/template/$id'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> updateTemplate(Template template, String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> templateMap = template.toJson();

    final res = await http.put(
      Uri.parse('$baseUrl/template/$id'),
      headers: headers,
      body: jsonEncode(templateMap),
    );

    return res;
  }

  Future<http.Response> createTemplate(Template template) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> templateMap = template.toJson();

    final res = await http.post(
      Uri.parse('$baseUrl/template/'),
      headers: headers,
      body: jsonEncode(templateMap),
    );

    return res;
  }

  Future<http.Response> deleteTemplate(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.delete(
      Uri.parse('$baseUrl/template/$id'),
      headers: headers,
    );

    return res;
  }
}
