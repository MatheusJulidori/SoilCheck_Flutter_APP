import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/models/template.dart';
import 'package:soilcheck/providers/auth_provider.dart';
import 'package:soilcheck/providers/checklist_provider.dart';
import 'package:soilcheck/providers/template_provider.dart';

class ChecklistField {
  String fieldName;
  bool isRequired;
  String? observation;
  bool isOk;

  ChecklistField(
      {required this.fieldName,
      required this.isRequired,
      this.observation,
      required this.isOk});
}

class CreateChecklist extends StatefulWidget {
  @override
  State<CreateChecklist> createState() => _CreateChecklistState();
}

class _CreateChecklistState extends State<CreateChecklist> {
  final TextEditingController _fazendaController = TextEditingController();
  final TextEditingController _pivoController = TextEditingController();
  final TextEditingController _idRadioController = TextEditingController();
  final TextEditingController _observacoesGeraisController =
      TextEditingController();
  Template? _selectedTemplate;
  final List<ChecklistField> _checklistFields = [];
  Iterable<Template>? _filteredAutocompletions;
  String _searchingWithQuery = '';

  void _initializeChecklistFields() {
    _checklistFields.clear();

    if (_selectedTemplate != null) {
      for (var fieldMap in _selectedTemplate!.fields) {
        var checklistField = ChecklistField(
          fieldName: fieldMap['fieldName'] as String,
          isRequired: fieldMap['isRequired'] as bool,
          observation: '',
          isOk: false,
        );
        _checklistFields.add(checklistField);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userId = context.read<AuthProvider>().userId;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF258F42),
          title: const Text('Preencher Checklist'),
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
              Autocomplete<Template>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  _searchingWithQuery = textEditingValue.text;
                  final Iterable<Template> options = (await context
                      .read<TemplateProvider>()
                      .getTemplatesWithFilter(_searchingWithQuery));
                  if (_searchingWithQuery != textEditingValue.text) {
                    if (_filteredAutocompletions != null) {
                      return _filteredAutocompletions!;
                    }
                  }
                  _filteredAutocompletions = options;
                  return options;
                },
                displayStringForOption: (Template option) => option.name,
                onSelected: (Template selection) {
                  setState(() {
                    _selectedTemplate = selection;
                    _initializeChecklistFields();
                  });
                },
              ),
              TextField(
                controller: _fazendaController,
                decoration: const InputDecoration(
                  hintText: "Fazenda",
                ),
              ),
              TextField(
                controller: _pivoController,
                decoration: const InputDecoration(
                  hintText: "Pivo",
                ),
              ),
              TextField(
                controller: _idRadioController,
                decoration: const InputDecoration(
                  hintText: "Radio",
                ),
              ),
              TextField(
                controller: _observacoesGeraisController,
                decoration: const InputDecoration(
                  hintText: "Observações Gerais",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final bool areRequiredFilled;
                  if (_checklistFields.isNotEmpty) {
                    areRequiredFilled = _checklistFields.every(
                        (field) => (field.isRequired && field.observation!.isEmpty) ? false : true);
                  } else {
                    areRequiredFilled = true;
                  }
                  if (_idRadioController.text.isNotEmpty &&
                      areRequiredFilled) {
                    final fieldsFormatted = _checklistFields
                        .map((field) => {
                              'fieldName': field.fieldName,
                              'isRequired': field.isRequired,
                              'observation': field.observation,
                              'isOk': field.isOk,
                            })
                        .toList();

                    Checklist newChecklist = Checklist(
                      idTemplate: _selectedTemplate!.id!,
                      idFazenda: _fazendaController.text,
                      idPivo: _pivoController.text,
                      idRadio: _idRadioController.text,
                      observacoesGerais: _observacoesGeraisController.text,
                      revisao: '',
                      idResponsavel: userId,
                      dataCriacao: DateTime.now(),
                      dataAtualizacao: DateTime.now(),
                      fields: fieldsFormatted,
                    );

                    try {
                      await Provider.of<ChecklistProvider>(context,
                              listen: false)
                          .createChecklist(newChecklist);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Checklist preenchido com sucesso!')),
                      );

                      _idRadioController.clear();
                      _fazendaController.clear();
                      _pivoController.clear();
                      _observacoesGeraisController.clear();
                      setState(() => _checklistFields.clear());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Falha ao salvar checklist: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Por favor, insira o ID do radio e preencha a observação dos campos obrigatórios.')),
                    );
                  }
                },
                child: const Text('Salvar Checklist'),
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
                            Text(
                                '${field.fieldName} ${field.isRequired ? '- Obrigatório' : ''}'),
                            DropdownButton<bool>(
                              value: field.isOk,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  field.isOk = newValue!;
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                    value: true, child: Text('Ok')),
                                DropdownMenuItem(
                                    value: false, child: Text('Não Ok')),
                              ],
                            ),
                            TextField(
                              onChanged: (value) {
                                field.observation = value;
                              },
                              decoration: const InputDecoration(
                                hintText: "Observação",
                                labelStyle: TextStyle(fontSize: 12),
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
