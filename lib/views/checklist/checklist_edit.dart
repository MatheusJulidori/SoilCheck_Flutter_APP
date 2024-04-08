import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/models/cliente.dart';
import 'package:soilcheck/models/fazenda.dart';
import 'package:soilcheck/models/pivo.dart';
import 'package:soilcheck/providers/checklist_provider.dart';
import 'package:soilcheck/providers/cliente_provider.dart';
import 'package:soilcheck/providers/fazenda_provider.dart';
import 'package:soilcheck/providers/pivo_provider.dart';

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
  final TextEditingController _observacoesGeraisController =
      TextEditingController();
  final TextEditingController _revisaoController = TextEditingController();
  List<ChecklistField> _checklistFields = [];

  Cliente? _selectedCliente;
  Iterable<Cliente>? _filteredClientesCompletions;
  String _clienteQuery = '';

  Fazenda? _selectedFazenda;
  List<Fazenda> fazendaList = [];
  final List<Fazenda> filteredFazendaList = [];

  Pivo? _selectedPivo;
  List<Pivo> pivoList = [];
  final List<Pivo> filteredPivoList = [];

  @override
  void initState() {
    super.initState();
    _fetchRelatedData();
    _loadChecklistData();
    _fetchFazendasAndPivos();
  }

  void _loadChecklistData() {
    _observacoesGeraisController.text =
        widget.checklist.observacoesGerais ?? '';
    _revisaoController.text = widget.checklist.revisao ?? '';
    _checklistFields = widget.checklist.fields
        .map((field) => ChecklistField(
              fieldName: field['fieldName'] as String,
              isRequired: field['isRequired'] as bool,
              description: field['description'] as String?,
              observation: field['observation'] as String?,
              isOk: field['isOk'] as bool,
            ))
        .toList();
    setState(() {});
  }

  void _fetchRelatedData() async {
    await Provider.of<ClienteProvider>(context, listen: false)
        .getClienteById(widget.checklist.idCliente)
        .then((cliente) => setState(() {
              _selectedCliente = cliente;
            }));

    await Provider.of<FazendaProvider>(context, listen: false)
        .getFazendaById(widget.checklist.idFazenda)
        .then((fazenda) => setState(() {
              _selectedFazenda = fazenda;
            }));

    await Provider.of<PivoProvider>(context, listen: false)
        .getPivoById(widget.checklist.idPivo)
        .then((pivo) => setState(() {
              _selectedPivo = pivo;
            }));
  }

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
  void dispose() {
    _observacoesGeraisController.dispose();
    super.dispose();
  }

  Future<void> _updateChecklist() async {
    final fieldsFormatted = _checklistFields
        .map((field) => {
              'fieldName': field.fieldName,
              'isRequired': field.isRequired,
              'description': field.description,
              'observation': field.observation,
              'isOk': field.isOk,
            })
        .toList();

    String checklistId = widget.checklist.id!;
    Checklist updatedChecklist = Checklist(
      id: checklistId,
      fields: fieldsFormatted,
      observacoesGerais: _observacoesGeraisController.text,
      revisao: _revisaoController.text,
      idRadio: widget.checklist.idRadio,
      idCliente: _selectedCliente?.id! ?? widget.checklist.idCliente,
      idFazenda: _selectedFazenda?.id! ?? widget.checklist.idFazenda,
      idPivo: _selectedPivo?.id! ?? widget.checklist.idPivo,
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
      Navigator.of(context).pop(true);
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
                            Text(
                                '${field.fieldName} ${field.isRequired ? "- Obrigatório" : ""}'),
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
                            Text('${field.description}'),
                            TextField(
                              onChanged: (value) => field.observation = value,
                              controller: TextEditingController(
                                  text: field.observation),
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
