class Checklist {
  final String idRadio;
  final String? idFazenda;
  final String? idPivo;
  final String? idCliente;
  final String idTemplate;
  final String idResponsavel;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  final List<Map<String, dynamic>> fields;
  final String? id;

  Checklist({
    required this.idRadio,
    this.idFazenda,
    this.idPivo,
    this.idCliente,
    required this.idTemplate,
    required this.idResponsavel,
    required this.dataCriacao,
    required this.dataAtualizacao,
    required this.fields,
    this.id,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      idRadio: json['id_radio'],
      idFazenda: json['id_fazenda'] ?? '',
      idPivo: json['id_pivo'] ?? '',
      idCliente: json['id_cliente'] ?? '',
      idTemplate: json['id_template'],
      idResponsavel: json['id_responsavel'],
      dataCriacao: DateTime.parse(json['data_criacao']),
      dataAtualizacao: DateTime.parse(json['data_atualizacao']),
      fields: List<Map<String, dynamic>>.from(
          json['fields'].map((field) => Map<String, dynamic>.from(field))),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'idRadio': idRadio,
      'idFazenda': idFazenda,
      'idPivo': idPivo,
      'idCliente': idCliente,
      'idTemplate': idTemplate,
      'idResponsavel': idResponsavel,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAtualizacao': dataAtualizacao.toIso8601String(),
      'fields': fields.map((field) => field).toList(),
    };

    if (id != null) {
      json['_id'] = id;
    }

    return json;
  }
}
