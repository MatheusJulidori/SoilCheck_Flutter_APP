import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/cliente.dart';
import 'package:soilcheck/models/fazenda.dart';
import 'package:soilcheck/providers/cliente_provider.dart';
import 'package:soilcheck/providers/fazenda_provider.dart';

class FazendaAsyncData {
  final String clienteName;
  FazendaAsyncData({required this.clienteName});
}

class FazendasMain extends StatefulWidget {
  const FazendasMain({super.key});

  @override
  State<FazendasMain> createState() => _FazendasMainState();
}

class _FazendasMainState extends State<FazendasMain> {
  List<Fazenda>? fazendaList;
  List<Fazenda>? filteredFazendaList;
  final TextEditingController _searchController = TextEditingController();
  Map<String, String> clienteNameMap = {};

  void _fetchAllFazendas() async {
    var fazendas = await Provider.of<FazendaProvider>(context, listen: false).getAllFazendas();
    var clientes = await Provider.of<ClienteProvider>(context, listen: false).getAllClientes();

    clienteNameMap = {for (var c in clientes) c.id!: c.name};

    if (mounted) {
      setState(() {
        fazendaList = fazendas;
        filteredFazendaList = fazendas;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllFazendas();
    _searchController.addListener(_filterFazendas);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFazendas() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      filteredFazendaList = fazendaList!.where((fazenda) {
        bool nameMatch = fazenda.name.toLowerCase().contains(query);
        bool clienteNameMatch = clienteNameMap[fazenda.idCliente]?.toLowerCase().contains(query) ?? false;

        return nameMatch || clienteNameMatch;
      }).toList();
    });
  }

  Future<String> _getClienteName(String idCliente) async {
    Cliente client = await Provider.of<ClienteProvider>(context, listen: false)
        .getClienteById(idCliente);
    return client.name;
  }

  Future<FazendaAsyncData> _getFazendaAsyncData(String idCliente) async {
    final String clienteName = await _getClienteName(idCliente);
    return FazendaAsyncData(clienteName: clienteName);
  }

  Future<void> _showEditOrCreateDialog({Fazenda? fazenda}) async {
    final TextEditingController nameController =
        TextEditingController(text: fazenda?.name ?? '');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(fazenda == null ? 'Adicionar Fazenda' : 'Editar Fazenda'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Nome"),
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
              onPressed: () {
                if (fazenda == null) {
                  // Implement logic to create a new client
                } else {
                  // Implement logic to update the existing client
                }
                Navigator.of(context).pop();
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
    bool isLoading = fazendaList == null;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: imageHeight,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        'assets/images/FazendasBG.png',
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
                                      _fetchAllFazendas();
                                    });
                                  });
                                },
                                label: const Text('Criar fazenda'),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Filtrar Fazendas',
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
                              itemCount: filteredFazendaList!.length,
                              itemBuilder: (context, index) {
                                final fazenda = filteredFazendaList![index];

                                return FutureBuilder<FazendaAsyncData>(
                                    future:
                                        _getFazendaAsyncData(fazenda.idCliente),
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
                                                      fazenda: fazenda)
                                                  .then((value) {
                                                setState(() {
                                                  _fetchAllFazendas();
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
                                                        child: Text(
                                                            fazenda.name,
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
                                                            'Cliente: ${snapshot.data!.clienteName}',
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
    );
  }
}
