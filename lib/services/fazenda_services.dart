import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soilcheck/models/fazenda.dart';

class FazendaService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<http.Response> getAllFazendas() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/fazenda'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> getFazendaById(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/fazenda/$id'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> updateFazenda(Fazenda fazenda, String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> fazendaMap = fazenda.toJson();

    final res = await http.put(
      Uri.parse('$baseUrl/fazenda/$id'),
      headers: headers,
      body: jsonEncode(fazendaMap),
    );

    return res;
  }

  Future<http.Response> createFazenda(Fazenda fazenda) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> fazendaMap = fazenda.toJson();

    final res = await http.post(
      Uri.parse('$baseUrl/fazenda/'),
      headers: headers,
      body: jsonEncode(fazendaMap),
    );

    return res;
  }

  Future<http.Response> deleteFazenda(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.delete(
      Uri.parse('$baseUrl/fazenda/$id'),
      headers: headers,
    );

    return res;
  }
}
