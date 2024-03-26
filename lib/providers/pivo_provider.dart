import 'package:flutter/material.dart';
import 'package:soilcheck/models/pivo.dart';
import 'package:soilcheck/services/pivo_services.dart';
import 'dart:convert';

class PivoProvider extends ChangeNotifier {
  final apiService = PivoService();

  Future<Pivo> getPivoById(String id) async {
    final response = await apiService.getPivoById(id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pivo = Pivo.fromJson(data);
      notifyListeners();
      return pivo;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Pivo>> getAllPivos() async {
    final response = await apiService.getAllPivos();
    List<Pivo> pivos = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var pivo in data) {
        pivos.add(Pivo.fromJson(pivo));
      }
      notifyListeners();
      return pivos;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<List<Pivo>> getPivosWithFilter(String filter) async {
    final response = await apiService.getAllPivos();
    List<Pivo> pivos = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var pivo in data) {
        if (pivo['name'].contains(filter)) {
          pivos.add(Pivo.fromJson(pivo));
        }
      }
      notifyListeners();
      return pivos;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Pivo> updatePivo(Pivo pivo, String id) async {
    final response = await apiService.updatePivo(pivo, id);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pivo = Pivo.fromJson(data);
      notifyListeners();
      return pivo;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<Pivo> createPivo(Pivo pivo) async {
    final response = await apiService.createPivo(pivo);

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final pivo = Pivo.fromJson(data);
      notifyListeners();
      return pivo;
    } else {
      final status = response.statusCode;
      final message = response.body;
      final reason = response.reasonPhrase;
      final error = '$status $reason - $message';
      throw Exception(error);
    }
  }

  Future<void> deletePivo(String id) async {
    final response = await apiService.deletePivo(id);

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
