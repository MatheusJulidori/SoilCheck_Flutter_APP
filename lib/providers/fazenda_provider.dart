import 'package:flutter/material.dart';
import 'package:soilcheck/models/fazenda.dart';
import 'package:soilcheck/services/fazenda_services.dart';
import 'dart:convert';

class FazendaProvider extends ChangeNotifier {
  final apiService = FazendaService();

  Future<Fazenda> getFazendaById(String id) async {
    final response = await apiService.getFazendaById(id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fazenda = Fazenda.fromJson(data);
      notifyListeners();
      return fazenda;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Fazenda>> getAllFazendas() async {
    final response = await apiService.getAllFazendas();
    List<Fazenda> fazendas = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var fazenda in data) {
        fazendas.add(Fazenda.fromJson(fazenda));
      }
      notifyListeners();
      return fazendas;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Fazenda>> getFazendasWithFilter(String filter) async {
    final response = await apiService.getAllFazendas();
    List<Fazenda> fazendas = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var fazenda in data) {
        if (fazenda['name'].contains(filter)) {
          fazendas.add(Fazenda.fromJson(fazenda));
        }
      }
      notifyListeners();
      return fazendas;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Fazenda> updateFazenda(Fazenda fazenda, String id) async {
    final response = await apiService.updateFazenda(fazenda, id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fazenda = Fazenda.fromJson(data);
      notifyListeners();
      return fazenda;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Fazenda> createFazenda(Fazenda fazenda) async {
    final response = await apiService.createFazenda(fazenda);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final fazenda = Fazenda.fromJson(data);
      notifyListeners();
      return fazenda;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<void> deleteFazenda(String id) async {
    final response = await apiService.deleteFazenda(id);

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
