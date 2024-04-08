import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/models/cliente.dart';
import 'package:soilcheck/models/fazenda.dart';
import 'package:soilcheck/models/pivo.dart';
import 'package:soilcheck/models/template.dart';
import 'package:soilcheck/providers/auth_provider.dart';
import 'package:soilcheck/providers/checklist_provider.dart';
import 'package:soilcheck/providers/cliente_provider.dart';
import 'package:soilcheck/providers/fazenda_provider.dart';
import 'package:soilcheck/providers/pivo_provider.dart';
import 'package:soilcheck/providers/template_provider.dart';

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

class CreateChecklist extends StatefulWidget {
  @override
  State<CreateChecklist> createState() => _CreateChecklistState();
}

class _CreateChecklistState extends State<CreateChecklist> {
  final TextEditingController _idRadioController = TextEditingController();
  final TextEditingController _observacoesGeraisController =
      TextEditingController();
  final List<ChecklistField> _checklistFields = [];

  Template? _selectedTemplate;
  Iterable<Template>? _filteredTemplatesCompletions;
  String _templateQuery = '';

  Cliente? _selectedCliente;
  Iterable<Cliente>? _filteredClientesCompletions;
  String _clienteQuery = '';

  Fazenda? _selectedFazenda;
  List<Fazenda> fazendaList = [];
  final List<Fazenda> filteredFazendaList = [];

  Pivo? _selectedPivo;
  List<Pivo> pivoList = [];
  final List<Pivo> filteredPivoList = [];

  void _fetchFazendasAndPivos() async {
    var fazendas = await Provider.of<FazendaProvider>(context, listen: false)
        .getAllFazendas();
    var pivos =
        await Provider.of<PivoProvider>(context, listen: false).getAllPivos();

    if (mounted) {
      setState(() {
        fazendaList = fazendas;
        pivoList = pivos;
      });
    }
  }

  void _initializeChecklistFields() {
    _checklistFields.clear();

    if (_selectedTemplate != null) {
      for (var fieldMap in _selectedTemplate!.fields) {
        var checklistField = ChecklistField(
          fieldName: fieldMap['fieldName'] as String,
          isRequired: fieldMap['isRequired'] as bool,
          description: fieldMap['description'] ?? '',
          observation: '',
          isOk: false,
        );
        _checklistFields.add(checklistField);
      }
    }

    setState(() {});
  }

  void _updateFazendasList() {
    filteredFazendaList.clear();
    _selectedFazenda = null;
    _selectedPivo = null;

    if (_selectedCliente != null) {
      for (var fazenda in fazendaList) {
        if (fazenda.idCliente == _selectedCliente!.id!) {
          filteredFazendaList.add(fazenda);
        }
      }
    }
  }

  void _updatePivosList() {
    filteredPivoList.clear();
    _selectedPivo = null;

    if (_selectedFazenda != null) {
      for (var pivo in pivoList) {
        if (pivo.idFazenda == _selectedFazenda!.id!) {
          filteredPivoList.add(pivo);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFazendasAndPivos();
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
                  _templateQuery = textEditingValue.text;
                  final Iterable<Template> options = (await context
                      .read<TemplateProvider>()
                      .getTemplatesWithFilter(_templateQuery));
                  if (_templateQuery != textEditingValue.text) {
                    if (_filteredTemplatesCompletions != null) {
                      return _filteredTemplatesCompletions!;
                    }
                  }
                  _filteredTemplatesCompletions = options;
                  return options;
                },
                displayStringForOption: (Template option) => option.name,
                onSelected: (Template selection) {
                  setState(() {
                    _selectedTemplate = selection;
                    _initializeChecklistFields();
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "Selecione o Template",
                    ),
                  );
                },
              ),
              Autocomplete<Cliente>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  _clienteQuery = textEditingValue.text;
                  final Iterable<Cliente> options = (await context
                      .read<ClienteProvider>()
                      .getClientesWithFilter(_clienteQuery));
                  if (_clienteQuery != textEditingValue.text) {
                    if (_filteredClientesCompletions != null) {
                      return _filteredClientesCompletions!;
                    }
                  }
                  _filteredClientesCompletions = options;
                  return options;
                },
                displayStringForOption: (Cliente option) => option.name,
                onSelected: (Cliente selection) {
                  setState(() {
                    _selectedCliente = selection;
                    _updateFazendasList();
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "Selecione o Cliente",
                    ),
                  );
                },
              ),
              Container(
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Fazenda>(
                    isExpanded: true,
                    value: _selectedFazenda,
                    hint: const Text("Selecione a Fazenda"),
                    onChanged: (Fazenda? newValue) {
                      setState(() {
                        _selectedFazenda = newValue;
                        _updatePivosList();
                      });
                    },
                    items: filteredFazendaList
                        .map<DropdownMenuItem<Fazenda>>((Fazenda fazenda) {
                      return DropdownMenuItem<Fazenda>(
                        value: fazenda,
                        child: Text(fazenda.name),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Pivo>(
                    isExpanded: true,
                    value: _selectedPivo,
                    hint: const Text("Selecionar Pivo"),
                    onChanged: (Pivo? newValue) {
                      setState(() {
                        _selectedPivo = newValue;
                      });
                    },
                    items: filteredPivoList
                        .map<DropdownMenuItem<Pivo>>((Pivo pivo) {
                      return DropdownMenuItem<Pivo>(
                        value: pivo,
                        child: Text(pivo.name),
                      );
                    }).toList(),
                  ),
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
                    areRequiredFilled = _checklistFields.every((field) =>
                        (field.isRequired && field.observation!.isEmpty)
                            ? false
                            : true);
                  } else {
                    areRequiredFilled = true;
                  }
                  if (_idRadioController.text.isNotEmpty &&
                      areRequiredFilled &&
                      _selectedFazenda != null &&
                      _selectedPivo != null) {
                    final fieldsFormatted = _checklistFields
                        .map((field) => {
                              'fieldName': field.fieldName,
                              'isRequired': field.isRequired,
                              'description': field.description,
                              'observation': field.observation,
                              'isOk': field.isOk,
                            })
                        .toList();

                    Checklist newChecklist = Checklist(
                      idTemplate: _selectedTemplate!.id!,
                      idFazenda: _selectedFazenda!.id!,
                      idCliente: _selectedCliente!.id!,
                      idPivo: _selectedPivo!.id!,
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
                      _selectedCliente = null;
                      _selectedFazenda = null;
                      _selectedPivo = null;
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
                            if(field.description!= null && field.description!='')Text('${field.description}'),
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
