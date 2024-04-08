import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/models/cliente.dart';
import 'package:soilcheck/models/fazenda.dart';
import 'package:soilcheck/models/pivo.dart';
import 'package:soilcheck/providers/checklist_provider.dart';
import 'package:soilcheck/providers/cliente_provider.dart';
import 'package:soilcheck/providers/fazenda_provider.dart';
import 'package:soilcheck/providers/pivo_provider.dart';
import 'package:soilcheck/providers/user_provider.dart';
import 'package:soilcheck/views/checklist/checklist_create.dart';
import 'package:soilcheck/views/checklist/checklist_detail.dart';

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

class ChecklistMain extends StatefulWidget {
  @override
  State<ChecklistMain> createState() => _ChecklistMainState();
}

class _ChecklistMainState extends State<ChecklistMain> {
  List<Checklist>? checklistList;
  List<Checklist>? filteredChecklistList;
  final TextEditingController _searchController = TextEditingController();
  Map<String, String> clienteNameMap = {};
  Map<String, String> fazendaNameMap = {};
  Map<String, String> responsavelNameMap = {};

  void _fetchAllChecklists() async {
    var fazendas = await Provider.of<FazendaProvider>(context, listen: false)
        .getAllFazendas();
    var clientes = await Provider.of<ClienteProvider>(context, listen: false)
        .getAllClientes();
    var responsaveis =
        await Provider.of<UserProvider>(context, listen: false).getAllUsers();
    var checklists =
        await Provider.of<ChecklistProvider>(context, listen: false)
            .getAllChecklists();

    clienteNameMap = {for (var c in clientes) c.id!: c.name};
    fazendaNameMap = {for (var f in fazendas) f.id!: f.name};
    responsavelNameMap = {for (var r in responsaveis) r.id!: r.name};

    if (mounted) {
      setState(() {
        checklistList = checklists;
        filteredChecklistList = checklists;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllChecklists();
    _searchController.addListener(_filterChecklists);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChecklists() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      filteredChecklistList = checklistList!.where((checklist) {
        bool nameMatch = checklist.idRadio.toLowerCase().contains(query);
        bool clienteNameMatch = clienteNameMap[checklist.idCliente]
                ?.toLowerCase()
                .contains(query) ??
            false;
        bool fazendaNameMatch = fazendaNameMap[checklist.idFazenda]
                ?.toLowerCase()
                .contains(query) ??
            false;
        bool responsavelNameMatch = responsavelNameMap[checklist.idResponsavel]
                ?.toLowerCase()
                .contains(query) ??
            false;

        String formattedDate =
            "${checklist.dataCriacao.toLocal().day}/${checklist.dataCriacao.toLocal().month}/${checklist.dataCriacao.toLocal().year}";
        bool dateMatch = formattedDate.contains(query);

        return nameMatch ||
            clienteNameMatch ||
            fazendaNameMatch ||
            responsavelNameMatch ||
            dateMatch;
      }).toList();
    });
  }

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
    const double imageHeight = 150.0;
    bool isLoading = checklistList == null;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  _fetchAllChecklists();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: imageHeight,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset(
                          'assets/images/ChecklistsBG.png',
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
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return CreateChecklist();
                                      }),
                                    ).then((value) {
                                      setState(() {
                                        _fetchAllChecklists();
                                      });
                                    });
                                    if (result != null) {
                                      setState(() {
                                        _fetchAllChecklists();
                                      });
                                    }
                                  },
                                  label: const Text('Criar checklist'),
                                )
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Filtrar Checklists',
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
                                itemCount: filteredChecklistList!.length,
                                itemBuilder: (context, index) {
                                  final checklist =
                                      filteredChecklistList![index];

                                  return FutureBuilder<ChecklistAsyncData>(
                                      future: _getChecklistAsyncData(
                                          checklist.idResponsavel,
                                          checklist.idCliente,
                                          checklist.idFazenda,
                                          checklist.idPivo),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewChecklistPage(
                                                              checklist:
                                                                  checklist)),
                                                ).then((value) => {
                                                      setState(() {
                                                        _fetchAllChecklists();
                                                      })
                                                    });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF258F42),
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                          child: Text(
                                                              checklist.idRadio,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
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
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          Text(
                                                              'Pivo: ${snapshot.data!.pivoName}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          Text(
                                                              'Cliente: ${snapshot.data!.clienteName}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          Text(
                                                              'Responsável: ${snapshot.data!.responsavelName}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          Text(
                                                            'Data: ${checklist.dataCriacao.toLocal().day}/${checklist.dataCriacao.toLocal().month}/${checklist.dataCriacao.toLocal().year}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
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
