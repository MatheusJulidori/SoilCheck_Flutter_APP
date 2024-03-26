import 'package:flutter/material.dart';
import 'package:soilcheck/models/cliente.dart';
import 'package:soilcheck/services/cliente_services.dart';
import 'dart:convert';

class ClienteProvider extends ChangeNotifier {
  final apiService = ClienteService();

  Future<Cliente> getClienteById(String id) async {
    final response = await apiService.getClienteById(id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cliente = Cliente.fromJson(data);
      notifyListeners();
      return cliente;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Cliente>> getAllClientes() async {
    final response = await apiService.getAllClientes();
    List<Cliente> clientes = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var cliente in data) {
        clientes.add(Cliente.fromJson(cliente));
      }
      notifyListeners();
      return clientes;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Cliente>> getClientesWithFilter(String filter) async {
    final response = await apiService.getAllClientes();
    List<Cliente> clientes = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var cliente in data) {
        if (cliente['name'].contains(filter)) {
          clientes.add(Cliente.fromJson(cliente));
        }
      }
      notifyListeners();
      return clientes;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Cliente> updateCliente(Cliente cliente, String id) async {
    final response = await apiService.updateCliente(cliente, id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cliente = Cliente.fromJson(data);
      notifyListeners();
      return cliente;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Cliente> createCliente(Cliente cliente) async {
    final response = await apiService.createCliente(cliente);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final cliente = Cliente.fromJson(data);
      notifyListeners();
      return cliente;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<void> deleteCliente(String id) async {
    final response = await apiService.deleteCliente(id);

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
