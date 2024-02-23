class Template {
  final String name;
  final List<Map<String,dynamic>> fields;
  final String? id;

  Template({
    required this.name,
    required this.fields,
    this.id,
  });
}
