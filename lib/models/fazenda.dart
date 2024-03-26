class Fazenda {
  final String name;
  final String idCliente;
  final String? id;

  Fazenda({
    required this.name,
    required this.idCliente,
    this.id,
  });

  factory Fazenda.fromJson(Map<String, dynamic> json) {
    return Fazenda(
      name: json['name'],
      idCliente: json['idCliente'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'idCliente': idCliente,
    };
    if (id != null) {
      json['_id'] = id;
    }

    return json;
  }
}
