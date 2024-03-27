class Checklist {
  final String idRadio;
  final String idFazenda;
  final String idPivo;
  final String idCliente;
  final String? observacoesGerais;
  final String? revisao;
  final String idTemplate;
  final String idResponsavel;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  final List<Map<String, dynamic>> fields;
  final String? id;

  Checklist({
    required this.idRadio,
    required this.idFazenda,
    required this.idPivo,
    required this.idCliente,
    this.observacoesGerais,
    this.revisao,
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
      observacoesGerais: json['observacoes_gerais'] ?? '',
      revisao: json['revisao'] ?? '',
      fields: List<Map<String, dynamic>>.from(
          json['fields'].map((field) => Map<String, dynamic>.from(field))),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id_radio': idRadio,
      'id_fazenda': idFazenda,
      'id_pivo': idPivo,
      'id_cliente': idCliente,
      'id_template': idTemplate,
      'id_responsavel': idResponsavel,
      'observacoes_gerais': observacoesGerais,
      'revisao': revisao,
      'data_criacao': dataCriacao.toIso8601String(),
      'data_atualizacao': dataAtualizacao.toIso8601String(),
      'fields': fields.map((field) => field).toList(),
    };

    if (id != null) {
      json['_id'] = id;
    }

    return json;
  }
}
