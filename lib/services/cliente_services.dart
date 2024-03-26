import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soilcheck/models/cliente.dart';

class ClienteService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<http.Response> getAllClientes() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/cliente'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> getClienteById(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.get(
      Uri.parse('$baseUrl/cliente/$id'),
      headers: headers,
    );

    return res;
  }

  Future<http.Response> updateCliente(Cliente cliente, String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> clienteMap = cliente.toJson();

    final res = await http.put(
      Uri.parse('$baseUrl/cliente/$id'),
      headers: headers,
      body: jsonEncode(clienteMap),
    );

    return res;
  }

  Future<http.Response> createCliente(Cliente cliente) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> clienteMap = cliente.toJson();

    final res = await http.post(
      Uri.parse('$baseUrl/cliente/'),
      headers: headers,
      body: jsonEncode(clienteMap),
    );

    return res;
  }

  Future<http.Response> deleteCliente(String id) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final res = await http.delete(
      Uri.parse('$baseUrl/cliente/$id'),
      headers: headers,
    );

    return res;
  }
}
