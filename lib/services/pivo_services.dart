import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soilcheck/models/pivo.dart';

class PivoService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<http.Response> getAllPivos() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/pivo'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> getPivoById(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/pivo/$id'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> updatePivo(Pivo pivo, String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> pivoMap = pivo.toJson();

    final res = await http.put(
      Uri.parse('$baseUrl/pivo/$id'),
      headers: headers,
      body: jsonEncode(pivoMap),
    );

    return res;
  }

  Future<http.Response> createPivo(Pivo pivo) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> pivoMap = pivo.toJson();

    final res = await http.post(
      Uri.parse('$baseUrl/pivo/'),
      headers: headers,
      body: jsonEncode(pivoMap),
    );

    return res;
  }

  Future<http.Response> deletePivo(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.delete(
      Uri.parse('$baseUrl/pivo/$id'),
      headers: headers,
    );

    return res;
  }
}
