class PendingReview {
  final String atividade;
  final String aluno;
  final double progresso;

  PendingReview({
    required this.atividade,
    required this.aluno,
    required this.progresso,
  });

  factory PendingReview.fromJson(Map<String, dynamic> json) {
    return PendingReview(
      atividade: json['atividade'] ?? '',
      aluno: json['aluno'] ?? '',
      progresso: (json['progresso'] ?? 0).toDouble(),
    );
  }
}
