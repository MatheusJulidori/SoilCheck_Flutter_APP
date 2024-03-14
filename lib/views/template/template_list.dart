import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/template.dart';
import 'package:soilcheck/providers/template_provider.dart';
import 'package:soilcheck/views/template/template_create.dart';
import 'package:soilcheck/views/template/template_edit.dart';

class TemplatesMain extends StatefulWidget {
  @override
  State<TemplatesMain> createState() => _TemplatesMainState();
}

class _TemplatesMainState extends State<TemplatesMain> {
  List<Template>? templateList;
  List<Template>? filteredTemplateList;
  final TextEditingController _searchController = TextEditingController();

  void _fetchAllTemplates() {
    Provider.of<TemplateProvider>(context, listen: false)
        .getAllTemplates()
        .then((template) {
      if (mounted) {
        setState(() {
          templateList = template;
          filteredTemplateList = template;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllTemplates();
    _searchController.addListener(_filterTemplates);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTemplates() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredTemplateList = templateList!.where((template) {
        return template.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 150.0;
    bool isLoading = templateList == null;

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
                        'assets/images/TemplatesBG.png',
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
                                      return CreateTemplate();
                                    }),
                                  ).then((value) {
                                    setState(() {
                                      _fetchAllTemplates();
                                    });
                                  });
                                  if (result != null) {
                                    _fetchAllTemplates();
                                  }
                                },
                                label: const Text('Criar template'),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Filtrar Templates',
                              suffixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), 
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
                              itemCount: filteredTemplateList!.length,
                              itemBuilder: (context, index) {
                                final template = filteredTemplateList![index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditTemplate(
                                                template: template)),
                                      );
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
                                                child: Text(template.name,
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Campos: ${template.fields.length}',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
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
