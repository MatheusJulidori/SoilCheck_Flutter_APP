// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/template.dart';
import 'package:soilcheck/providers/template_provider.dart';

class TemplateField {
  String fieldName;
  String? description;
  bool isRequired;

  TemplateField(
      {required this.fieldName, required this.isRequired, this.description});
}

class EditTemplate extends StatefulWidget {
  final Template template;

  const EditTemplate({Key? key, required this.template}) : super(key: key);

  @override
  _EditTemplateState createState() => _EditTemplateState();
}

class _EditTemplateState extends State<EditTemplate> {
  final TextEditingController _templateNameController = TextEditingController();
  late List<TemplateField> _fields;

  @override
  void initState() {
    super.initState();
    _templateNameController.text = widget.template.name;
    _fields = widget.template.fields.map((field) {
      return TemplateField(
          fieldName: field['fieldName'],
          isRequired: field['isRequired'],
          description: field['description']);
    }).toList();
  }

  void _addField() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _addFieldDialog();
      },
    ).then(
      (value) {
        setState(() {});
      },
    );
  }

  AlertDialog _addFieldDialog({TemplateField? editingField}) {
    final TextEditingController _fieldNameController = TextEditingController(
        text: editingField != null ? editingField.fieldName : '');
    final TextEditingController _descriptionController = TextEditingController(
        text: editingField != null ? editingField.description : '');
    bool _isRequired = editingField?.isRequired ?? false;

    return AlertDialog(
      title: Text(editingField == null ? 'Adicionar Campo' : 'Editar Campo'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _fieldNameController,
                  decoration: const InputDecoration(hintText: "Nome do campo"),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: "Descrição"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Obrigatório'),
                    Checkbox(
                      value: _isRequired,
                      onChanged: (bool? value) {
                        setState(() {
                          _isRequired = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Cancelar'),
        ),
        TextButton(
          child: const Text('Confirmar'),
          onPressed: () {
            if (_fieldNameController.text.trim().isEmpty) {
            } else {
              if (editingField == null) {
                _fields.add(TemplateField(
                    fieldName: _fieldNameController.text,
                    description: _descriptionController.text,
                    isRequired: _isRequired));
              } else {
                editingField.fieldName = _fieldNameController.text;
                editingField.description = _descriptionController.text;
                editingField.isRequired = _isRequired;
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF258F42),
          title: const Text('Editar template'),
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
              TextField(
                controller: _templateNameController,
                decoration: const InputDecoration(
                  hintText: "Nome do template",
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addField,
                    child: const Text('Adicionar Campo'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_templateNameController.text.isNotEmpty &&
                          _fields.isNotEmpty) {
                        final fieldsFormatted = _fields
                            .map((field) => {
                                  'fieldName': field.fieldName,
                                  'description': field.description,
                                  'isRequired': field.isRequired,
                                })
                            .toList();

                        Template newTemplate = Template(
                          name: _templateNameController.text,
                          fields: fieldsFormatted,
                        );

                        try {
                          await Provider.of<TemplateProvider>(context,
                                  listen: false)
                              .updateTemplate(newTemplate, widget.template.id!);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Template alterado com sucesso!')),
                          );

                          _templateNameController.clear();
                          setState(() => _fields.clear());
                          Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Falha ao atualizar template: $e')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Por favor, insira o nome e ao menos um campo.')),
                        );
                      }
                    },
                    child: const Text('Confirmar edição'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _fields.length,
                  itemBuilder: (context, index) {
                    final field = _fields[index];
                    return Card(
                      child: ListTile(
                        title: Text(field.fieldName),
                        subtitle:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(field.isRequired ? 'Obrigatório' : 'Opcional'),
                                if (field.description != null) Text('Descrição: ${field.description}'),
                              ],
                            ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _addFieldDialog(editingField: field),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Confirmar remoção'),
                                    content: const Text(
                                        'Tem certeza que deseja remover esse campo?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                        onPressed: () {
                                          setState(() {
                                            _fields.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Remover'),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
