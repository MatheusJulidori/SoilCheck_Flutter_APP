import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soilcheck/models/checklist.dart';

class ChecklistService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<http.Response> getAllChecklists() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/checklist'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> getChecklistById(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/checklist/$id'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> updateChecklist(Checklist checklist, String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> checklistMap = checklist.toJson();

    final res = await http.put(
      Uri.parse('$baseUrl/checklist/$id'),
      headers: headers,
      body: jsonEncode(checklistMap),
    );

    return res;
  }

  Future<http.Response> createChecklist(Checklist checklist) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> checklistMap = checklist.toJson();

    final res = await http.post(
      Uri.parse('$baseUrl/checklist/'),
      headers: headers,
      body: jsonEncode(checklistMap),
    );

    return res;
  }

  Future<http.Response> deleteChecklist(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.delete(
      Uri.parse('$baseUrl/checklist/$id'),
      headers: headers,
    );

    return res;
  }
}
