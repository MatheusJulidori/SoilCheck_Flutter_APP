import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/models/cliente.dart';
import 'package:soilcheck/models/fazenda.dart';
import 'package:soilcheck/models/pivo.dart';
import 'package:soilcheck/providers/cliente_provider.dart';
import 'package:soilcheck/providers/fazenda_provider.dart';
import 'package:soilcheck/providers/pivo_provider.dart';
import 'package:soilcheck/providers/user_provider.dart';
import 'package:soilcheck/views/checklist/checklist_edit.dart';

class ChecklistAsyncData {
  final String responsavelName;
  final String clienteName;
  final String fazendaName;
  final String pivoName;

  ChecklistAsyncData(
      {required this.responsavelName,
      required this.clienteName,
      required this.fazendaName,
      required this.pivoName});
}

class ViewChecklistPage extends StatefulWidget {
  final Checklist checklist;

  const ViewChecklistPage({Key? key, required this.checklist})
      : super(key: key);

  @override
  State<ViewChecklistPage> createState() => _ViewChecklistPageState();
}

class _ViewChecklistPageState extends State<ViewChecklistPage> {
  Future<String> _getResponsavelName(String idResponsavel) async {
    return await Provider.of<UserProvider>(context, listen: false)
        .getUserNameById(idResponsavel);
  }

  Future<String> _getFazendaName(String idFazenda) async {
    Fazenda fazenda = await Provider.of<FazendaProvider>(context, listen: false)
        .getFazendaById(idFazenda);
    return fazenda.name;
  }

  Future<String> _getClienteName(String idCliente) async {
    Cliente cliente = await Provider.of<ClienteProvider>(context, listen: false)
        .getClienteById(idCliente);
    return cliente.name;
  }

  Future<String> _getPivoName(String idPivo) async {
    Pivo pivo = await Provider.of<PivoProvider>(context, listen: false)
        .getPivoById(idPivo);
    return pivo.name;
  }

  Future<ChecklistAsyncData> _getChecklistAsyncData(String idResponsavel,
      String idCliente, String idFazenda, String idPivo) async {
    final String responsavelName = await _getResponsavelName(idResponsavel);
    final String clienteName = await _getClienteName(idCliente);
    final String fazendaName = await _getFazendaName(idFazenda);
    final String pivoName = await _getPivoName(idPivo);
    return ChecklistAsyncData(
        responsavelName: responsavelName,
        clienteName: clienteName,
        fazendaName: fazendaName,
        pivoName: pivoName);
  }

  @override
  Widget build(BuildContext context) {
    Future<ChecklistAsyncData> asyncData = _getChecklistAsyncData(
      widget.checklist.idResponsavel,
      widget.checklist.idCliente,
      widget.checklist.idFazenda,
      widget.checklist.idPivo,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Checklist'),
        backgroundColor: const Color(0xFF258F42),
      ),
      body: FutureBuilder<ChecklistAsyncData>(
          future: asyncData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }

            ChecklistAsyncData data = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID Radio: ${widget.checklist.idRadio}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('Cliente: ${data.clienteName}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('Fazenda: ${data.fazendaName}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('Pivo: ${data.pivoName}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                              'Observações Gerais: ${widget.checklist.observacoesGerais}',
                              style: const TextStyle(fontSize: 16)),
                          Text('Revisão: ${widget.checklist.revisao}',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditChecklist(
                                      checklist: widget.checklist)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF258F42),
                          ),
                          child: const Text('Editar Checklist'),
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text('Campos do Checklist:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ...widget.checklist.fields.map((field) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                                '${field['fieldName']} - ${field['isOk'] ? 'Ok' : 'Não Ok'}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Descrição: ${field['description']}'),
                                Text(
                                    'Observação: ${field['observation'] ?? 'N/A'}'),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
