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

  void _fetchAllPivos() {
    Provider.of<PivoProvider>(context, listen: false)
        .getAllPivos()
        .then((pivo) {
      if (mounted) {
        setState(() {
          pivoList = pivo;
          filteredPivoList = pivo;
        });
      }
    });
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
        return pivo.name.toLowerCase().contains(query);
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
                if (pivo == null) {
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
    bool isLoading = pivoList == null;

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
                                    future:
                                        _getPivoAsyncData(pivo.idFazenda),
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
                                                        child: Text(
                                                            pivo.name,
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
    );
  }
}
