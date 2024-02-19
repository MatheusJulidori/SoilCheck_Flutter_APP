class CheckComponent {
  final String checkTitle;
  final String? checkText;
  final String? observacao;
  final bool checkStatus;
  final String? id;

  CheckComponent({
    required this.checkTitle,
    this.observacao,
    required this.checkStatus,
    this.checkText,
    this.id,
  });
}
