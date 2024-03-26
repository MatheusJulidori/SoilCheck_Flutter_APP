class Cliente {
  final String name;
  final String? id;

  Cliente({
    required this.name,
    this.id,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      name: json['name'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json ={
      'name': name,
    };
      if (id != null) {
      json['_id'] = id;
    }

    return json;
  }
}
