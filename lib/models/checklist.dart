class Template {
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

  Template({
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
}
