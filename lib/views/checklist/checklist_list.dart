import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/checklist.dart';
import 'package:soilcheck/providers/checklist_provider.dart';
import 'package:soilcheck/providers/user_provider.dart';
import 'package:soilcheck/views/checklist/checklist_create.dart';
import 'package:soilcheck/views/checklist/checklist_edit.dart';

class ChecklistAsyncData {
  final String responsavelName;
  //add more data here and then ,required this.data on the return

  ChecklistAsyncData({required this.responsavelName});
}

class ChecklistMain extends StatefulWidget {
  @override
  State<ChecklistMain> createState() => _ChecklistMainState();
}

class _ChecklistMainState extends State<ChecklistMain> {
  List<Checklist>? checklistList;
  List<Checklist>? filteredChecklistList;
  final TextEditingController _searchController = TextEditingController();

  void _fetchAllChecklists() {
    Provider.of<ChecklistProvider>(context, listen: false)
        .getAllChecklists()
        .then((checklist) {
      if (mounted) {
        setState(() {
          checklistList = checklist;
          filteredChecklistList = checklist;
        });
      }
    });
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
        return checklist.idRadio.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<String> _getResponsavelName(String idResponsavel) async {
    return await Provider.of<UserProvider>(context, listen: false)
        .getUserNameById(idResponsavel);
  }

  Future<ChecklistAsyncData> _getChecklistAsyncData(
      String idResponsavel) async {
    final String responsavelName = await _getResponsavelName(idResponsavel);
    return ChecklistAsyncData(responsavelName: responsavelName);
  }

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 150.0;
    bool isLoading = checklistList == null;

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
                                    _fetchAllChecklists();
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
                                final checklist = filteredChecklistList![index];

                                return FutureBuilder<ChecklistAsyncData>(
                                    future: _getChecklistAsyncData(
                                        checklist.idResponsavel),
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditChecklist(
                                                            checklist:
                                                                checklist)),
                                              );
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
                                                            checklist.idRadio,
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
                                                        if (checklist
                                                                    .idFazenda !=
                                                                null &&
                                                            checklist
                                                                    .idFazenda !=
                                                                '')
                                                          Text(
                                                              'Fazenda: ${checklist.idFazenda}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        if (checklist
                                                                    .idCliente !=
                                                                null &&
                                                            checklist
                                                                    .idCliente !=
                                                                '')
                                                          Text(
                                                              'Cliente: ${checklist.idCliente}',
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
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Text(
                                                          'Data: ${checklist.dataCriacao.toLocal().day}/${checklist.dataCriacao.toLocal().month}/${checklist.dataCriacao.toLocal().year}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.white,
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
    );
  }
}
