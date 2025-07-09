class OpenTextAnswer {
  final String questionId;
  final String studentId;
  final String responseText;
  final DateTime submittedAt;

  OpenTextAnswer({
    required this.questionId,
    required this.studentId,
    required this.responseText,
    required this.submittedAt,
  });

  factory OpenTextAnswer.fromJson(Map<String, dynamic> json) {
    return OpenTextAnswer(
      questionId: json['questionId'],
      studentId: json['studentId'],
      responseText: json['responseText'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }
}
