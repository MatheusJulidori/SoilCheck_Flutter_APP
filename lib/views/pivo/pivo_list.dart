import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/fazenda.dart';
import 'package:soilcheck/models/pivo.dart';
import 'package:soilcheck/providers/fazenda_provider.dart';
import 'package:soilcheck/providers/pivo_provider.dart';

class PivoAsyncData {
  final String fazendaName;
  PivoAsyncData({required this.fazendaName});
}

class PivosMain extends StatefulWidget {
  const PivosMain({super.key});

  @override
  State<PivosMain> createState() => _PivosMainState();
}

class _PivosMainState extends State<PivosMain> {
  List<Pivo>? pivoList;
  List<Pivo>? filteredPivoList;
  final TextEditingController _searchController = TextEditingController();

  Map<String, String> fazendaNameMap = {};
  List<Fazenda> fazendaList = [];
  Fazenda? selectedFazenda;
  Iterable<Fazenda>? _filteredFazendaCompletions;
  String _fazendaQuery = '';

  void _fetchAllPivos() async {
    var pivos =
        await Provider.of<PivoProvider>(context, listen: false).getAllPivos();
    var fazendas = await Provider.of<FazendaProvider>(context, listen: false)
        .getAllFazendas();

    fazendaNameMap = {for (var f in fazendas) f.id!: f.name};

    if (mounted) {
      setState(() {
        pivoList = pivos;
        filteredPivoList = pivos;
        fazendaList = fazendas;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllPivos();
    _searchController.addListener(_filterPivos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPivos() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      filteredPivoList = pivoList!.where((pivo) {
        bool nameMatch = pivo.name.toLowerCase().contains(query);
        bool fazendaNameMatch =
            fazendaNameMap[pivo.idFazenda]?.toLowerCase().contains(query) ??
                false;

        return nameMatch || fazendaNameMatch;
      }).toList();
    });
  }

  Future<String> _getFazendaName(String idFazenda) async {
    Fazenda fazenda = await Provider.of<FazendaProvider>(context, listen: false)
        .getFazendaById(idFazenda);
    return fazenda.name;
  }

  Future<PivoAsyncData> _getPivoAsyncData(String idFazenda) async {
    final String fazendaName = await _getFazendaName(idFazenda);
    return PivoAsyncData(fazendaName: fazendaName);
  }

  Future<void> _showEditOrCreateDialog({Pivo? pivo}) async {
    final TextEditingController nameController =
        TextEditingController(text: pivo?.name ?? '');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pivo == null ? 'Adicionar Pivo' : 'Editar Pivo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Nome"),
              ),
                            const SizedBox(height: 20),
              Autocomplete<Fazenda>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  _fazendaQuery = textEditingValue.text;
                  final Iterable<Fazenda> options = (await context
                      .read<FazendaProvider>()
                      .getFazendasWithFilter(_fazendaQuery));
                  if (_fazendaQuery != textEditingValue.text) {
                    if (_filteredFazendaCompletions != null) {
                      return _filteredFazendaCompletions!;
                    }
                  }
                  _filteredFazendaCompletions = options;
                  return options;
                },
                displayStringForOption: (Fazenda option) => option.name,
                onSelected: (Fazenda selection) {
                  setState(() {
                    selectedFazenda = selection;
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "Selecione a fazenda",
                    ),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                if (selectedFazenda == null || nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, preencha todos os dados')),
                  );
                } else if(pivo == null && selectedFazenda != null) {
                  final newPivo = Pivo(
                    name: nameController.text,
                    idFazenda: selectedFazenda!.id!,
                  );
                  await Provider.of<PivoProvider>(context, listen: false)
                      .createPivo(newPivo);
                } else {
                  final updatedPivo = Pivo(
                    id: pivo!.id,
                    name: nameController.text,
                    idFazenda: selectedFazenda!.id!,
                  );
                  await Provider.of<PivoProvider>(context, listen: false)
                      .updatePivo(updatedPivo, pivo.id!);
                }
                Navigator.of(context).pop();
                setState(() {
                  _fetchAllPivos();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 150.0;
    bool isLoading = pivoList == null;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  _fetchAllPivos();
                },
              child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: imageHeight,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset(
                          'assets/images/PivosBG.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Container(
                        color: const Color(0xFFf1f1f1),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    _showEditOrCreateDialog().then((value) {
                                      setState(() {
                                        _fetchAllPivos();
                                      });
                                    });
                                  },
                                  label: const Text('Criar pivo'),
                                )
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Filtrar Pivos',
                                suffixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredPivoList!.length,
                                itemBuilder: (context, index) {
                                  final pivo = filteredPivoList![index];
              
                                  return FutureBuilder<PivoAsyncData>(
                                      future: _getPivoAsyncData(pivo.idFazenda),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Erro: ${snapshot.error}'));
                                        } else {
                                          return Card(
                                            margin: const EdgeInsets.only(
                                                bottom: 16.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                _showEditOrCreateDialog(
                                                        pivo: pivo)
                                                    .then((value) {
                                                  setState(() {
                                                    _fetchAllPivos();
                                                  });
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF258F42),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(pivo.name,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20.0,
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Icon(Icons.edit,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Fazenda: ${snapshot.data!.fazendaName}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
                                                                color:
                                                                    Colors.white,
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ),
      ),
    );
  }
}
