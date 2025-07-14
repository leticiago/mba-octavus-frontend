class StudentProfessor {
  final String studentEmail;
  final String professorId;
  final String instrumentId;

  StudentProfessor({required this.studentEmail, required this.professorId, required this.instrumentId});

  factory StudentProfessor.fromJson(Map<String, dynamic> json) {
    return StudentProfessor(
      studentEmail: json['studentEmail'] as String,
      professorId: json['professorId'] as String,
      instrumentId: json['instrumentId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentEmail': studentEmail,
      'professorId': professorId,
      'instrumentId': instrumentId,
    };
  }
}
