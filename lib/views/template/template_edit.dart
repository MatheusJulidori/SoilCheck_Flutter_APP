import 'package:flutter/material.dart';
import 'package:soilcheck/models/template.dart';

class EditTemplate extends StatefulWidget {
  const EditTemplate({super.key, required this.template});

  final Template template;

  @override
  State<EditTemplate> createState() => _EditTemplateState();
}

class _EditTemplateState extends State<EditTemplate> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Edição de templates'),
    );
  }
}
