class Template {
  final String name;
  final List<Map<String,dynamic>> fields;
  final String? id;

  Template({
    required this.name,
    required this.fields,
    this.id,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      name: json['name'],
      fields: json['fields'],
      id: json['_id'],
    );
  }
}
