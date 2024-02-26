class Checklist {
  final String idRadio;
  final String? idFazenda;
  final String? idPivo;
  final String? idCliente;
  final String? idTemplate;
  final String? idResponsavel;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  final List<Map<String,dynamic>> fields;
  final String? id;

  Checklist({
    required this.idRadio,
    this.idFazenda,
    this.idPivo,
    this.idCliente,
    this.idTemplate,
    this.idResponsavel,
    required this.dataCriacao,
    required this.dataAtualizacao,
    required this.fields,
    this.id,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      idRadio: json['idRadio'],
      idFazenda: json['idFazenda'],
      idPivo: json['idPivo'],
      idCliente: json['idCliente'],
      idTemplate: json['idTemplate'],
      idResponsavel: json['idResponsavel'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
      dataAtualizacao: DateTime.parse(json['dataAtualizacao']),
      fields: json['fields'],
      id: json['_id'],
    );
  }
}
