import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/cliente.dart';
import 'package:soilcheck/providers/cliente_provider.dart';


class ClientesMain extends StatefulWidget {
  const ClientesMain({super.key});

  @override
  State<ClientesMain> createState() => _ClientesMainState();
}

class _ClientesMainState extends State<ClientesMain> {
  List<Cliente>? clienteList;
  List<Cliente>? filteredClienteList;
  final TextEditingController _searchController = TextEditingController();

  void _fetchAllClientes() {
    Provider.of<ClienteProvider>(context, listen: false)
        .getAllClientes()
        .then((cliente) {
      if (mounted) {
        setState(() {
          clienteList = cliente;
          filteredClienteList = cliente;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllClientes();
    _searchController.addListener(_filterClientes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterClientes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredClienteList = clienteList!.where((cliente) {
        return cliente.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _showEditOrCreateDialog({Cliente? cliente}) async {
    final TextEditingController nameController =
        TextEditingController(text: cliente?.name ?? '');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cliente == null ? 'Adicionar Cliente' : 'Editar Cliente'),
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
                if (cliente == null) {
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
    bool isLoading = clienteList == null;

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
                        'assets/images/ClientesBG.png',
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
                                      _fetchAllClientes();
                                    });
                                  });
                                },
                                label: const Text('Criar cliente'),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Filtrar Clientes',
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
                              itemCount: filteredClienteList!.length,
                              itemBuilder: (context, index) {
                                final cliente = filteredClienteList![index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      _showEditOrCreateDialog(cliente: cliente)
                                          .then((value) {
                                        setState(() {
                                          _fetchAllClientes();
                                        });
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(cliente.name,
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(Icons.edit,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ],
                                          ),
                                        ],
                                      ),
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
                ],
              ),
      ),
    );
  }
}
