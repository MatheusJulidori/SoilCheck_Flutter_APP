import 'package:soilcheck/models/checkComponent.dart';

class CheckModel {
  final String checklistName;
  final String cliente;
  final String fazenda;
  final String identificador;
  final DateTime data;
  final bool checkStatus;
  final List<CheckComponent> componentes;
  final String? id;

  CheckModel({
    required this.checklistName,
    required this.cliente,
    required this.fazenda,
    required this.identificador,
    required this.data,
    required this.checkStatus,
    required this.componentes,
    this.id,
  });
}
