class Pivo {
  final String name;
  final String idFazenda;
  final String? id;

  Pivo({
    required this.name,
    required this.idFazenda,
    this.id,
  });

  factory Pivo.fromJson(Map<String, dynamic> json) {
    return Pivo(
      name: json['name'],
      idFazenda: json['idFazenda'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'idFazenda': idFazenda,
    };
    if (id != null) {
      json['_id'] = id;
    }

    return json;
  }
}
