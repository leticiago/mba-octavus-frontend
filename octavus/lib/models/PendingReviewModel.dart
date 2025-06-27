class PendingReview {
  final String atividade;
  final String atividadeId;
  final String aluno;
  final String alunoId;
  

  PendingReview({
    required this.atividade,
    required this.aluno,
    required this.atividadeId,
    required this.alunoId,
  });

  factory PendingReview.fromJson(Map<String, dynamic> json) {
    return PendingReview(
      atividade: json['activityName'] ?? '',
      aluno: json['studentName'] ?? '',
      alunoId: json['studentId'] ?? '',
      atividadeId: json['activityId'] ?? '', 
    );
  }
}
