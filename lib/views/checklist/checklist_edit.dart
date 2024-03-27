import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/providers/checklist_provider.dart';

class ChecklistField {
  String fieldName;
  bool isRequired;
  String? description;
  String? observation;
  bool isOk;

  ChecklistField(
      {required this.fieldName,
      required this.isRequired,
      this.description,
      this.observation,
      required this.isOk});
}
class EditChecklist extends StatefulWidget {
  final Checklist checklist;

  const EditChecklist({Key? key, required this.checklist}) : super(key: key);

  @override
  State<EditChecklist> createState() => _EditChecklistState();
}

class _EditChecklistState extends State<EditChecklist> {
  final TextEditingController _observacoesGeraisController = TextEditingController();
    final TextEditingController _revisaoController = TextEditingController();
  List<ChecklistField> _checklistFields = [];

  @override
  void initState() {
    super.initState();
    _loadChecklistData();
  }

  void _loadChecklistData() {
    _observacoesGeraisController.text = widget.checklist.observacoesGerais?? '';
    _revisaoController.text = widget.checklist.revisao?? '';
    _checklistFields = widget.checklist.fields.map((field) => ChecklistField(
      fieldName: field['fieldName'] as String,
      isRequired: field['isRequired'] as bool,
      description: field['description'] as String?,
      observation: field['observation'] as String?,
      isOk: field['isOk'] as bool,
    )).toList();
    setState(() {});
  }

  @override
  void dispose() {
    _observacoesGeraisController.dispose();
    super.dispose();
  }

  Future<void> _updateChecklist() async {
    final fieldsFormatted = _checklistFields.map((field) => {
      'fieldName': field.fieldName,
      'isRequired': field.isRequired,
      'description': field.description,
      'observation': field.observation,
      'isOk': field.isOk,
    }).toList();

    String checklistId = widget.checklist.id!;
    Checklist updatedChecklist = Checklist(
      id: checklistId,
      fields: fieldsFormatted,
      observacoesGerais: _observacoesGeraisController.text,
      revisao: _revisaoController.text,
      idRadio: widget.checklist.idRadio,
      idCliente: widget.checklist.idCliente,
      idFazenda: widget.checklist.idFazenda,
      idPivo: widget.checklist.idPivo,
      idTemplate: widget.checklist.idTemplate,
      idResponsavel: widget.checklist.idResponsavel,
      dataCriacao: widget.checklist.dataCriacao,
      dataAtualizacao: DateTime.now(),
    );

    try {
      await Provider.of<ChecklistProvider>(context, listen: false)
          .updateChecklist(updatedChecklist, checklistId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checklist atualizado com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar checklist: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF258F42),
          title: const Text('Atualizar Checklist'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _observacoesGeraisController,
                decoration: const InputDecoration(
                  hintText: "Observações Gerais",
                ),
              ),
              TextField(
                controller: _revisaoController,
                decoration: const InputDecoration(
                  hintText: "Revisão",
                ),
              ),
              ElevatedButton(
                onPressed: _updateChecklist,
                child: const Text('Salvar Alterações'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _checklistFields.length,
                  itemBuilder: (context, index) {
                    final field = _checklistFields[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${field.fieldName} ${field.isRequired ? "- Obrigatório" : ""}'),
                            DropdownButton<bool>(
                              value: field.isOk,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  field.isOk = newValue!;
                                });
                              },
                              items: const [
                                DropdownMenuItem(value: true, child: Text('Ok')),
                                DropdownMenuItem(value: false, child: Text('Não Ok')),
                              ],
                            ),
                            Text('${field.description}'),
                            TextField(
                              onChanged: (value) => field.observation = value,
                              controller: TextEditingController(text: field.observation),
                              decoration: const InputDecoration(
                                hintText: "Observação",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
