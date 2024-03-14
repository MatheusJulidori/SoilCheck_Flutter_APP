class Template {
  final String name;
  final List<Map<String, dynamic>> fields;
  final String? id;

  Template({
    required this.name,
    required this.fields,
    this.id,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      name: json['name'],
      fields: List<Map<String, dynamic>>.from(
          json['fields'].map((field) => Map<String, dynamic>.from(field))),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'fields': fields.map((field) => field).toList(),
    };

    if (id != null) {
      json['_id'] = id;
    }

    return json;
  }
}
