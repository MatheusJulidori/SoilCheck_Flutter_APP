import 'package:flutter/material.dart';
import 'package:soilcheck/models/checklist.dart';

class EditChecklist extends StatelessWidget {
  const EditChecklist({super.key, required this.checklist});

  final Checklist checklist;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Editar checklist'),
    );
  }
}
